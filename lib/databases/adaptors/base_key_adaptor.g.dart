// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_key_adaptor.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BaseKeyAdapter extends TypeAdapter<BaseKey> {
  @override
  final int typeId = 6;

  @override
  BaseKey read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BaseKey(
      keyId: fields[0] as String,
      index: fields[1] as int,
      isPaused: fields[2] as bool,
      addresses: (fields[3] as HiveList).castHiveList(),
      createdAt: fields[4] as DateTime,
      updatedAt: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, BaseKey obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.keyId)
      ..writeByte(1)
      ..write(obj.index)
      ..writeByte(2)
      ..write(obj.isPaused)
      ..writeByte(3)
      ..write(obj.addresses)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BaseKeyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
