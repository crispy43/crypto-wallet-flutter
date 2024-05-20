import 'package:hive/hive.dart';
import 'package:crypto_wallet/utils/crypto.dart';
import 'package:crypto_wallet/utils/date_time.dart';

import 'address_adaptor.dart';

part 'base_key_adaptor.g.dart';

@HiveType(typeId: 6)
class BaseKey extends HiveObject {
  @HiveField(0)
  final String keyId;

  @HiveField(1)
  final int index;

  @HiveField(2)
  bool isPaused;

  @HiveField(3)
  HiveList<Address> addresses;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  DateTime? updatedAt;

  BaseKey({
    required this.keyId,
    required this.index,
    this.isPaused = false,
    required this.addresses,
    required this.createdAt,
    this.updatedAt,
  });

  factory BaseKey.create({
    required String keyId,
    required int index,
    bool? isPaused,
    required HiveList<Address> addresses,
  }) {
    return BaseKey(
      keyId: keyId,
      index: index,
      isPaused: isPaused ?? false,
      addresses: addresses,
      createdAt: DateTime.now(),
    );
  }

  factory BaseKey.hashId({
    required int index,
    bool? isPaused,
    required HiveList<Address> addresses,
  }) {
    return BaseKey.create(
      keyId: toSha256Hex('$index${getTimeNowMicro()}'),
      index: index,
      isPaused: isPaused ?? false,
      addresses: addresses,
    );
  }

  // * 첫번째 주소 가져오기
  get address => addresses.first.address;

  // * set updated at now
  void setUpdatedAtNow() => updatedAt = DateTime.now();

  @override
  String toString() {
    return 'BaseKey(keyId: $keyId, index: $index, isPaused: $isPaused, addresses: $addresses, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BaseKey &&
        other.keyId == keyId &&
        other.index == index &&
        other.isPaused == isPaused &&
        other.addresses == addresses &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return keyId.hashCode ^
        index.hashCode ^
        isPaused.hashCode ^
        addresses.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
