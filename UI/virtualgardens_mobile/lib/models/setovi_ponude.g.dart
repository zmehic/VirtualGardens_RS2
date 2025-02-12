// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setovi_ponude.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SetoviPonude _$SetoviPonudeFromJson(Map<String, dynamic> json) => SetoviPonude(
      setoviPonudeId: (json['setoviPonudeId'] as num).toInt(),
      setId: (json['setId'] as num).toInt(),
      ponudaId: (json['ponudaId'] as num).toInt(),
      set: json['set'] == null
          ? null
          : Set.fromJson(json['set'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SetoviPonudeToJson(SetoviPonude instance) =>
    <String, dynamic>{
      'setoviPonudeId': instance.setoviPonudeId,
      'setId': instance.setId,
      'ponudaId': instance.ponudaId,
      'set': instance.set,
    };
