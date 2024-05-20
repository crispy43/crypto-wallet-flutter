import 'package:flutter/material.dart';
import 'package:crypto_wallet/constants/network_constants.dart';
import 'package:crypto_wallet/models/blockchain/erc20.dart';

final tetherUsd = ERC20(
  contractAddress: '0xdAC17F958D2ee523a2206206994597C13D831ec7',
  name: 'Tether USD',
  symbol: 'USDT',
  decimals: 18,
  only: ethereumNetwork,
  logo: const Image(
    image: AssetImage('assets/images/tether_usd_logo.png'),
  ),
);

final usdCoin = ERC20(
  contractAddress: '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48',
  name: 'USD Coin',
  symbol: 'USDC',
  decimals: 18,
  only: ethereumNetwork,
  logo: const Image(
    image: AssetImage('assets/images/usd_coin_logo.png'),
  ),
);

final List<ERC20> defaultTokens = [
  tetherUsd,
  usdCoin,
];
