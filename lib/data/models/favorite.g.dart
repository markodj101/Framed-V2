// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteAdapter extends TypeAdapter<Favorite> {
  @override
  final int typeId = 2;

  @override
  Favorite read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Favorite(
      movieId: fields[0] as int,
      image: fields[1] as String,
      favorite: fields[2] as bool,
      title: fields[3] as String,
      overview: fields[4] as String,
      popularity: fields[5] as double,
      releaseDate: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Favorite obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.movieId)
      ..writeByte(1)
      ..write(obj.image)
      ..writeByte(2)
      ..write(obj.favorite)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.overview)
      ..writeByte(5)
      ..write(obj.popularity)
      ..writeByte(6)
      ..write(obj.releaseDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
