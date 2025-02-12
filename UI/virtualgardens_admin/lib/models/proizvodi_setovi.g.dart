// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proizvodi_setovi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProizvodiSet _$ProizvodiSetFromJson(Map<String, dynamic> json) => ProizvodiSet(
      proizvodSetId: (json['proizvodSetId'] as num).toInt(),
      proizvodId: (json['proizvodId'] as num).toInt(),
      setId: (json['setId'] as num).toInt(),
      kolicina: (json['kolicina'] as num).toInt(),
      proizvod: json['proizvod'] == null
          ? null
          : Proizvod.fromJson(json['proizvod'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProizvodiSetToJson(ProizvodiSet instance) =>
    <String, dynamic>{
      'proizvodSetId': instance.proizvodSetId,
      'proizvodId': instance.proizvodId,
      'setId': instance.setId,
      'kolicina': instance.kolicina,
      'proizvod': instance.proizvod,
    };
