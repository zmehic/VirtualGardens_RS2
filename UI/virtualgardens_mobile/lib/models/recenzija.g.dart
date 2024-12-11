// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recenzija.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recenzija _$RecenzijaFromJson(Map<String, dynamic> json) => Recenzija(
      recenzijaId: (json['recenzijaId'] as num).toInt(),
      ocjena: (json['ocjena'] as num).toInt(),
      komentar: json['komentar'] as String?,
      korisnikId: (json['korisnikId'] as num).toInt(),
      datum: DateTime.parse(json['datum'] as String),
      proizvodId: (json['proizvodId'] as num).toInt(),
      korisnik: json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
      proizvod: json['proizvod'] == null
          ? null
          : Proizvod.fromJson(json['proizvod'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RecenzijaToJson(Recenzija instance) => <String, dynamic>{
      'recenzijaId': instance.recenzijaId,
      'ocjena': instance.ocjena,
      'komentar': instance.komentar,
      'korisnikId': instance.korisnikId,
      'datum': instance.datum.toIso8601String(),
      'proizvodId': instance.proizvodId,
      'korisnik': instance.korisnik,
      'proizvod': instance.proizvod,
    };
