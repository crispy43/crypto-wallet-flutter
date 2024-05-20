import 'dart:typed_data';

import 'package:bip32/bip32.dart' as bip32;
import 'package:flutter_bitcoin/flutter_bitcoin.dart';
import 'package:hex/hex.dart';
import 'package:crypto_wallet/models/wallet/key_pair_network.dart';
import 'package:crypto_wallet/utils/crypto.dart';

// * 프라이빗 키 생성
String toPrivateKey(
  String base58Key, [
  KeyPairNetwork? network,
]) {
  final bip32.BIP32 node = bip32.BIP32.fromBase58(
    base58Key,
    network?.bip32NetworkType,
  );
  return node.toWIF();
}

// * 프라이빗 키 버퍼 생성
Uint8List toPrivateKeyBuffer(
  String base58Key, [
  KeyPairNetwork? network,
]) {
  final bip32.BIP32 node = bip32.BIP32.fromBase58(
    base58Key,
    network?.bip32NetworkType,
  );
  return node.privateKey ?? toSha256Buffer(base58Key);
}

// * 프라이빗 키 버퍼 생성 (wif에서)
Uint8List toPrivateKeyBufferFromWif(
  String privateKey, [
  KeyPairNetwork? network,
]) {
  final ECPair keyPair = ECPair.fromWIF(
    privateKey,
    network: network?.networkType,
  );
  return keyPair.privateKey;
}

// * 프라이빗 키 버퍼 => 프라이빗 키
String toPrivateKeyFromBuffer(
  Uint8List privateKeyBuffer, [
  KeyPairNetwork? network,
]) {
  final ECPair keyPair = ECPair.fromPrivateKey(
    privateKeyBuffer,
    network: network?.networkType,
  );
  return keyPair.toWIF();
}

String toHexPrivateKey(String base58Key) {
  return bufferToHex(toPrivateKeyBuffer(base58Key));
}

// * 퍼블릭 키 생성
String toPublicKey(
  String privateKey, [
  KeyPairNetwork? network,
]) {
  final ECPair keyPair = ECPair.fromWIF(
    privateKey,
    network: network?.networkType,
  );
  return HEX.encode(keyPair.publicKey);
}

// * 퍼블릭 키 버퍼 생성
Uint8List toPublicKeyBuffer(
  Uint8List privateKeyBuffer, [
  KeyPairNetwork? network,
]) {
  final ECPair keyPair = ECPair.fromPrivateKey(
    privateKeyBuffer,
    network: network?.networkType,
  );
  return keyPair.publicKey;
}

// * 퍼블릭 키 버퍼 => 퍼블릭 키
String toPublicKeyFromBuffer(
  Uint8List publicKeyBuffer, [
  KeyPairNetwork? network,
]) {
  final ECPair keyPair = ECPair.fromPublicKey(
    publicKeyBuffer,
    network: network?.networkType,
  );
  return HEX.encode(keyPair.publicKey);
}

// * 0x prefix 추가
String addHexPrefix(String base) {
  if (base[0] != '0' && base[1] != 'x') {
    return '0x' + base;
  } else {
    return base;
  }
}

// * 0x prefix 제거
String removeHexPrefix(String base) {
  if (base[0] == '0' && base[1] == 'x') {
    return base.substring(2);
  } else {
    return base;
  }
}
