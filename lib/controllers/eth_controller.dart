import 'dart:developer';
import 'package:http/http.dart';

import 'package:flutter/material.dart';
import 'package:crypto_wallet/constants/contract_constants.dart';
import 'package:crypto_wallet/models/blockchain/erc20.dart';
import 'package:crypto_wallet/utils/error.dart';
import 'package:web3dart/web3dart.dart';

import 'package:crypto_wallet/constants/network_constants.dart';
import 'package:crypto_wallet/models/blockchain/eth_network.dart';

class EthController with ChangeNotifier {
  EthNetwork network;
  bool isAlive;
  List<EthNetwork> options;
  List<ERC20> tokens;
  Web3Client client;

  EthController(
    this.network, {
    this.isAlive = false,
  })  : options = const String.fromEnvironment('RUN_ENV') == 'PROD'
            ? networksForProd
            : networksForProd,
        tokens = defaultTokens.where((el) => el.only == network).toList(),
        client = Web3Client(network.rpcUrl, Client());

  Future<void> checkProvider() async {
    try {
      final int blockNumber = await client.getBlockNumber();
      log('EthController: current block is $blockNumber (${network.name})');
      isAlive = true;
      if (isAlive == false) notifyListeners();
    } catch (error) {
      errorHandler(error);
      isAlive = false;
      if (isAlive == true) notifyListeners();
    }
  }

  Future<void> changeNetwork(EthNetwork newNetwork) async {
    if (options.contains(newNetwork)) {
      network = newNetwork;
      log('EthController: network changed to ${network.name}');
      tokens = defaultTokens.where((el) => el.only == network).toList();
      client = Web3Client(network.rpcUrl, Client());
      isAlive = false;
      checkProvider();
      notifyListeners();
    }
  }
}
