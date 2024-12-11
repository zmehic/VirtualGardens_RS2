// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ulazi_proizvodi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UlazProizvod _$UlazProizvodFromJson(Map<String, dynamic> json) => UlazProizvod(
      ulaziProizvodiId: (json['ulaziProizvodiId'] as num).toInt(),
      ulazId: (json['ulazId'] as num).toInt(),
      proizvodId: (json['proizvodId'] as num).toInt(),
      kolicina: (json['kolicina'] as num).toInt(),
      proizvod: json['proizvod'] == null
          ? null
          : Proizvod.fromJson(json['proizvod'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UlazProizvodToJson(UlazProizvod instance) =>
    <String, dynamic>{
      'ulaziProizvodiId': instance.ulaziProizvodiId,
      'ulazId': instance.ulazId,
      'proizvodId': instance.proizvodId,
      'kolicina': instance.kolicina,
      'proizvod': instance.proizvod,
    };
