// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Set _$SetFromJson(Map<String, dynamic> json) => Set(
      setId: (json['setId'] as num).toInt(),
      cijena: (json['cijena'] as num).toDouble(),
      popust: (json['popust'] as num?)?.toInt(),
      narudzbaId: (json['narudzbaId'] as num?)?.toInt(),
      cijenaSaPopustom: (json['cijenaSaPopustom'] as num?)?.toDouble(),
      narudzba: json['narudzba'] == null
          ? null
          : Narudzba.fromJson(json['narudzba'] as Map<String, dynamic>),
      proizvodiSets: (json['proizvodiSets'] as List<dynamic>?)
              ?.map((e) => ProizvodiSet.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SetToJson(Set instance) => <String, dynamic>{
      'setId': instance.setId,
      'cijena': instance.cijena,
      'popust': instance.popust,
      'narudzbaId': instance.narudzbaId,
      'cijenaSaPopustom': instance.cijenaSaPopustom,
      'narudzba': instance.narudzba,
      'proizvodiSets': instance.proizvodiSets,
    };
