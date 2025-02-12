// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ponuda.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ponuda _$PonudaFromJson(Map<String, dynamic> json) => Ponuda(
      ponudaId: (json['ponudaId'] as num).toInt(),
      naziv: json['naziv'] as String,
      popust: (json['popust'] as num?)?.toInt(),
      stateMachine: json['stateMachine'] as String?,
      datumKreiranja: DateTime.parse(json['datumKreiranja'] as String),
      setoviPonudes: (json['setoviPonudes'] as List<dynamic>?)
              ?.map((e) => SetoviPonude.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$PonudaToJson(Ponuda instance) => <String, dynamic>{
      'ponudaId': instance.ponudaId,
      'naziv': instance.naziv,
      'popust': instance.popust,
      'stateMachine': instance.stateMachine,
      'datumKreiranja': instance.datumKreiranja.toIso8601String(),
      'setoviPonudes': instance.setoviPonudes,
    };
