// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ulazi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ulaz _$UlazFromJson(Map<String, dynamic> json) => Ulaz(
      ulazId: (json['ulazId'] as num).toInt(),
      brojUlaza: json['brojUlaza'] as String,
      datumUlaza: DateTime.parse(json['datumUlaza'] as String),
      korisnikId: (json['korisnikId'] as num).toInt(),
      korisnik: Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UlazToJson(Ulaz instance) => <String, dynamic>{
      'ulazId': instance.ulazId,
      'brojUlaza': instance.brojUlaza,
      'datumUlaza': instance.datumUlaza.toIso8601String(),
      'korisnikId': instance.korisnikId,
      'korisnik': instance.korisnik,
    };
