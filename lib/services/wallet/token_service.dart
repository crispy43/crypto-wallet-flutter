import 'dart:developer';

import 'package:crypto_wallet/databases/adaptors/base_key_adaptor.dart';
import 'package:crypto_wallet/models/blockchain/eth_network.dart';
import 'package:crypto_wallet/models/wallet/key_pair.dart';
import 'package:crypto_wallet/modules/hd/key_module.dart';
import 'package:crypto_wallet/services/wallet/functions/key_functions.dart';
import 'package:crypto_wallet/utils/crypto.dart';
import 'package:web3dart/web3dart.dart';

import 'package:crypto_wallet/models/blockchain/erc20.dart';
import 'package:crypto_wallet/utils/error.dart';

import 'functions/erc20_functions.dart';

import 'package:bip32/bip32.dart' as bip32;

import 'functions/etherscan_functions.dart';

// * ERC20 밸런스 조회
Future<double> getBalance({
  required Web3Client client,
  required ERC20 erc20,
  required String address,
}) async {
  try {
    final double balance = await balaceOf(
      client: client,
      erc20: erc20,
      address: address,
    );
    return balance;
  } catch (error) {
    errorHandler(error);
    rethrow;
  }
}

// * ERC20 전송
Future<String> sendToken({
  required int chainId,
  required Web3Client client,
  required ERC20 erc20,
  required String rootId,
  required BaseKey fromKey,
  required String toAddress,
  required String amount,
}) async {
  try {
    String key = await readKey(rootId: rootId, keyId: fromKey.keyId);
    String txHash = await transfer(
      chainId: chainId,
      client: client,
      erc20: erc20,
      privateKey: addHexPrefix(toHexPrivateKey(key)),
      toAddress: toAddress,
      amount: amount,
    );
    return txHash;
  } catch (error) {
    errorHandler(error);
    rethrow;
  }
}
