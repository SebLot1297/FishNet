// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fish_provider.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FishAdapter extends TypeAdapter<Fish> {
  @override
  final int typeId = 0;

  @override
  Fish read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Fish(
      name: fields[0] as String,
      fishImagePath: fields[1] as String,
      userID: fields[2] as String,
      weight: fields[3] as double?,
      length: fields[4] as double?,
      idStatus: fields[5] as IdentificationStatus,
    );
  }

  @override
  void write(BinaryWriter writer, Fish obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.fishImagePath)
      ..writeByte(2)
      ..write(obj.userID)
      ..writeByte(3)
      ..write(obj.weight)
      ..writeByte(4)
      ..write(obj.length)
      ..writeByte(5)
      ..write(obj.idStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FishAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IdentificationStatusAdapter extends TypeAdapter<IdentificationStatus> {
  @override
  final int typeId = 1;

  @override
  IdentificationStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return IdentificationStatus.pending;
      case 1:
        return IdentificationStatus.complete;
      case 2:
        return IdentificationStatus.failed;
      default:
        return IdentificationStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, IdentificationStatus obj) {
    switch (obj) {
      case IdentificationStatus.pending:
        writer.writeByte(0);
        break;
      case IdentificationStatus.complete:
        writer.writeByte(1);
        break;
      case IdentificationStatus.failed:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdentificationStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
