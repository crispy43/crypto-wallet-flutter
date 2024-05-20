import 'package:crypto_wallet/databases/adaptors/base_key_adaptor.dart';
import 'package:crypto_wallet/models/blockchain/erc20.dart';
import 'package:crypto_wallet/models/blockchain/eth_network.dart';
import 'package:crypto_wallet/utils/error.dart';

import 'functions/etherscan_functions.dart';

// * ERC20 내역 조회
Future<List> getTokenHistory({
  required EthNetwork network,
  required ERC20 erc20,
  required BaseKey account,
}) async {
  try {
    var history = await getTokenTx(
      scannerUrl: network.scannerUrl!,
      contractAddress: erc20.contractAddress,
      address: account.addresses[0].address,
    );
    return history;
  } catch (error) {
    errorHandler(error);
    rethrow;
  }
}

// * eth 내역 조회
Future<List> getNormalTxHistory({
  required EthNetwork network,
  required BaseKey account,
}) async {
  try {
    var history = await getNormalTx(
      scannerUrl: network.scannerUrl!,
      address: account.addresses[0].address,
    );
    return history;
  } catch (error) {
    errorHandler(error);
    rethrow;
  }
}

// * klaytn 내역 조회
Future<List> getKlaytnTxHistory({
  required EthNetwork network,
  required BaseKey account,
}) async {
  try {
    var history = await getKlaytnTx(
      chainId: network.chainId,
      address: account.addresses[0].address,
    );
    return history;
  } catch (error) {
    errorHandler(error);
    rethrow;
  }
}
