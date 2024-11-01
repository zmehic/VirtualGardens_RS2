// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zaposlenici.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Zaposlenik _$ZaposlenikFromJson(Map<String, dynamic> json) => Zaposlenik(
      zaposlenikId: (json['zaposlenikId'] as num).toInt(),
      email: json['email'] as String,
      ime: json['ime'] as String,
      prezime: json['prezime'] as String,
      brojTelefona: json['brojTelefona'] as String?,
      adresa: json['adresa'] as String?,
      grad: json['grad'] as String?,
      drzava: json['drzava'] as String?,
      jeAktivan: json['jeAktivan'] as bool,
      datumRodjenja: json['datumRodjenja'] == null
          ? null
          : DateTime.parse(json['datumRodjenja'] as String),
    );

Map<String, dynamic> _$ZaposlenikToJson(Zaposlenik instance) =>
    <String, dynamic>{
      'zaposlenikId': instance.zaposlenikId,
      'email': instance.email,
      'ime': instance.ime,
      'prezime': instance.prezime,
      'brojTelefona': instance.brojTelefona,
      'adresa': instance.adresa,
      'grad': instance.grad,
      'drzava': instance.drzava,
      'jeAktivan': instance.jeAktivan,
      'datumRodjenja': instance.datumRodjenja?.toIso8601String(),
    };
