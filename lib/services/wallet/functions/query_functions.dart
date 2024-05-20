import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:crypto_wallet/constants/box_constants.dart';
import 'package:crypto_wallet/constants/hd_constants.dart';
import 'package:crypto_wallet/databases/adaptors/address_adaptor.dart';
import 'package:crypto_wallet/databases/adaptors/base_key_adaptor.dart';
import 'package:crypto_wallet/databases/adaptors/wallet_adaptor.dart';
import 'package:crypto_wallet/databases/adaptors/wallet_branch_adaptor.dart';
import 'package:crypto_wallet/databases/adaptors/wallet_root_adaptor.dart';
import 'package:crypto_wallet/databases/hive.dart';
import 'package:crypto_wallet/databases/secure_storage.dart';
import 'package:crypto_wallet/utils/crypto.dart';
import 'package:crypto_wallet/utils/date_time.dart';

// * wallet 전체 조회
Future<List<Wallet>> readAllWallets([
  int Function(Wallet, Wallet)? sort,
]) async {
  try {
    final Map walletMap = Hive.box(walletsBox).toMap();
    final List<Wallet> wallets = [];
    walletMap.forEach((key, value) => wallets.add(value));
    wallets.sort(
      sort ?? (Wallet a, Wallet b) => a.createdAt.compareTo(b.createdAt),
    );
    return wallets;
  } catch (error) {
    rethrow;
  }
}

// * wallet 조회
Future<List<Wallet>> findWallets(
  Map<String, dynamic> options, {
  int Function(Wallet, Wallet)? sort,
}) async {
  try {
    List<Wallet> find(String field, dynamic item, List<Wallet>? data) {
      late bool Function(Wallet) filter;
      switch (field) {
        case walletNameWord:
          filter = (Wallet wallet) => wallet.walletName == item;
          break;
        case walletIdWord:
        default:
          filter = (Wallet wallet) => wallet.walletId == item;
          break;
      }
      final List<Wallet> finded = (data != null)
          ? data.where(filter).toList()
          : Hive.box(walletsBox).values.cast<Wallet>().where(filter).toList();
      return finded;
    }

    List<Wallet>? result;
    for (var key in options.keys) {
      result = find(key, options[key], result);
    }

    if (result!.length > 1) {
      result.sort(
        sort ?? (Wallet a, Wallet b) => a.createdAt.compareTo(b.createdAt),
      );
    }
    return result;
  } catch (error) {
    rethrow;
  }
}

// * wallet root 전체 조회
Future<List<WalletRoot>> readAllWalletRoots([
  int Function(WalletRoot, WalletRoot)? sort,
]) async {
  try {
    final Map walletRootMap = Hive.box(walletRootsBox).toMap();
    final List<WalletRoot> walletRoots = [];
    walletRootMap.forEach((key, value) => walletRoots.add(value));
    walletRoots.sort(
      sort ??
          (WalletRoot a, WalletRoot b) => a.createdAt.compareTo(b.createdAt),
    );
    return walletRoots;
  } catch (error) {
    rethrow;
  }
}

// * wallet root 조회
Future<List<WalletRoot>> findWalletRoots(
  Map<String, dynamic> options, {
  int Function(WalletRoot, WalletRoot)? sort,
}) async {
  try {
    List<WalletRoot> find(String field, dynamic item, List<WalletRoot>? data) {
      late bool Function(WalletRoot) filter;
      switch (field) {
        case rootIdWord:
          filter = (WalletRoot walletRoot) => walletRoot.rootId == item;
          break;
        case typeWord:
          filter = (WalletRoot walletRoot) => walletRoot.type == item;
          break;
        case walletWord:
        default:
          filter = (WalletRoot walletRoot) => walletRoot.wallet == item;
          break;
      }
      final List<WalletRoot> finded = (data != null)
          ? data.where(filter).toList()
          : Hive.box(walletRootsBox)
              .values
              .cast<WalletRoot>()
              .where(filter)
              .toList();
      return finded;
    }

    List<WalletRoot>? result;
    for (var key in options.keys) {
      result = find(key, options[key], result);
    }

    if (result!.length > 1) {
      result.sort(
        sort ??
            (WalletRoot a, WalletRoot b) => a.createdAt.compareTo(b.createdAt),
      );
    }
    return result;
  } catch (error) {
    rethrow;
  }
}

// * wallet branch 전체 조회
Future<List<WalletBranch>> readAllWalletBranches([
  int Function(WalletBranch, WalletBranch)? sort,
]) async {
  try {
    final Map walletBranchMap = Hive.box(walletBranchesBox).toMap();
    final List<WalletBranch> walletBranches = [];
    walletBranchMap.forEach((key, value) => walletBranches.add(value));
    walletBranches.sort(
      sort ??
          (WalletBranch a, WalletBranch b) =>
              a.createdAt.compareTo(b.createdAt),
    );
    return walletBranches;
  } catch (error) {
    rethrow;
  }
}

// * wallet branch 조회
Future<List<WalletBranch>> findWalletBranches(
  Map<String, dynamic> options, {
  int Function(WalletBranch, WalletBranch)? sort,
}) async {
  try {
    List<WalletBranch> find(
        String field, dynamic item, List<WalletBranch>? data) {
      late bool Function(WalletBranch) filter;
      switch (field) {
        case walletRootWord:
          filter =
              (WalletBranch walletBranch) => walletBranch.walletRoot == item;
          break;
        case purposeWord:
          filter = (WalletBranch walletBranch) => walletBranch.purpose == item;
          break;
        case coinTypeWord:
          filter = (WalletBranch walletBranch) => walletBranch.coinType == item;
          break;
        case accountWord:
          filter = (WalletBranch walletBranch) => walletBranch.account == item;
          break;
        case isChangeWord:
          filter = (WalletBranch walletBranch) => walletBranch.isChange == item;
          break;
        case keysWord:
          filter = (WalletBranch walletBranch) =>
              listEquals(walletBranch.keys, item);
          break;
        case walletWord:
        default:
          filter = (WalletBranch walletBranch) =>
              walletBranch.walletRoot.wallet == item;
          break;
      }
      final List<WalletBranch> finded = (data != null)
          ? data.where(filter).toList()
          : Hive.box(walletBranchesBox)
              .values
              .cast<WalletBranch>()
              .where(filter)
              .toList();
      return finded;
    }

    List<WalletBranch>? result;
    for (var key in options.keys) {
      result = find(key, options[key], result);
    }

    if (result!.length > 1) {
      result.sort(
        sort ??
            (WalletBranch a, WalletBranch b) =>
                a.createdAt.compareTo(b.createdAt),
      );
    }
    return result;
  } catch (error) {
    rethrow;
  }
}

// * base key 전체 조회
Future<List<BaseKey>> readAllBaseKeys([
  int Function(BaseKey, BaseKey)? sort,
]) async {
  try {
    final Map baseKeyMap = Hive.box(baseKeysBox).toMap();
    final List<BaseKey> baseKeys = [];
    baseKeyMap.forEach((key, value) => baseKeys.add(value));
    baseKeys.sort(
      sort ?? (BaseKey a, BaseKey b) => a.createdAt.compareTo(b.createdAt),
    );
    return baseKeys;
  } catch (error) {
    rethrow;
  }
}

// * base key 조회
Future<List<BaseKey>> findBasekeys(
  Map<String, dynamic> options, {
  int Function(BaseKey, BaseKey)? sort,
}) async {
  try {
    List<BaseKey> find(String field, dynamic item, List<BaseKey>? data) {
      late bool Function(BaseKey) filter;
      switch (field) {
        case indexWord:
          filter = (BaseKey baseKey) => baseKey.index == item;
          break;
        case isPausedWord:
          filter = (BaseKey baseKey) => baseKey.isPaused == item;
          break;
        case addressesWord:
          filter = (BaseKey baseKey) => listEquals(baseKey.addresses, item);
          break;
        case keyIdWord:
        default:
          filter = (BaseKey baseKey) => baseKey.keyId == item;
          break;
      }
      final List<BaseKey> finded = (data != null)
          ? data.where(filter).toList()
          : Hive.box(baseKeysBox).values.cast<BaseKey>().where(filter).toList();
      return finded;
    }

    List<BaseKey>? result;
    for (var key in options.keys) {
      result = find(key, options[key], result);
    }

    if (result!.length > 1) {
      result.sort(
        sort ?? (BaseKey a, BaseKey b) => a.createdAt.compareTo(b.createdAt),
      );
    }
    return result;
  } catch (error) {
    rethrow;
  }
}

// * address 전체 조회
Future<List<Address>> readAlladdresses([
  int Function(Address, Address)? sort,
]) async {
  try {
    final Map addressMap = Hive.box(addressesBox).toMap();
    final List<Address> addresses = [];
    addressMap.forEach((key, value) => addresses.add(value));
    addresses.sort(
      sort ?? (Address a, Address b) => a.createdAt.compareTo(b.createdAt),
    );
    return addresses;
  } catch (error) {
    rethrow;
  }
}

// * address 조회
Future<List<Address>> findAddresses(
  Map<String, dynamic> options, {
  int Function(Address, Address)? sort,
}) async {
  try {
    List<Address> find(String field, dynamic item, List<Address>? data) {
      late bool Function(Address) filter;
      switch (field) {
        case typeWord:
          filter = (Address address) => address.type == item;
          break;
        case isChangeWord:
          filter = (Address address) => address.isChange == item;
          break;
        case addressWord:
        default:
          filter = (Address address) => address.address == item;
          break;
      }
      final List<Address> finded = (data != null)
          ? data.where(filter).toList()
          : Hive.box(addressesBox)
              .values
              .cast<Address>()
              .where(filter)
              .toList();
      return finded;
    }

    List<Address>? result;
    for (var key in options.keys) {
      result = find(key, options[key], result);
    }

    if (result!.length > 1) {
      result.sort(
        sort ?? (Address a, Address b) => a.createdAt.compareTo(b.createdAt),
      );
    }
    return result;
  } catch (error) {
    rethrow;
  }
}

// * Hive Disk 초기화(전체 데이터 제거)
Future<void> removeHiveFromDisk() async {
  try {
    await Hive.deleteFromDisk();
    await Hive.initFlutter();
    String? boxEncKeyHex = await SecureStorage.read(boxEncryptionKeyWord);
    if (boxEncKeyHex == null) {
      final Uint8List boxEncKeyBuffer = toSha256Buffer(
          '${getSecureRandomCharacters(48)}${getTimeNowMicro()}');
      await SecureStorage.write(
          boxEncryptionKeyWord, bufferToHex(boxEncKeyBuffer));
      await openAllBoxes(boxEncKeyBuffer);
    } else {
      await openAllBoxes(hexToBuffer(boxEncKeyHex));
    }
  } catch (error) {
    rethrow;
  }
}
