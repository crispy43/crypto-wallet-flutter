// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_adaptor.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddressAdapter extends TypeAdapter<Address> {
  @override
  final int typeId = 7;

  @override
  Address read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Address(
      address: fields[0] as String,
      type: fields[1] as String?,
      isChange: fields[2] as bool?,
      label: fields[3] as String?,
      createdAt: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Address obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.address)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.isChange)
      ..writeByte(3)
      ..write(obj.label)
      ..writeByte(4)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
