import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto_wallet/modules/hd/key_module.dart';

import 'key_pair_network.dart';

class KeyPair {
  final KeyPairNetwork? network;
  final Uint8List privateKeyBuffer;
  final Uint8List publicKeyBuffer;
  KeyPair({
    this.network,
    required this.privateKeyBuffer,
  }) : publicKeyBuffer = toPublicKeyBuffer(privateKeyBuffer, network);

  KeyPair copyWith({
    KeyPairNetwork? network,
    Uint8List? privateKeyBuffer,
    Uint8List? publicKeyBuffer,
  }) {
    return KeyPair(
      network: network ?? this.network,
      privateKeyBuffer: privateKeyBuffer ?? this.privateKeyBuffer,
    );
  }

  // * base58 key로 생성
  factory KeyPair.fromBase58(String base58Key, [KeyPairNetwork? network]) {
    return KeyPair(
      network: network,
      privateKeyBuffer: toPrivateKeyBuffer(base58Key, network),
    );
  }

  // * private key로 생성
  factory KeyPair.fromPrivateKey(String privateKey, [KeyPairNetwork? network]) {
    return KeyPair(
      network: network,
      privateKeyBuffer: toPrivateKeyBufferFromWif(privateKey, network),
    );
  }

  // * 프라이빗 키
  String get privateKey => toPrivateKeyFromBuffer(privateKeyBuffer, network);

  // * 퍼블릭 키
  String get publicKey => toPublicKeyFromBuffer(publicKeyBuffer, network);

  // * 프라이빗 키 with 0x
  String get privateKeyWithHex =>
      addHexPrefix(toPrivateKeyFromBuffer(privateKeyBuffer, network));

  // * 퍼블릭 키 with 0x
  String get publicKeyWithHex =>
      addHexPrefix(toPublicKeyFromBuffer(publicKeyBuffer, network));

  Map<String, dynamic> toMap() {
    return {
      'network': network?.toMap(),
      'privateKeyBuffer': privateKeyBuffer.toList(),
      'publicKeyBuffer': publicKeyBuffer.toList(),
    };
  }

  factory KeyPair.fromMap(Map<String, dynamic> map) {
    return KeyPair(
      network: map['network'] != null
          ? KeyPairNetwork.fromMap(map['network'])
          : null,
      privateKeyBuffer: Uint8List.fromList(map['privateKeyBuffer']),
    );
  }

  String toJson() => json.encode(toMap());

  factory KeyPair.fromJson(String source) =>
      KeyPair.fromMap(json.decode(source));

  @override
  String toString() =>
      'KeyPair(network: $network, privateKeyBuffer: $privateKeyBuffer, publicKeyBuffer: $publicKeyBuffer)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is KeyPair &&
        other.network == network &&
        other.privateKeyBuffer == privateKeyBuffer &&
        other.publicKeyBuffer == publicKeyBuffer;
  }

  @override
  int get hashCode =>
      network.hashCode ^ privateKeyBuffer.hashCode ^ publicKeyBuffer.hashCode;
}
