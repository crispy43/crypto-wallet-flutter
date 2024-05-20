import 'package:crypto_wallet/databases/adaptors/base_key_adaptor.dart';
import 'package:crypto_wallet/modules/hd/key_module.dart';
import 'package:crypto_wallet/services/wallet/functions/key_functions.dart';
import 'package:web3dart/web3dart.dart';

import 'package:crypto_wallet/utils/error.dart';

import 'functions/eth_functions.dart';

// * 코인 밸런스 조회
Future<double> getBalance({
  required Web3Client client,
  required String address,
}) async {
  try {
    final double balance = await getEthBalance(
      client: client,
      address: address,
    );
    return balance;
  } catch (error) {
    errorHandler(error);
    rethrow;
  }
}

Future<String> sendCoin({
  required int chainId,
  required Web3Client client,
  required String rootId,
  required BaseKey fromKey,
  required String toAddress,
  required String amount,
}) async {
  try {
    String key = await readKey(rootId: rootId, keyId: fromKey.keyId);
    String txHash = await sendEth(
      chainId: chainId,
      client: client,
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
