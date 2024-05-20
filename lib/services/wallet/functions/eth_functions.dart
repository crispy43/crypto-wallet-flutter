import 'package:crypto_wallet/modules/hd/eth/eth_account_module.dart';
import 'package:crypto_wallet/modules/hd/hd.dart';
import 'package:crypto_wallet/utils/filters.dart';
import 'package:web3dart/web3dart.dart';

Future<double> getEthBalance({
  required Web3Client client,
  required String address,
  bool toEther = true,
}) async {
  BigInt balance = await getCoinBalance(
    client: client,
    address: toEthereumAddress(address),
  );
  return toEther ? toCustomUnit(balance, 18) : balance.toDouble();
}

Future<String> sendEth({
  required int chainId,
  required Web3Client client,
  required String privateKey,
  required String toAddress,
  required String amount,
}) async {
  String transfer = await sendCoin(
    chainId: chainId,
    privateKey: privateKey,
    client: client,
    toAddress: toEthereumAddress(toAddress),
    amount: EtherAmount.fromUnitAndValue(
      EtherUnit.wei,
      toWei(double.parse(amount), 18),
    ),
  );
  return transfer;
}
