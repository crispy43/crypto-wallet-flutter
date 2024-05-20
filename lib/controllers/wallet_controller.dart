import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:crypto_wallet/constants/hd_constants.dart';
import 'package:crypto_wallet/controllers/eth_controller.dart';
import 'package:crypto_wallet/controllers/message_controller.dart';
import 'package:crypto_wallet/databases/adaptors/base_key_adaptor.dart';
import 'package:crypto_wallet/databases/adaptors/wallet_branch_adaptor.dart';
import 'package:crypto_wallet/databases/adaptors/wallet_root_adaptor.dart';
import 'package:crypto_wallet/models/blockchain/erc20.dart';
import 'package:crypto_wallet/models/blockchain/eth_network.dart';
import 'package:crypto_wallet/models/wallet/current_wallet.dart';
import 'package:crypto_wallet/services/wallet/functions/query_functions.dart';
import 'package:crypto_wallet/services/wallet/token_service.dart'
    as token_service;
import 'package:crypto_wallet/services/wallet/wallet_service.dart'
    as wallet_service;
import 'package:crypto_wallet/services/wallet/eth_service.dart' as eth_service;

class WalletController with ChangeNotifier {
  List<WalletRoot>? walletRoots;
  CurrentWallet? currentWallet;
  final EthController ethController;
  Map<BaseKey, Map<EthNetwork, double>> coinMap = {};
  Map<BaseKey, Map<ERC20, double>> tokenMap = {};

  WalletController({
    this.walletRoots,
    this.currentWallet,
    required this.ethController,
  });

  bool get isLoaded => (walletRoots != null);
  bool get isRegistered => (isLoaded && walletRoots!.isNotEmpty);
  bool get isLoadedCurrentWallet => (isLoaded && currentWallet != null);

  // * Subcribe
  void subscribe() {
    ethController.addListener(onChangedNetwork);
  }

  // * Dispose
  @override
  void dispose() {
    ethController.removeListener(onChangedNetwork);
    super.dispose();
  }

  // * 로드
  Future<void> load() async {
    walletRoots = await readAllWalletRoots();
    currentWallet = await wallet_service.getCurrentWallet();
    if (walletRoots!.isNotEmpty && currentWallet == null) {
      final List<WalletBranch> walletBranches = await findWalletBranches({
        walletWord: walletRoots!.first.wallet,
      });
      await wallet_service.changeCurrentWallet(
        walletBranch: walletBranches.first,
        baseKey: walletBranches.first.keys.first,
      );
      currentWallet = await wallet_service.getCurrentWallet();
    }
    notifyListeners();
  }

  // * 지갑 생성
  Future<void> createWallet({
    required String code,
    required String rootType,
    required String walletName,
    required List<String> networkTypes,
    required bool isBackedUp,
    bool termsAgreement = true,
    bool isWillChange = true,
  }) async {
    try {
      final Map<String, dynamic> walletMap = await wallet_service.createWallet(
        code: code,
        rootType: rootType,
        walletName: walletName,
        networkTypes: networkTypes,
        isBackedUp: isBackedUp,
      );
      if (isWillChange && isLoadedCurrentWallet) {
        final WalletBranch walletBranch = walletMap[walletBranchesWord]
            .firstWhere((WalletBranch el) =>
                el.coinType == currentWallet!.walletBranch.coinType);
        await changeWallet(walletBranch: walletBranch);
      } else {
        await load();
      }
    } catch (_) {
      return;
    }
  }

  // * 지갑 변경
  Future<void> changeWallet({
    required WalletBranch walletBranch,
    BaseKey? baseKey,
  }) async {
    if (!isRegistered) return;

    await wallet_service.changeCurrentWallet(
      walletBranch: walletBranch,
      baseKey: baseKey ?? walletBranch.keys.first,
    );
    await load();
    initCoinMap();
    initTokenMap();
    fetchTokenBalances();
  }

  // * 주소 추가
  Future<void> addAddress(
    String? label, {
    String? type,
    bool isWillChange = true,
  }) async {
    if (!isLoadedCurrentWallet) return;

    final BaseKey newKey = await wallet_service.generateAddress(
      wallet: currentWallet!.wallet,
      coinType: currentWallet!.walletBranch.coinType,
      label: label == '' ? null : label,
    );

    if (isWillChange) {
      await changeWallet(
        walletBranch: currentWallet!.walletBranch,
        baseKey: newKey,
      );
    }
  }

  // * Coins 잔액 초기화
  void initCoinMap() {
    if (!isLoadedCurrentWallet) return;
    for (BaseKey account in currentWallet!.walletBranch.keys) {
      final Map<EthNetwork, double> tempBalanceMap = {};
      for (EthNetwork ethNetwork in ethController.options) {
        tempBalanceMap[ethNetwork] = 0.0;
      }

      coinMap[account] = tempBalanceMap;
    }
  }

  // * Tokens 잔액 초기화
  void initTokenMap() {
    if (!isLoadedCurrentWallet) return;

    for (BaseKey account in currentWallet!.walletBranch.keys) {
      final Map<ERC20, double> tempBalanceMap = {};
      for (ERC20 token in ethController.tokens) {
        tempBalanceMap[token] = 0.0;
      }
      tokenMap[account] = tempBalanceMap;
    }
  }

  // * 네트워크 설정 변경시
  void onChangedNetwork() {
    initTokenMap();
    fetchCoinBalances();
    fetchTokenBalances();
  }

  // * 현재 지갑 전체 코인 잔액 페치
  Future<void> fetchCoinBalances() async {
    if (!isLoadedCurrentWallet) return;

    final List<Future<double>> futures = [];
    for (BaseKey account in currentWallet!.walletBranch.keys) {
      futures.add(
        eth_service.getBalance(
          client: ethController.client,
          address: account.address,
        ),
      );
    }
    final List<double> result = await Future.wait(futures);

    for (int i = 0; i < result.length; i++) {
      coinMap[currentWallet!.walletBranch.keys[i]]![ethController.network] =
          result[i];
    }

    notifyListeners();
  }

  // * 현재 지갑 전체 토큰 잔액 페치
  Future<void> fetchTokenBalances() async {
    if (!isLoadedCurrentWallet) return;

    for (BaseKey account in currentWallet!.walletBranch.keys) {
      final List<Future<double>> futures = [];
      for (ERC20 token in ethController.tokens) {
        futures.add(token_service.getBalance(
          client: ethController.client,
          erc20: token,
          address: account.address,
        ));
      }
      final List<double> result = await Future.wait(futures);
      for (int i = 0; i < result.length; i++) {
        tokenMap[account]![ethController.tokens[i]] = result[i];
      }
    }

    notifyListeners();
  }

  // * 코인 잔액 coinMap에서 조회
  double getBalanceFromCoinMap(BaseKey account, EthNetwork ethNetwork) {
    if (coinMap.values.isEmpty) return 0.0;
    return coinMap[account]![ethNetwork] ?? 0.0;
  }

  // * 토큰 잔액 tokenMap에서 조회
  double getBalanceFromTokenMap(BaseKey account, ERC20 token) {
    if (tokenMap.values.isEmpty) return 0.0;
    return tokenMap[account]![token] ?? 0.0;
  }

  // * 토큰 전송
  Future<void> sendToken({
    required BaseKey account,
    required ERC20 token,
    required String toAddress,
    required String amount,
    required MessageController messageController,
  }) async {
    String txHash = await token_service.sendToken(
      chainId: ethController.network.chainId,
      client: ethController.client,
      erc20: token,
      rootId: currentWallet!.walletBranch.walletRoot.rootId,
      fromKey: account,
      toAddress: toAddress,
      amount: amount,
    );
    messageController.notifyMessage(message: '트랜잭션을 전송했습니다.');
  }

  // * 코인 전송
  Future<void> sendCoin({
    required BaseKey account,
    required String toAddress,
    required String amount,
    required MessageController messageController,
  }) async {
    String txHash = await eth_service.sendCoin(
      chainId: ethController.network.chainId,
      client: ethController.client,
      rootId: currentWallet!.walletBranch.walletRoot.rootId,
      fromKey: account,
      toAddress: toAddress,
      amount: amount,
    );
    messageController.notifyMessage(message: '트랜잭션을 전송했습니다.');
  }
}
