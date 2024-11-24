// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pitanja_odgovori.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PitanjeOdgovor _$PitanjeOdgovorFromJson(Map<String, dynamic> json) =>
    PitanjeOdgovor(
      pitanjeId: (json['pitanjeId'] as num).toInt(),
      tekst: json['tekst'] as String,
      datum: DateTime.parse(json['datum'] as String),
      korisnikId: (json['korisnikId'] as num).toInt(),
      narudzbaId: (json['narudzbaId'] as num).toInt(),
      korisnik: json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
      narudzba: json['narudzba'] == null
          ? null
          : Narudzba.fromJson(json['narudzba'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PitanjeOdgovorToJson(PitanjeOdgovor instance) =>
    <String, dynamic>{
      'pitanjeId': instance.pitanjeId,
      'tekst': instance.tekst,
      'datum': instance.datum.toIso8601String(),
      'korisnikId': instance.korisnikId,
      'narudzbaId': instance.narudzbaId,
      'korisnik': instance.korisnik,
      'narudzba': instance.narudzba,
    };
