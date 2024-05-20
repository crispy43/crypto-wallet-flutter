import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:crypto_wallet/constants/box_constants.dart';
import 'package:crypto_wallet/constants/env_constants.dart';
import 'package:crypto_wallet/constants/hd_constants.dart';
import 'package:crypto_wallet/databases/adaptors/address_adaptor.dart';
import 'package:crypto_wallet/databases/adaptors/base_key_adaptor.dart';
import 'package:crypto_wallet/databases/adaptors/wallet_branch_adaptor.dart';
import 'package:crypto_wallet/databases/secure_storage.dart';
import 'package:crypto_wallet/models/wallet/key_pair.dart';
import 'package:crypto_wallet/models/wallet/key_pair_network.dart';
import 'package:crypto_wallet/modules/hd/hd.dart';
import 'package:crypto_wallet/utils/crypto.dart';
import 'package:crypto_wallet/utils/date_time.dart';

// * root 조회
Future<String> readRoot(String rootId) async {
  try {
    final String rootHash = toHmacHex(rootId, dotenv.env[hmacKeyWord]!);
    int generatedTimestamp = Hive.box(timestampsBox).get(rootHash);
    final String secretHash =
        toHmacHex(rootHash, generatedTimestamp.toString());
    final String? encrypted = await SecureStorage.read(secretHash);
    if (encrypted == null) throw 'rootHash is not founded';
    final String password = await toPbkdf2Hex(
      "${dotenv.env[hdKeyWord]!}$rootId$generatedTimestamp${dotenv.env[hdKeyWord]!}",
      iterations: int.parse(dotenv.env[pbkdf2IterationsWord]!),
      bits: int.parse(dotenv.env[pbkdf2BitsWord]!),
      salt: dotenv.env[pbkdf2RootSaltWord]!,
    );
    return decryptUsePassword(
      encrypted,
      password,
      modeName: 'cbc',
      iv: dotenv.env[cryptoIvWord]!,
    );
  } catch (error) {
    rethrow;
  }
}

// * root 저장
Future<void> writeRoot(
  String rootId,
  String code,
) async {
  try {
    final int generatedTimestamp = getTimeNowMicro();
    final String password = await toPbkdf2Hex(
      "${dotenv.env[hdKeyWord]!}$rootId$generatedTimestamp${dotenv.env[hdKeyWord]!}",
      iterations: int.parse(dotenv.env[pbkdf2IterationsWord]!),
      bits: int.parse(dotenv.env[pbkdf2BitsWord]!),
      salt: dotenv.env[pbkdf2RootSaltWord]!,
    );
    final String encrypted = encryptUsePassword(
      code,
      password,
      modeName: 'cbc',
      iv: dotenv.env[cryptoIvWord]!,
    );
    final String rootHash = toHmacHex(rootId, dotenv.env[hmacKeyWord]!);
    final String secretHash =
        toHmacHex(rootHash, generatedTimestamp.toString());
    await SecureStorage.write(secretHash, encrypted);
    await Hive.box(timestampsBox).put(rootHash, generatedTimestamp);
  } catch (error) {
    rethrow;
  }
}

// * mnemonic 조회
Future<String> readMnemonic(String rootId) async {
  try {
    String code = await readRoot(rootId);
    if (isMnemonic(code)) {
      return code;
    } else {
      throw 'root is not mnemonic code';
    }
  } catch (error) {
    rethrow;
  }
}

// * root key 조회
Future<String> readRootKey(
  String rootId,
  String rootType, {
  KeyPairNetwork? network,
}) async {
  try {
    switch (rootType) {
      case privateKeyWord:
        return await readRoot(rootId);
      case mnemonicWord:
      default:
        return mnemonicToRootKey(await readMnemonic(rootId), network: network);
    }
  } catch (error) {
    rethrow;
  }
}

// * child key 조회
Future<String> readKey({
  required String rootId,
  required String keyId,
}) async {
  try {
    final String keyIdHash = toHmacHex(keyId, dotenv.env[hmacKeyWord]!);
    final String keyHash = toHmacHex(rootId, keyIdHash);
    int generatedTimestamp = Hive.box(timestampsBox).get(keyHash);
    final String secretHash = toHmacHex(keyHash, generatedTimestamp.toString());
    final String? encrypted = await SecureStorage.read(secretHash);
    if (encrypted == null) throw 'secretHash is not founded';
    final String password = await toPbkdf2Hex(
      "${dotenv.env[hdChildKeyWord]!}$keyId$generatedTimestamp${dotenv.env[hdChildKeyWord]!}",
      iterations: int.parse(dotenv.env[pbkdf2IterationsWord]!),
      bits: int.parse(dotenv.env[pbkdf2BitsWord]!),
      salt: dotenv.env[pbkdf2SaltWord]!,
    );
    return decryptUsePassword(encrypted, password);
  } catch (error) {
    rethrow;
  }
}

// * child key 저장
Future<void> writeKey({
  required int generatedTimestamp,
  required String rootId,
  required String keyId,
  required String key,
}) async {
  try {
    print(key);
    final String password = await toPbkdf2Hex(
      "${dotenv.env[hdChildKeyWord]!}$keyId$generatedTimestamp${dotenv.env[hdChildKeyWord]!}",
      iterations: int.parse(dotenv.env[pbkdf2IterationsWord]!),
      bits: int.parse(dotenv.env[pbkdf2BitsWord]!),
      salt: dotenv.env[pbkdf2SaltWord]!,
    );
    final String encrypted = encryptUsePassword(key, password);
    final String keyIdHash = toHmacHex(keyId, dotenv.env[hmacKeyWord]!);
    final String keyHash = toHmacHex(rootId, keyIdHash);
    final String secretHash = toHmacHex(keyHash, generatedTimestamp.toString());
    await SecureStorage.write(secretHash, encrypted);
    await Hive.box(timestampsBox).put(keyHash, generatedTimestamp);
  } catch (error) {
    rethrow;
  }
}

// * 신규 키 파생
Future<BaseKey> deriveKey(
  WalletBranch walletBranch, {
  String? type,
  String? label,
}) async {
  try {
    // index 오름차순 정렬
    walletBranch.sortKeys();

    // network
    final KeyPairNetwork? network = coinTypeNetworkMap[walletBranch.coinType];

    // root key
    final String rootKey = await readRootKey(
      walletBranch.walletRoot.rootId,
      walletBranch.walletRoot.type,
      network: network,
    );

    // child key
    final String childKey = deriveChildKey(
      rootKey,
      walletBranch.nextPath,
      network: network,
    );

    print(walletBranch.coinType);
    print(childKey);

    // address
    Address? address;
    switch (walletBranch.coinType) {
      // * 비트코인, 비트코인 테스트넷
      case 0:
      case 1:
        address = Address.create(
          address: toAddress(
            KeyPair.fromBase58(
              childKey,
              network,
            ),
            type: type ?? p2pkhWord,
          ),
          type: type ?? p2pkhWord,
          isChange: walletBranch.isChange,
          label: label,
        );
        break;

      // * 이더리움
      case 60:
        address = Address.create(
          address: toEthAddress(
            KeyPair.fromBase58(
              childKey,
            ),
          ),
          isChange: walletBranch.isChange,
          label: label,
        );
        break;
    }
    if (address != null) {
      Hive.box(addressesBox).add(address);
      print(address);
    }

    // 키 생성
    final BaseKey baseKey = BaseKey.hashId(
      index: walletBranch.nextIndex,
      addresses: HiveList(
        Hive.box(addressesBox),
        objects: address != null ? [address] : null,
      ),
    );
    print(baseKey);

    await writeKey(
      generatedTimestamp: getTimeNowMicro(),
      rootId: walletBranch.walletRoot.rootId,
      keyId: baseKey.keyId,
      key: childKey,
    );

    Hive.box(baseKeysBox).add(baseKey);
    walletBranch.keys.add(baseKey);
    walletBranch
      ..setUpdatedAtNow()
      ..save();

    return baseKey;
  } catch (error) {
    rethrow;
  }
}
