import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:crypto_wallet/constants/box_constants.dart';
import 'package:crypto_wallet/constants/hd_constants.dart';
import 'package:crypto_wallet/databases/adaptors/address_adaptor.dart';
import 'package:crypto_wallet/databases/adaptors/base_key_adaptor.dart';
import 'package:crypto_wallet/databases/adaptors/wallet_adaptor.dart';
import 'package:crypto_wallet/databases/adaptors/wallet_branch_adaptor.dart';
import 'package:crypto_wallet/databases/adaptors/wallet_root_adaptor.dart';
import 'package:crypto_wallet/models/wallet/current_wallet.dart';
import 'package:crypto_wallet/modules/hd/hd.dart';
import 'package:crypto_wallet/utils/error.dart';

import 'functions/key_functions.dart';
import 'functions/query_functions.dart';

// * 월렛 등록 유무
Future<bool> isRegistered() async {
  try {
    return (await readAllWallets()).isNotEmpty;
  } catch (error) {
    errorHandler(error);
    rethrow;
  }
}

// * 신규 월렛 생성
Future<Map<String, dynamic>> createWallet({
  required String code,
  required String rootType,
  required String walletName,
  required List<String> networkTypes,
  required bool isBackedUp,
  termsAgreement = true,
}) async {
  try {
    // wallet
    final Wallet wallet = Wallet.hashId(
      walletName: walletName,
    );

    // wallet root
    final WalletRoot walletRoot = WalletRoot.hashId(
      wallet: wallet,
      type: rootType,
    );

    // wallet branch list
    final List<WalletBranch> branchList = [];
    for (int i = 0; i < networkTypes.length; i++) {
      final int coinType = getCoinType(networkTypes[i]);
      if (coinType != -1) {
        branchList.add(
          WalletBranch.create(
            walletRoot: walletRoot,
            coinType: coinType,
            keys: HiveList(Hive.box(baseKeysBox)),
          ),
        );
      }
    }
    await Hive.box(walletBranchesBox).addAll(branchList);

    await Future.wait([
      writeRoot(walletRoot.rootId, code),
      Hive.box(walletsBox).add(wallet),
      Hive.box(walletRootsBox).put(wallet.walletId, walletRoot),
    ]);

    log(Hive.box(walletsBox).toMap().toString());
    log(Hive.box(walletRootsBox).toMap().toString());
    log(Hive.box(walletBranchesBox).toMap().toString());

    // derive child key
    final List<Future> deriveTasks = [];
    for (int i = 0; i < branchList.length; i++) {
      deriveTasks.add(deriveKey(branchList[i]));
    }

    await Future.wait(deriveTasks);

    return {
      walletWord: wallet,
      walletRootWord: walletRoot,
      walletBranchesWord: branchList,
    };
  } catch (error) {
    errorHandler(error);
    rethrow;
  }
}

// * 전체 지갑 데이터 수집
Future<Map<String, List>> collectAll() async {
  try {
    List results = await Future.wait([
      readAllWalletRoots(),
      readAllWalletBranches(),
      readAllBaseKeys(),
      readAlladdresses(),
    ]);

    return {
      walletRootsWord: results[0],
      walletBranchesWord: results[1],
      baseKeysWord: results[2],
      addressesWord: results[3],
    };
  } catch (error) {
    errorHandler(error);
    rethrow;
  }
}

// * 현재 지갑 정보 불러오기
Future<CurrentWallet?> getCurrentWallet() async {
  try {
    int? currentCoinType = Hive.box(storeBox).get(currentCoinTypeWord);
    String? currentWalletId = Hive.box(storeBox).get(currentWalletIdWord);
    String? currentKeyId = Hive.box(storeBox).get(currentKeyIdWord);
    if (currentCoinType == null ||
        currentWalletId == null ||
        currentKeyId == null) {
      return null;
    }
    final List<Wallet> wallets = await findWallets({
      walletIdWord: currentWalletId,
    });
    final List<WalletBranch> walletBranches = await findWalletBranches({
      walletWord: wallets.first,
    });
    final WalletBranch currentWalletBranch = walletBranches
        .firstWhere((WalletBranch el) => el.coinType == currentCoinType);
    final BaseKey currentBaseKey = currentWalletBranch.keys
        .firstWhere((BaseKey el) => el.keyId == currentKeyId);

    return CurrentWallet(
      wallet: wallets.first,
      walletBranch: currentWalletBranch,
      baseKey: currentBaseKey,
    );
  } catch (error) {
    errorHandler(error);
    rethrow;
  }
}

// * 현재 지갑 변경
Future<void> changeCurrentWallet({
  required WalletBranch walletBranch,
  required BaseKey baseKey,
}) async {
  try {
    if (!walletBranch.keys.contains(baseKey)) {
      throw 'invalid base key';
    }
    await Hive.box(storeBox).putAll({
      currentCoinTypeWord: walletBranch.coinType,
      currentWalletIdWord: walletBranch.walletRoot.wallet.walletId,
      currentKeyIdWord: baseKey.keyId,
    });
  } catch (error) {
    errorHandler(error);
    rethrow;
  }
}

// * 주소 추가
Future<BaseKey> generateAddress({
  required Wallet wallet,
  required int coinType,
  String? type,
  String? label,
}) async {
  try {
    final List<WalletBranch> walletBranches = await findWalletBranches({
      walletWord: wallet,
      coinTypeWord: coinType,
    });
    final BaseKey newKey = await deriveKey(
      walletBranches.first,
      type: type,
      label: label,
    );
    return newKey;
  } catch (error) {
    errorHandler(error);
    rethrow;
  }
}
