// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'izazov_kategorija.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IzazovKategorija _$IzazovKategorijaFromJson(Map<String, dynamic> json) =>
    IzazovKategorija(
      id: (json['id'] as num).toInt(),
      naziv: json['naziv'] as String,
      praviloUspjeha: json['praviloUspjeha'] as String,
      tip: (json['tip'] as num).toInt(),
    );

Map<String, dynamic> _$IzazovKategorijaToJson(IzazovKategorija instance) =>
    <String, dynamic>{
      'id': instance.id,
      'naziv': instance.naziv,
      'praviloUspjeha': instance.praviloUspjeha,
      'tip': instance.tip,
    };
