// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'korisnici.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Korisnik _$KorisnikFromJson(Map<String, dynamic> json) => Korisnik(
      korisnikId: (json['korisnikId'] as num).toInt(),
      korisnickoIme: json['korisnickoIme'] as String,
      email: json['email'] as String,
      ime: json['ime'] as String,
      prezime: json['prezime'] as String,
      datumRegistracije: DateTime.parse(json['datumRegistracije'] as String),
      brojTelefona: json['brojTelefona'] as String?,
      adresa: json['adresa'] as String?,
      grad: json['grad'] as String?,
      drzava: json['drzava'] as String?,
      zadnjiLogin: json['zadnjiLogin'] == null
          ? null
          : DateTime.parse(json['zadnjiLogin'] as String),
      jeAktivan: json['jeAktivan'] as bool? ?? true,
      datumRodjenja: json['datumRodjenja'] == null
          ? null
          : DateTime.parse(json['datumRodjenja'] as String),
      slika: json['slika'] as String?,
      korisniciUloges: (json['korisniciUloges'] as List<dynamic>?)
              ?.map((e) => KorisnikUloga.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$KorisnikToJson(Korisnik instance) => <String, dynamic>{
      'korisnikId': instance.korisnikId,
      'korisnickoIme': instance.korisnickoIme,
      'email': instance.email,
      'ime': instance.ime,
      'prezime': instance.prezime,
      'brojTelefona': instance.brojTelefona,
      'adresa': instance.adresa,
      'grad': instance.grad,
      'drzava': instance.drzava,
      'datumRegistracije': instance.datumRegistracije.toIso8601String(),
      'zadnjiLogin': instance.zadnjiLogin?.toIso8601String(),
      'jeAktivan': instance.jeAktivan,
      'datumRodjenja': instance.datumRodjenja?.toIso8601String(),
      'slika': instance.slika,
      'korisniciUloges': instance.korisniciUloges,
    };
