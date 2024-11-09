// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nalozi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Nalog _$NalogFromJson(Map<String, dynamic> json) => Nalog(
      nalogId: (json['nalogId'] as num).toInt(),
      brojNaloga: json['brojNaloga'] as String,
      datumKreiranja: DateTime.parse(json['datumKreiranja'] as String),
      zaposlenikId: (json['zaposlenikId'] as num).toInt(),
      zavrsen: json['zavrsen'] as bool,
      zaposlenik: json['zaposlenik'] == null
          ? null
          : Zaposlenik.fromJson(json['zaposlenik'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NalogToJson(Nalog instance) => <String, dynamic>{
      'nalogId': instance.nalogId,
      'brojNaloga': instance.brojNaloga,
      'datumKreiranja': instance.datumKreiranja.toIso8601String(),
      'zaposlenikId': instance.zaposlenikId,
      'zavrsen': instance.zavrsen,
      'zaposlenik': instance.zaposlenik,
    };
