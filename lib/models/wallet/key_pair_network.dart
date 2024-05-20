import 'dart:convert';

import 'package:bip32/bip32.dart' as bip32;
import 'package:flutter_bitcoin/flutter_bitcoin.dart';

class KeyPairNetwork {
  final String name;
  final int bip32Pivate;
  final int bip32Public;
  final int wif;
  final int scriptHash;
  final int pubKeyHash;
  KeyPairNetwork({
    required this.name,
    required this.bip32Pivate,
    required this.bip32Public,
    required this.wif,
    required this.scriptHash,
    required this.pubKeyHash,
  });

  KeyPairNetwork copyWith({
    String? name,
    int? bip32Pivate,
    int? bip32Public,
    int? wif,
    int? scriptHash,
    int? pubKeyHash,
  }) {
    return KeyPairNetwork(
      name: name ?? this.name,
      bip32Pivate: bip32Pivate ?? this.bip32Pivate,
      bip32Public: bip32Public ?? this.bip32Public,
      wif: wif ?? this.wif,
      scriptHash: scriptHash ?? this.scriptHash,
      pubKeyHash: pubKeyHash ?? this.pubKeyHash,
    );
  }

  // * 비트코인 기반 네트워크 생성
  factory KeyPairNetwork.bitcoin([
    String name = 'bitcoin',
  ]) {
    return KeyPairNetwork(
      name: name,
      bip32Pivate: 0x0488ade4,
      bip32Public: 0x0488b21e,
      wif: 0x80,
      scriptHash: 0x05,
      pubKeyHash: 0x00,
    );
  }

  // * 비트코인 테스트넷 기반 네트워크 생성
  factory KeyPairNetwork.bitcoinTestnet([
    String name = 'bitcoin',
  ]) {
    return KeyPairNetwork(
      name: name,
      bip32Pivate: 0x04358394,
      bip32Public: 0x043587cf,
      wif: 0xef,
      scriptHash: 0xc4,
      pubKeyHash: 0x6f,
    );
  }

  // * bip32 NetworkType 포멧으로
  bip32.NetworkType get bip32NetworkType => bip32.NetworkType(
        bip32: bip32.Bip32Type(
          private: bip32Pivate,
          public: bip32Public,
        ),
        wif: wif,
      );

  // * NetworkType 포멧으로
  NetworkType get networkType => NetworkType(
        messagePrefix: messagePrefix,
        bip32: Bip32Type(
          private: bip32Pivate,
          public: bip32Public,
        ),
        wif: wif,
        scriptHash: scriptHash,
        pubKeyHash: scriptHash,
      );

  // * messagePrefix
  String get messagePrefix =>
      '\x18${name[0].toUpperCase()}${name.substring(1)} Signed Message:\n';

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'bip32Pivate': bip32Pivate,
      'bip32Public': bip32Public,
      'wif': wif,
      'scriptHash': scriptHash,
      'pubKeyHash': pubKeyHash,
    };
  }

  factory KeyPairNetwork.fromMap(Map<String, dynamic> map) {
    return KeyPairNetwork(
      name: map['name'] ?? '',
      bip32Pivate: map['bip32Pivate']?.toInt() ?? 0,
      bip32Public: map['bip32Public']?.toInt() ?? 0,
      wif: map['wif']?.toInt() ?? 0,
      scriptHash: map['scriptHash']?.toInt() ?? 0,
      pubKeyHash: map['pubKeyHash']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory KeyPairNetwork.fromJson(String source) =>
      KeyPairNetwork.fromMap(json.decode(source));

  @override
  String toString() {
    return 'KeyPairNetwork(name: $name, bip32Pivate: $bip32Pivate, bip32Public: $bip32Public, wif: $wif, scriptHash: $scriptHash, pubKeyHash: $pubKeyHash)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is KeyPairNetwork &&
        other.name == name &&
        other.bip32Pivate == bip32Pivate &&
        other.bip32Public == bip32Public &&
        other.wif == wif &&
        other.scriptHash == scriptHash &&
        other.pubKeyHash == pubKeyHash;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        bip32Pivate.hashCode ^
        bip32Public.hashCode ^
        wif.hashCode ^
        scriptHash.hashCode ^
        pubKeyHash.hashCode;
  }
}
