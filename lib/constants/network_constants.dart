import 'package:flutter/material.dart';
import 'package:crypto_wallet/models/blockchain/eth_network.dart';

final ethereumNetwork = EthNetwork(
  chainId: 0x1,
  name: 'ethereum',
  symbol: 'ETH',
  decimals: 18,
  eip1559: true,
  rpcUrl: 'https://mainnet.infura.io/v3/',
  scannerUrl: 'https://api.etherscan.io/api',
  logo: const Image(
    image: AssetImage('assets/images/ethereum_logo.png'),
  ),
);

final goerliNetwork = EthNetwork(
  chainId: 0x5,
  name: 'goerli',
  symbol: 'gETH',
  decimals: 18,
  eip1559: true,
  rpcUrl: 'https://goerli.infura.io/v3/',
  scannerUrl: 'https://api-goerli.etherscan.io/api',
  logo: const Image(
    image: AssetImage('assets/images/ethereum_logo.png'),
  ),
);

final klaytnNetwork = EthNetwork(
  chainId: 0x2019,
  name: 'klaytn',
  symbol: 'KLAY',
  decimals: 18,
  eip1559: false,
  rpcUrl: 'https://public-node-api.klaytnapi.com/v1/cypress',
  scannerUrl: 'https://scope.klaytn.com',
  logo: const Image(
    image: AssetImage('assets/images/klaytn-logo.png'),
  ),
);

final baobabNetwork = EthNetwork(
  chainId: 0x3e9,
  name: 'baobab',
  symbol: 'bKLAY',
  decimals: 18,
  eip1559: false,
  rpcUrl: 'https://api.baobab.klaytn.net:8651',
  scannerUrl: 'https://baobab.scope.klaytn.com',
  logo: const Image(
    image: AssetImage('assets/images/klaytn-logo.png'),
  ),
);

final List<EthNetwork> networksForProd = [
  ethereumNetwork,
  klaytnNetwork,
];

final List<EthNetwork> networksForDev = [
  ethereumNetwork,
  goerliNetwork,
  klaytnNetwork,
  baobabNetwork,
];
