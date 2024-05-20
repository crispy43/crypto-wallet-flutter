import 'package:hive/hive.dart';

import 'base_key_adaptor.dart';
import 'wallet_root_adaptor.dart';

part 'wallet_branch_adaptor.g.dart';

@HiveType(typeId: 5)
class WalletBranch extends HiveObject {
  @HiveField(0)
  final WalletRoot walletRoot;

  @HiveField(1)
  final int purpose;

  @HiveField(2)
  final int coinType;

  @HiveField(3)
  final int account;

  @HiveField(4)
  final bool isChange;

  @HiveField(5)
  final HiveList<BaseKey> keys;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  DateTime? updatedAt;

  WalletBranch({
    required this.walletRoot,
    this.purpose = 44, // bip44
    required this.coinType,
    this.account = 0,
    this.isChange = false,
    required this.keys,
    required this.createdAt,
    this.updatedAt,
  });

  factory WalletBranch.create({
    required WalletRoot walletRoot,
    int? purpose,
    required int coinType,
    int? account,
    bool? isChange,
    required HiveList<BaseKey> keys,
  }) {
    return WalletBranch(
      walletRoot: walletRoot,
      purpose: purpose ?? 44,
      coinType: coinType,
      account: account ?? 0,
      isChange: isChange ?? false,
      keys: keys,
      createdAt: DateTime.now(),
    );
  }

  // * set updated at now
  void setUpdatedAtNow() => updatedAt = DateTime.now();

  void sortKeys() => keys.sort((a, b) => a.index.compareTo(b.index));

  int get nextIndex => keys.length;

  String get nextPath =>
      "m/$purpose'/$coinType'/$account'/${isChange ? 1 : 0}/$nextIndex";

  @override
  String toString() {
    return 'WalletBranch(walletRoot: $walletRoot, purpose: $purpose, coinType: $coinType, account: $account, isChange: $isChange, keys: $keys, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WalletBranch &&
        other.walletRoot == walletRoot &&
        other.purpose == purpose &&
        other.coinType == coinType &&
        other.account == account &&
        other.isChange == isChange &&
        other.keys == keys &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return walletRoot.hashCode ^
        purpose.hashCode ^
        coinType.hashCode ^
        account.hashCode ^
        isChange.hashCode ^
        keys.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
