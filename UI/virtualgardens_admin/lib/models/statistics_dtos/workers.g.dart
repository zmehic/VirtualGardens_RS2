// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Workers _$WorkersFromJson(Map<String, dynamic> json) => Workers(
      zaposlenik:
          Zaposlenik.fromJson(json['zaposlenik'] as Map<String, dynamic>),
      brojNarudzbi: (json['brojNarudzbi'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$WorkersToJson(Workers instance) => <String, dynamic>{
      'zaposlenik': instance.zaposlenik,
      'brojNarudzbi': instance.brojNarudzbi,
    };
