// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      userId: fields[0] as String,
      userName: fields[1] as String,
      email: fields[2] as String?,
      profilePicture: fields[3] as String?,
      preferredCurrency: fields[4] as String,
      preferredLanguage: fields[5] as String,
      defaultSplitMode: fields[6] as String,
      createdAt: fields[7] as DateTime,
      themeMode: fields[8] as String?,
      customPrimaryColor: fields[9] as String?,
      customSecondaryColor: fields[10] as String?,
      customAccentColor: fields[11] as String?,
      fontSize: fields[12] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.profilePicture)
      ..writeByte(4)
      ..write(obj.preferredCurrency)
      ..writeByte(5)
      ..write(obj.preferredLanguage)
      ..writeByte(6)
      ..write(obj.defaultSplitMode)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.themeMode)
      ..writeByte(9)
      ..write(obj.customPrimaryColor)
      ..writeByte(10)
      ..write(obj.customSecondaryColor)
      ..writeByte(11)
      ..write(obj.customAccentColor)
      ..writeByte(12)
      ..write(obj.fontSize);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
