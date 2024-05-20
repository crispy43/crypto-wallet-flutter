import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:crypto_wallet/constants/box_constants.dart';

import 'adaptors/address_adaptor.dart';
import 'adaptors/base_key_adaptor.dart';
import 'adaptors/wallet_adaptor.dart';
import 'adaptors/wallet_branch_adaptor.dart';
import 'adaptors/wallet_root_adaptor.dart';

void registerAllAdaptors() {
  Hive.registerAdapter(WalletAdapter());
  Hive.registerAdapter(WalletRootAdapter());
  Hive.registerAdapter(WalletBranchAdapter());
  Hive.registerAdapter(BaseKeyAdapter());
  Hive.registerAdapter(AddressAdapter());
}

Future<List<Box>> openAllBoxes(Uint8List boxEncKeyBuffer) async {
  List<Box> boxes = await Future.wait([
    Hive.openBox(
      settingsBox,
      encryptionCipher: HiveAesCipher(boxEncKeyBuffer.toList()),
    ),
    Hive.openBox(
      storeBox,
      encryptionCipher: HiveAesCipher(boxEncKeyBuffer.toList()),
    ),
    Hive.openBox(
      timestampsBox,
      encryptionCipher: HiveAesCipher(boxEncKeyBuffer.toList()),
    ),
    Hive.openBox(
      walletsBox,
      encryptionCipher: HiveAesCipher(boxEncKeyBuffer.toList()),
    ),
    Hive.openBox(
      walletRootsBox,
      encryptionCipher: HiveAesCipher(boxEncKeyBuffer.toList()),
    ),
    Hive.openBox(
      walletBranchesBox,
      encryptionCipher: HiveAesCipher(boxEncKeyBuffer.toList()),
    ),
    Hive.openBox(
      baseKeysBox,
      encryptionCipher: HiveAesCipher(boxEncKeyBuffer.toList()),
    ),
    Hive.openBox(
      addressesBox,
      encryptionCipher: HiveAesCipher(boxEncKeyBuffer.toList()),
    ),
  ]);
  return boxes;
}
