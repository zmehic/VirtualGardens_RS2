// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatisticsDTO _$StatisticsDTOFromJson(Map<String, dynamic> json) =>
    StatisticsDTO(
      kupci: (json['kupci'] as List<dynamic>)
          .map((e) => Buyers.fromJson(e as Map<String, dynamic>))
          .toList(),
      workers: (json['workers'] as List<dynamic>)
          .map((e) => Workers.fromJson(e as Map<String, dynamic>))
          .toList(),
      narudzbe:
          (json['narudzbe'] as List<dynamic>).map((e) => e as int).toList(),
      prihodi: (json['prihodi'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$StatisticsDTOToJson(StatisticsDTO instance) =>
    <String, dynamic>{
      'kupci': instance.kupci.map((e) => e.toJson()).toList(),
      'workers': instance.workers.map((e) => e.toJson()).toList(),
      'narudzbe': instance.narudzbe,
      'prihodi': instance.prihodi,
    };
