import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart';
import 'package:crypto_wallet/constants/hd_constants.dart';
import 'package:crypto_wallet/models/wallet/key_pair_network.dart';

const String defaultLocale = 'en_US';
const int defaultWords = 12;

// * 랜덤 니모닉 생성
String generateRandomMnemonic([int words = defaultWords]) {
  switch (words) {
    case 15:
      return bip39.generateMnemonic(strength: 160);
    case 18:
      return bip39.generateMnemonic(strength: 192);
    case 21:
      return bip39.generateMnemonic(strength: 224);
    case 24:
      return bip39.generateMnemonic(strength: 256);
    case 12:
    default:
      return bip39.generateMnemonic(strength: 128);
  }
}

// * 니모닉 검증
bool isMnemonic(String mnemonic) {
  return bip39.validateMnemonic(mnemonic);
}

// * 니모닉으로 root 생성
String mnemonicToRootKey(
  String mnemonic, {
  KeyPairNetwork? network,
}) {
  final BIP32 root = BIP32.fromSeed(
    bip39.mnemonicToSeed(mnemonic),
    network?.bip32NetworkType,
  );
  return root.toBase58();
}

// * derive child
String deriveChildKey(
  String rootKey,
  String path, {
  KeyPairNetwork? network,
}) {
  final BIP32 root = BIP32.fromBase58(rootKey, network?.bip32NetworkType);
  final BIP32 child = root.derivePath(path);
  return child.toBase58();
}

// * get coinType
int getCoinType(String networkType) {
  return bip44Map[networkType] ?? -1;
}

// * get path
String? getPath({
  required String networkType,
  int purpose = 44,
  int account = 0,
  bool isChange = false,
  required int index,
}) {
  final int coinType = getCoinType(networkType);
  if (coinType == -1) return null;
  return "m/$purpose'/$coinType'/$account'/${isChange ? 1 : 0}/$index";
}
