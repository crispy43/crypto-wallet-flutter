import 'package:hive/hive.dart';
import 'package:crypto_wallet/utils/crypto.dart';
import 'package:crypto_wallet/utils/date_time.dart';

part 'wallet_adaptor.g.dart';

@HiveType(typeId: 0)
class Wallet extends HiveObject {
  @HiveField(0)
  final String walletId;

  @HiveField(1)
  String walletName;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  DateTime? updatedAt;

  Wallet({
    required this.walletId,
    required this.walletName,
    required this.createdAt,
    this.updatedAt,
  });

  factory Wallet.create({
    required String walletId,
    required String walletName,
  }) {
    return Wallet(
      walletId: walletId,
      walletName: walletName,
      createdAt: DateTime.now(),
    );
  }

  factory Wallet.hashId({
    required String walletName,
  }) {
    return Wallet.create(
      walletId: toSha256Hex('$walletName${getTimeNowMicro()}'),
      walletName: walletName,
    );
  }

  // * set updated at now
  void setUpdatedAtNow() => updatedAt = DateTime.now();

  void setWalletName(String newName) {
    walletName = newName;
    setUpdatedAtNow();
  }

  @override
  String toString() {
    return 'Wallet(walletId: $walletId, walletName: $walletName, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Wallet &&
        other.walletId == walletId &&
        other.walletName == walletName &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return walletId.hashCode ^
        walletName.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
