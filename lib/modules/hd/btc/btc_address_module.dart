import 'dart:typed_data';

import 'package:flutter_bitcoin/flutter_bitcoin.dart';
import 'package:hex/hex.dart';
import 'package:crypto_wallet/constants/hd_constants.dart';
import 'package:crypto_wallet/models/wallet/key_pair.dart';
import 'package:crypto_wallet/models/wallet/key_pair_network.dart';

// * publicKey => address
String _toAddress(
  Uint8List publicKey, {
  String? type,
  KeyPairNetwork? network,
}) {
  final PaymentData paymentData = PaymentData(pubkey: publicKey);
  switch (type) {
    case p2pkhWord:
    default:
      return P2PKH(data: paymentData, network: network?.networkType ?? bitcoin)
          .data
          .address!;
  }
}

// * 비트코인 계열 주소 생성
String toAddress(
  KeyPair keyPair, {
  String? type,
}) {
  return _toAddress(
    keyPair.publicKeyBuffer,
    type: type,
    network: keyPair.network,
  );
}

// * 비트코인 계열 주소 프라이빗 키로 생성
String toAddressFromPrivateKey(
  String privateKey, {
  String? type,
  KeyPairNetwork? network,
}) {
  final ECPair keyPair =
      ECPair.fromWIF(privateKey, network: network?.networkType);
  return _toAddress(keyPair.publicKey, type: type, network: network);
}

// * 비트코인 계열 주소 퍼블릭 키로 생성
String toAddressFromPublicKey(
  String publicKey, {
  String? type,
  KeyPairNetwork? network,
}) {
  return _toAddress(
    Uint8List.fromList(HEX.decode(publicKey)),
    type: type,
    network: network,
  );
}

// * 비트코인 계열 주소 검증
bool isAddress(String address, {KeyPairNetwork? network}) {
  return Address.validateAddress(address, network?.networkType ?? bitcoin);
}
