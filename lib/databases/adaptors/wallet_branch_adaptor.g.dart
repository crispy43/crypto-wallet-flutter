// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_branch_adaptor.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WalletBranchAdapter extends TypeAdapter<WalletBranch> {
  @override
  final int typeId = 5;

  @override
  WalletBranch read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WalletBranch(
      walletRoot: fields[0] as WalletRoot,
      purpose: fields[1] as int,
      coinType: fields[2] as int,
      account: fields[3] as int,
      isChange: fields[4] as bool,
      keys: (fields[5] as HiveList).castHiveList(),
      createdAt: fields[6] as DateTime,
      updatedAt: fields[7] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, WalletBranch obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.walletRoot)
      ..writeByte(1)
      ..write(obj.purpose)
      ..writeByte(2)
      ..write(obj.coinType)
      ..writeByte(3)
      ..write(obj.account)
      ..writeByte(4)
      ..write(obj.isChange)
      ..writeByte(5)
      ..write(obj.keys)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletBranchAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
