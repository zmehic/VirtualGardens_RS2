// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'izazov.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Izazov _$IzazovFromJson(Map<String, dynamic> json) => Izazov(
      id: (json['id'] as num).toInt(),
      korisnikId: (json['korisnikId'] as num).toInt(),
      korisnik: json['korisnik'] == null
          ? null
          : Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
      izazovId: (json['izazovId'] as num).toInt(),
      izazov: json['izazov'] == null
          ? null
          : IzazovKategorija.fromJson(json['izazov'] as Map<String, dynamic>),
      datumPrihvatanja: DateTime.parse(json['datumPrihvatanja'] as String),
      status: (json['status'] as num).toInt(),
      brojPonavljanja: (json['brojPonavljanja'] as num).toInt(),
      vrijemeZavrsetka: json['vrijemeZavrsetka'] == null
          ? null
          : DateTime.parse(json['vrijemeZavrsetka'] as String),
    );

Map<String, dynamic> _$IzazovToJson(Izazov instance) => <String, dynamic>{
      'id': instance.id,
      'korisnikId': instance.korisnikId,
      'korisnik': instance.korisnik,
      'izazovId': instance.izazovId,
      'izazov': instance.izazov,
      'datumPrihvatanja': instance.datumPrihvatanja.toIso8601String(),
      'status': instance.status,
      'brojPonavljanja': instance.brojPonavljanja,
      'vrijemeZavrsetka': instance.vrijemeZavrsetka?.toIso8601String(),
    };
