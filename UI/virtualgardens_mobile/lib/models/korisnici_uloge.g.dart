// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'korisnici_uloge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KorisnikUloga _$KorisnikUlogaFromJson(Map<String, dynamic> json) =>
    KorisnikUloga(
      korisniciUlogeId: (json['korisniciUlogeId'] as num).toInt(),
      korisnikId: (json['korisnikId'] as num).toInt(),
      ulogaId: (json['ulogaId'] as num).toInt(),
      uloga: Uloga.fromJson(json['uloga'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$KorisnikUlogaToJson(KorisnikUloga instance) =>
    <String, dynamic>{
      'korisniciUlogeId': instance.korisniciUlogeId,
      'korisnikId': instance.korisnikId,
      'ulogaId': instance.ulogaId,
      'uloga': instance.uloga,
    };
