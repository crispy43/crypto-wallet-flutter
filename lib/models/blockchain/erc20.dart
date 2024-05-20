// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:crypto_wallet/models/blockchain/eth_network.dart';

class ERC20 {
  final String contractAddress;
  final String name;
  final String symbol;
  final int decimals;
  final EthNetwork only;
  Widget? logo;
  ERC20({
    required this.contractAddress,
    required this.name,
    required this.symbol,
    required this.decimals,
    required this.only,
    this.logo,
  });

  ERC20 copyWith({
    String? contractAddress,
    String? name,
    String? symbol,
    int? decimals,
    EthNetwork? only,
    Widget? logo,
  }) {
    return ERC20(
      contractAddress: contractAddress ?? this.contractAddress,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      decimals: decimals ?? this.decimals,
      only: only ?? this.only,
      logo: logo ?? this.logo,
    );
  }

  @override
  String toString() {
    return 'ERC20(contractAddress: $contractAddress, name: $name, symbol: $symbol, decimals: $decimals, only: $only, logo: $logo)';
  }

  @override
  bool operator ==(covariant ERC20 other) {
    if (identical(this, other)) return true;

    return other.contractAddress == contractAddress &&
        other.name == name &&
        other.symbol == symbol &&
        other.decimals == decimals &&
        other.only == only &&
        other.logo == logo;
  }

  @override
  int get hashCode {
    return contractAddress.hashCode ^
        name.hashCode ^
        symbol.hashCode ^
        decimals.hashCode ^
        only.hashCode ^
        logo.hashCode;
  }
}
