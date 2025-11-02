// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityModelAdapter extends TypeAdapter<ActivityModel> {
  @override
  final int typeId = 1;

  @override
  ActivityModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivityModel(
      activityId: fields[0] as String,
      activityType: fields[1] as String,
      timestamp: fields[2] as DateTime,
      title: fields[3] as String,
      description: fields[4] as String?,
      amount: fields[5] as double?,
      participantCount: fields[6] as int?,
      groupId: fields[7] as String?,
      groupName: fields[8] as String?,
      paidBy: fields[9] as String?,
      amountPerPerson: fields[10] as double?,
      currency: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ActivityModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.activityId)
      ..writeByte(1)
      ..write(obj.activityType)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.amount)
      ..writeByte(6)
      ..write(obj.participantCount)
      ..writeByte(7)
      ..write(obj.groupId)
      ..writeByte(8)
      ..write(obj.groupName)
      ..writeByte(9)
      ..write(obj.paidBy)
      ..writeByte(10)
      ..write(obj.amountPerPerson)
      ..writeByte(11)
      ..write(obj.currency);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
