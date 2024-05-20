// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_root_adaptor.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WalletRootAdapter extends TypeAdapter<WalletRoot> {
  @override
  final int typeId = 1;

  @override
  WalletRoot read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WalletRoot(
      wallet: fields[0] as Wallet,
      rootId: fields[1] as String,
      type: fields[2] as String,
      createdAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, WalletRoot obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.wallet)
      ..writeByte(1)
      ..write(obj.rootId)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletRootAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
