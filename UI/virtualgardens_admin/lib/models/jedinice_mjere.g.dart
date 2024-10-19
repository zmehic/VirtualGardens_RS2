// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jedinice_mjere.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JediniceMjere _$JediniceMjereFromJson(Map<String, dynamic> json) =>
    JediniceMjere(
      jedinicaMjereId: (json['jedinicaMjereId'] as num?)?.toInt(),
      naziv: json['naziv'] as String?,
    )
      ..skracenica = json['skracenica'] as String?
      ..opis = json['opis'] as String?;

Map<String, dynamic> _$JediniceMjereToJson(JediniceMjere instance) =>
    <String, dynamic>{
      'jedinicaMjereId': instance.jedinicaMjereId,
      'naziv': instance.naziv,
      'skracenica': instance.skracenica,
      'opis': instance.opis,
    };
