// * key words
import 'package:crypto_wallet/models/wallet/key_pair_network.dart';

const String mnemonicWord = 'mnemonic';
const String privateKeyWord = 'privateKey';
const String publicKeyWord = 'publicKey';

// * address type words
const String p2pkhWord = 'p2pkh';

// * network type words
const String btcWord = 'btc';
const String btcTestWord = 'btcRegTest';
const String ethWord = 'eth';

// * Hive adaptor model word
const String walletsWord = 'wallets';
const String walletRootsWord = 'walletRoots';
const String walletBranchListsWord = 'walletBranchLists';
const String walletBranchesWord = 'walletBranches';
const String baseKeysWord = 'baseKeys';
const String addressesWord = 'addresses';
const String walletWord = 'wallet';
const String walletRootWord = 'walletRoot';
const String walletBranchListWord = 'walletBranchList';
const String walletBranchWord = 'walletBranch';
const String baseKeyWord = 'baseKey';
const String addressWord = 'address';
const String walletIdWord = 'walletId';
const String walletNameWord = 'walletName';
const String createdAtWord = 'createdAt';
const String updatedAtWord = 'updatedAt';
const String rootIdWord = 'rootId';
const String typeWord = 'type';
const String listWord = 'list';
const String purposeWord = 'purpose';
const String coinTypeWord = 'coinType';
const String accountWord = 'account';
const String isChangeWord = 'isChange';
const String keysWord = 'keys';
const String keyIdWord = 'keyId';
const String indexWord = 'index';
const String isPausedWord = 'isPaused';
const String labelWord = 'label';

// * BIP-44 coinType map
final Map<String, int> bip44Map = {
  btcWord: 0,
  btcTestWord: 1,
  ethWord: 60,
};

// * coinType KeyPairNetwork map
final Map<int, KeyPairNetwork> coinTypeNetworkMap = {
  0: KeyPairNetwork.bitcoin(),
  1: KeyPairNetwork.bitcoinTestnet(),
};

// * KeyPairNetwork map
final Map<String, KeyPairNetwork> keyPairNetworkMap = {
  btcWord: KeyPairNetwork.bitcoin(),
  btcTestWord: KeyPairNetwork.bitcoinTestnet(),
};
