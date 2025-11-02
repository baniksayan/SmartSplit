// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_split_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuickSplitModelAdapter extends TypeAdapter<QuickSplitModel> {
  @override
  final int typeId = 2;

  @override
  QuickSplitModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuickSplitModel(
      splitId: fields[0] as String,
      timestamp: fields[1] as DateTime,
      billAmount: fields[2] as double,
      numberOfPeople: fields[3] as int,
      taxAmount: fields[4] as double?,
      isTaxPercentage: fields[5] as bool,
      taxPercentage: fields[6] as double?,
      tipAmount: fields[7] as double?,
      isTipPercentage: fields[8] as bool,
      tipPercentage: fields[9] as double?,
      grandTotal: fields[10] as double,
      perPersonAmount: fields[11] as double,
      currency: fields[12] as String,
      restaurantName: fields[13] as String?,
      paidBy: (fields[14] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, QuickSplitModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.splitId)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.billAmount)
      ..writeByte(3)
      ..write(obj.numberOfPeople)
      ..writeByte(4)
      ..write(obj.taxAmount)
      ..writeByte(5)
      ..write(obj.isTaxPercentage)
      ..writeByte(6)
      ..write(obj.taxPercentage)
      ..writeByte(7)
      ..write(obj.tipAmount)
      ..writeByte(8)
      ..write(obj.isTipPercentage)
      ..writeByte(9)
      ..write(obj.tipPercentage)
      ..writeByte(10)
      ..write(obj.grandTotal)
      ..writeByte(11)
      ..write(obj.perPersonAmount)
      ..writeByte(12)
      ..write(obj.currency)
      ..writeByte(13)
      ..write(obj.restaurantName)
      ..writeByte(14)
      ..write(obj.paidBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuickSplitModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
