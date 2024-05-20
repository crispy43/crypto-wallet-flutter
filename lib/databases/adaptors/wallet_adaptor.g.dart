// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_adaptor.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WalletAdapter extends TypeAdapter<Wallet> {
  @override
  final int typeId = 0;

  @override
  Wallet read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Wallet(
      walletId: fields[0] as String,
      walletName: fields[1] as String,
      createdAt: fields[2] as DateTime,
      updatedAt: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Wallet obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.walletId)
      ..writeByte(1)
      ..write(obj.walletName)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
