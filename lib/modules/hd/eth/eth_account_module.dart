import 'package:web3dart/web3dart.dart';

Future<BigInt> getCoinBalance({
  required Web3Client client,
  required EthereumAddress address,
}) async {
  final EtherAmount balance = await client.getBalance(address);
  return balance.getInWei;
}

Future<String> sendCoin({
  required int chainId,
  required Web3Client client,
  required String privateKey,
  required EthereumAddress toAddress,
  required EtherAmount amount,
}) async {
  Credentials credentials = EthPrivateKey.fromHex(privateKey);
  return await client.sendTransaction(
    credentials,
    chainId: chainId,
    Transaction(
      from: await credentials.extractAddress(),
      to: toAddress,
      value: amount,
    ),
  );
}
