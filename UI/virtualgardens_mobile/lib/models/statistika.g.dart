// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistika.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Statistika _$StatistikaFromJson(Map<String, dynamic> json) => Statistika(
      naziv: json['naziv'] as String,
      broj: (json['broj'] as num).toInt(),
    );

Map<String, dynamic> _$StatistikaToJson(Statistika instance) =>
    <String, dynamic>{
      'naziv': instance.naziv,
      'broj': instance.broj,
    };
