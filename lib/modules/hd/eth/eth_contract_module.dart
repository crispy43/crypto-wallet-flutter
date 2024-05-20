import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';

// * ABI 불러오기
Future<ContractAbi> getAbi([String? contractName]) async {
  late String abi;
  try {
    switch (contractName?.toLowerCase() ?? contractName) {
      case 'ERC20LockablePreset':
      default:
        abi = await rootBundle.loadString(
          'assets/contracts/erc20/ERC20LockablePreset.json',
        );
        break;
    }

    return ContractAbi.fromJson(abi, contractName ?? 'ERC20LockablePreset');
  } catch (error) {
    rethrow;
  }
}

// * Contract 불러오기
Future<DeployedContract> getContract(
  EthereumAddress contractAddress, {
  String? contractName,
}) async {
  final ContractAbi abi = await getAbi(contractName);
  return DeployedContract(abi, contractAddress);
}

// * call
Future<List<dynamic>> contractCall({
  required Web3Client client,
  EthereumAddress? contractAddress,
  DeployedContract? contract,
  required String method,
  List<dynamic>? params,
}) async {
  if (contract != null) {
    return await client.call(
      contract: contract,
      function: contract.function(method),
      params: params ?? [],
    );
  } else if (contractAddress != null) {
    final DeployedContract contractInstance =
        await getContract(contractAddress);
    return await client.call(
      contract: contractInstance,
      function: contractInstance.function(method),
      params: params ?? [],
    );
  } else {
    throw 'need contract';
  }
}

// * send
Future<String> contractSend({
  required int chainId,
  required Web3Client client,
  EthereumAddress? contractAddress,
  DeployedContract? contract,
  required String privateKey,
  required String method,
  required List<dynamic> params,
}) async {
  Credentials credentials = EthPrivateKey.fromHex(privateKey);
  if (contract != null) {
    return await client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: contract.function(method),
        parameters: params,
      ),
      chainId: chainId,
    );
  } else if (contractAddress != null) {
    final DeployedContract contractInstance =
        await getContract(contractAddress);
    return await client.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contractInstance,
        function: contractInstance.function(method),
        parameters: params,
      ),
      chainId: chainId,
    );
  } else {
    throw 'need contract';
  }
}
