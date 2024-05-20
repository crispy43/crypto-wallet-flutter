import 'dart:typed_data';

import 'package:ethereum_addresses/ethereum_addresses.dart';
import 'package:flutter_bitcoin/flutter_bitcoin.dart';
import 'package:hex/hex.dart';
import 'package:web3dart/web3dart.dart';

import 'package:crypto_wallet/models/wallet/key_pair.dart';
import 'package:crypto_wallet/modules/hd/key_module.dart';

// * 이더리움 주소 생성
String toEthAddress(KeyPair keyPair) {
  return ethereumAddressFromPublicKey(keyPair.publicKeyBuffer);
}

// * 이더리움 주소 프라이빗 키로 생성
String toEthAddressFromPrivateKey(String privateKey) {
  final ECPair keyPair = ECPair.fromWIF(removeHexPrefix(privateKey));
  return ethereumAddressFromPublicKey(keyPair.publicKey);
}

// * 이더리움 주소 퍼블릭 키로 생성
String toEthAddressFromPublicKey(String publicKey) {
  return ethereumAddressFromPublicKey(
      Uint8List.fromList(HEX.decode(removeHexPrefix(publicKey))));
}

// * 이더리움 주소 검증
bool isEthAddress(String address) {
  return isValidEthereumAddress(address);
}

// * 이더리움 주소 체크섬 적용
String checksumEthAddress(String address) {
  return checksumEthereumAddress(address);
}

// * EthereumAddress 인스턴스로
EthereumAddress toEthereumAddress(String address) {
  return EthereumAddress.fromHex(address);
}
