import 'package:hive/hive.dart';
import 'package:crypto_wallet/utils/crypto.dart';
import 'package:crypto_wallet/utils/date_time.dart';

import 'wallet_adaptor.dart';

part 'wallet_root_adaptor.g.dart';

@HiveType(typeId: 1)
class WalletRoot extends HiveObject {
  @HiveField(0)
  final Wallet wallet;

  @HiveField(1)
  final String rootId;

  @HiveField(2)
  final String type;

  @HiveField(3)
  final DateTime createdAt;

  WalletRoot({
    required this.wallet,
    required this.rootId,
    required this.type,
    required this.createdAt,
  });

  factory WalletRoot.create({
    required Wallet wallet,
    required String rootId,
    required String type,
  }) {
    return WalletRoot(
      wallet: wallet,
      rootId: rootId,
      type: type,
      createdAt: DateTime.now(),
    );
  }

  factory WalletRoot.hashId({
    required Wallet wallet,
    required String type,
  }) {
    return WalletRoot.create(
      wallet: wallet,
      rootId: toSha256Hex('${wallet.walletId}$type${getTimeNowMicro()}'),
      type: type,
    );
  }

  @override
  String toString() {
    return 'WalletRoot(wallet: $wallet, rootId: $rootId, type: $type, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WalletRoot &&
        other.wallet == wallet &&
        other.rootId == rootId &&
        other.type == type &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return wallet.hashCode ^
        rootId.hashCode ^
        type.hashCode ^
        createdAt.hashCode;
  }
}
