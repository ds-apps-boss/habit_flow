// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_meta.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SyncMetaAdapter extends TypeAdapter<SyncMeta> {
  @override
  final typeId = 30;

  @override
  SyncMeta read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SyncMeta(
      lastSyncAt: fields[0] as DateTime?,
      mode: fields[1] as SyncMode,
      scheduledSyncInMinutes: (fields[2] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, SyncMeta obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.lastSyncAt)
      ..writeByte(1)
      ..write(obj.mode)
      ..writeByte(2)
      ..write(obj.scheduledSyncInMinutes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncMetaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SyncModeAdapter extends TypeAdapter<SyncMode> {
  @override
  final typeId = 31;

  @override
  SyncMode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SyncMode.manual;
      case 1:
        return SyncMode.scheduled;
      case 2:
        return SyncMode.automatic;
      default:
        return SyncMode.manual;
    }
  }

  @override
  void write(BinaryWriter writer, SyncMode obj) {
    switch (obj) {
      case SyncMode.manual:
        writer.writeByte(0);
      case SyncMode.scheduled:
        writer.writeByte(1);
      case SyncMode.automatic:
        writer.writeByte(2);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
