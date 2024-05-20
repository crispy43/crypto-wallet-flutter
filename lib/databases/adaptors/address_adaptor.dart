import 'package:hive/hive.dart';

part 'address_adaptor.g.dart';

@HiveType(typeId: 7)
class Address extends HiveObject {
  @HiveField(0)
  final String address;

  @HiveField(1)
  final String? type;

  @HiveField(2)
  final bool? isChange;

  @HiveField(3)
  final String? label;

  @HiveField(4)
  final DateTime createdAt;

  Address({
    required this.address,
    this.type,
    this.isChange,
    this.label,
    required this.createdAt,
  });

  factory Address.create({
    required String address,
    String? type,
    bool? isChange,
    String? label,
  }) {
    return Address(
      address: address,
      type: type,
      isChange: isChange,
      label: label,
      createdAt: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'Address(address: $address, type: $type, isChange: $isChange, label: $label, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Address &&
        other.address == address &&
        other.type == type &&
        other.isChange == isChange &&
        other.label == label &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return address.hashCode ^
        type.hashCode ^
        isChange.hashCode ^
        label.hashCode ^
        createdAt.hashCode;
  }
}
