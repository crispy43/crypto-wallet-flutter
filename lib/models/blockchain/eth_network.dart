// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class EthNetwork {
  final int chainId;
  final String name;
  final String symbol;
  final int decimals;
  final String rpcUrl;
  final bool eip1559;
  final String? scannerUrl;
  Widget? logo;
  EthNetwork({
    required this.chainId,
    required this.name,
    required this.symbol,
    required this.decimals,
    required this.rpcUrl,
    required this.eip1559,
    this.scannerUrl,
    this.logo,
  });

  EthNetwork copyWith({
    int? chainId,
    String? name,
    String? symbol,
    int? decimals,
    String? rpcUrl,
    bool? eip1559,
    String? scannerUrl,
    Widget? logo,
  }) {
    return EthNetwork(
      chainId: chainId ?? this.chainId,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      decimals: decimals ?? this.decimals,
      rpcUrl: rpcUrl ?? this.rpcUrl,
      eip1559: eip1559 ?? this.eip1559,
      scannerUrl: scannerUrl ?? this.scannerUrl,
      logo: logo ?? this.logo,
    );
  }

  @override
  String toString() {
    return 'EthNetwork(chainId: $chainId, name: $name, symbol: $symbol, decimals: $decimals, rpcUrl: $rpcUrl, eip1559: $eip1559, scannerUrl: $scannerUrl, logo: $logo)';
  }

  @override
  bool operator ==(covariant EthNetwork other) {
    if (identical(this, other)) return true;

    return other.chainId == chainId &&
        other.name == name &&
        other.symbol == symbol &&
        other.decimals == decimals &&
        other.rpcUrl == rpcUrl &&
        other.eip1559 == eip1559 &&
        other.scannerUrl == scannerUrl &&
        other.logo == logo;
  }

  @override
  int get hashCode {
    return chainId.hashCode ^
        name.hashCode ^
        symbol.hashCode ^
        decimals.hashCode ^
        rpcUrl.hashCode ^
        eip1559.hashCode ^
        scannerUrl.hashCode ^
        logo.hashCode;
  }
}
