// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'narudzbe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Narudzba _$NarudzbaFromJson(Map<String, dynamic> json) => Narudzba(
      narudzbaId: (json['narudzbaId'] as num).toInt(),
      brojNarudzbe: json['brojNarudzbe'] as String,
      otkazana: json['otkazana'] as bool?,
      datum: DateTime.parse(json['datum'] as String),
      placeno: json['placeno'] as bool,
      status: json['status'] as bool?,
      stateMachine: json['stateMachine'] as String?,
      ukupnaCijena: (json['ukupnaCijena'] as num).toDouble(),
      korisnikId: (json['korisnikId'] as num).toInt(),
      nalogId: (json['nalogId'] as num?)?.toInt(),
      korisnik: json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NarudzbaToJson(Narudzba instance) => <String, dynamic>{
      'narudzbaId': instance.narudzbaId,
      'brojNarudzbe': instance.brojNarudzbe,
      'otkazana': instance.otkazana,
      'datum': instance.datum.toIso8601String(),
      'placeno': instance.placeno,
      'status': instance.status,
      'stateMachine': instance.stateMachine,
      'ukupnaCijena': instance.ukupnaCijena,
      'korisnikId': instance.korisnikId,
      'nalogId': instance.nalogId,
      'korisnik': instance.korisnik,
    };
