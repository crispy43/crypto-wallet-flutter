import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart' as gc;
import 'package:encrypt/encrypt.dart';
import 'package:hex/hex.dart';

const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

// * 랜덤 문자열
String getRandomCharacters(int length, [int? seed]) {
  final Random random = Random(seed);
  return List.generate(length, (_) => chars[random.nextInt(chars.length)])
      .join();
}

// * secure 랜덤 문자열
String getSecureRandomCharacters(int length) {
  final Random random = Random.secure();
  return List.generate(length, (_) => chars[random.nextInt(chars.length)])
      .join();
}

// * String => Uint8List
Uint8List encodeToBuffer(String string) {
  return Uint8List.fromList(utf8.encode(string));
}

// * Uint8List => String
String decodeToBuffer(Uint8List buffer) {
  return utf8.decode(buffer);
}

// * Hex => Uint8List
Uint8List hexToBuffer(String hex) {
  return Uint8List.fromList(HEX.decode(hex));
}

// * Uint8List => Hex
String bufferToHex(Uint8List buffer) {
  return HEX.encode(buffer);
}

// * MD5 buffer
Uint8List toMd5Buffer(String text) {
  return Uint8List.fromList(md5.convert(utf8.encode(text)).bytes);
}

// * MD5 hex
String toMd5Hex(String text) {
  return md5.convert(utf8.encode(text)).toString();
}

// * SHA-256 buffer
Uint8List toSha256Buffer(String text) {
  return Uint8List.fromList(sha256.convert(utf8.encode(text)).bytes);
}

// * SHA-256 hex
String toSha256Hex(String text) {
  return sha256.convert(utf8.encode(text)).toString();
}

// * SHA-512 buffer
Uint8List toSha512Buffer(String text) {
  return Uint8List.fromList(sha512.convert(utf8.encode(text)).bytes);
}

// * SHA-512 hex
String toSha512Hex(String text) {
  return sha512.convert(utf8.encode(text)).toString();
}

// * HMAC buffer
Uint8List toHmacBuffer(String text, String key, {String? hashName}) {
  final List<int> hashKey = utf8.encode(key);
  final List<int> bytes = utf8.encode(text);
  late Hash hash;
  switch (hashName) {
    case 'md5':
      hash = md5;
      break;
    case 'sha512':
      hash = sha512;
      break;
    case 'sha256':
    default:
      hash = sha256;
      break;
  }
  final Hmac hmac = Hmac(hash, hashKey);
  final Digest digest = hmac.convert(bytes);
  return Uint8List.fromList(digest.bytes);
}

// * HMAC hex
String toHmacHex(String text, String key, {String? hashName}) {
  return bufferToHex(
    toHmacBuffer(
      text,
      key,
      hashName: hashName,
    ),
  );
}

// * PBKDF2 buffer
Future<Uint8List> toPbkdf2Buffer(
  String text, {
  String? hashName,
  int? iterations,
  int? bits,
  String? salt,
}) async {
  late gc.MacAlgorithm macAlgorithm;
  switch (hashName) {
    case 'sha256':
      macAlgorithm = gc.Hmac.sha256();
      break;
    case 'sha512':
    default:
      macAlgorithm = gc.Hmac.sha512();
      break;
  }
  final gc.Pbkdf2 pbkdf2 = gc.Pbkdf2(
    macAlgorithm: macAlgorithm,
    iterations: iterations ?? 1024,
    bits: bits ?? 256,
  );

  final gc.SecretKeyData secretKey = gc.SecretKeyData(utf8.encode(text));
  final List<int> nonce = utf8.encode(salt ?? '');

  final newSecretKey = await pbkdf2.deriveKey(
    secretKey: secretKey,
    nonce: nonce,
  );

  return Uint8List.fromList(await newSecretKey.extractBytes());
}

// * PBKDF2 hex
Future<String> toPbkdf2Hex(
  String text, {
  String? hashName,
  int? iterations,
  int? bits,
  String? salt,
}) async {
  return bufferToHex(
    await toPbkdf2Buffer(
      text,
      hashName: hashName,
      iterations: iterations,
      bits: bits,
      salt: salt,
    ),
  );
}

/* // * Argon2 buffer
// ! 검증 안됨
Future<Uint8List> toArgon2Buffer(
  String text, {
  String? version,
  int? parallelism,
  int? memorySize,
  int? iterations,
  int? hashLength,
  String? salt,
}) async {
  ecs.Argon2 argon2 = ecs.Argon2(
    parallelism: parallelism ?? 2,
    memory: memorySize ?? 65536,
    iterations: iterations ?? 16,
    hashLength: hashLength ?? 64,
  );

  final Uint8List encodedText = Uint8List.fromList(utf8.encode(text));
  final Uint8List nonce = Uint8List.fromList(utf8.encode(salt ?? ''));

  late Uint8List hashBuffer;
  switch (version) {
    case 'argon2i':
      hashBuffer = await argon2.argon2i(encodedText, nonce);
      break;
    case 'argon2d':
      hashBuffer = await argon2.argon2d(encodedText, nonce);
      break;
    case 'argon2id':
    default:
      hashBuffer = await argon2.argon2id(encodedText, nonce);
      break;
  }

  return hashBuffer;
}

// * Argon2 hex
// ! 검증 안됨
Future<String> toArgon2Hex(
  String text, {
  String? version,
  int? parallelism,
  int? memorySize,
  int? iterations,
  int? hashLength,
  String? salt,
}) async {
  return bufferToHex(
    await toArgon2Buffer(
      text,
      version: version,
      parallelism: parallelism,
      memorySize: memorySize,
      iterations: iterations,
      hashLength: hashLength,
      salt: salt,
    ),
  );
} */

// * AES 키 암호화
String encryptUseKey(
  String text,
  String key, {
  String? modeName,
  String? iv,
}) {
  final Key encodedKey = Key.fromUtf8(key);
  final IV encodedIv = iv != null ? IV.fromUtf8(iv) : IV.fromLength(16);
  late AESMode mode;
  switch (modeName) {
    case 'cbc':
    default:
      mode = AESMode.cbc;
      break;
  }

  final encrypter = Encrypter(
    AES(encodedKey, mode: mode),
  );

  return encrypter.encrypt(text, iv: encodedIv).base64;
}

// * AES 키 복호화
String decryptUseKey(
  String encrypted,
  String key, {
  String? modeName,
  String? iv,
}) {
  final Key encodedKey = Key.fromUtf8(key);
  final IV encodedIv = iv != null ? IV.fromUtf8(iv) : IV.fromLength(16);
  late AESMode mode;
  switch (modeName) {
    case 'cbc':
    default:
      mode = AESMode.cbc;
      break;
  }

  final encrypter = Encrypter(
    AES(encodedKey, mode: mode),
  );

  return encrypter.decrypt64(encrypted, iv: encodedIv);
}

// * AES 비밀번호 암호화
String encryptUsePassword(
  String text,
  String password, {
  String? modeName,
  String? iv,
}) {
  final String key =
      md5.convert(sha256.convert(utf8.encode(password)).bytes).toString();

  return encryptUseKey(text, key, modeName: modeName, iv: iv);
}

// * AES 비밀번호 복호화
String decryptUsePassword(
  String encrypted,
  String password, {
  String? modeName,
  String? iv,
}) {
  final String key =
      md5.convert(sha256.convert(utf8.encode(password)).bytes).toString();

  return decryptUseKey(encrypted, key, modeName: modeName, iv: iv);
}
