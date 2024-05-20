import 'dart:developer';

import 'package:crypto_wallet/modules/hd/hd.dart';
import 'package:crypto_wallet/utils/filters.dart';
import 'package:web3dart/web3dart.dart';

import 'package:crypto_wallet/models/blockchain/erc20.dart';
import 'package:crypto_wallet/modules/hd/eth/eth_contract_module.dart';

Future<double> balaceOf({
  required Web3Client client,
  required ERC20 erc20,
  required String address,
}) async {
  List<dynamic> balanceOf = await contractCall(
    client: client,
    contractAddress: toEthereumAddress(erc20.contractAddress),
    method: 'balanceOf',
    params: [toEthereumAddress(address)],
  );
  return toCustomUnit(balanceOf.first, erc20.decimals);
}

Future<String> transfer({
  required int chainId,
  required Web3Client client,
  required ERC20 erc20,
  required String privateKey,
  required String toAddress,
  required String amount,
}) async {
  String transfer = await contractSend(
    chainId: chainId,
    privateKey: privateKey,
    client: client,
    contractAddress: toEthereumAddress(erc20.contractAddress),
    method: 'transfer',
    params: [toEthereumAddress(toAddress), toWei(double.parse(amount), 18)],
  );
  return transfer;
}
