// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proizvod.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Proizvod _$ProizvodFromJson(Map<String, dynamic> json) => Proizvod(
      proizvodId: (json['proizvodId'] as num?)?.toInt(),
      naziv: json['naziv'] as String?,
    )
      ..opis = json['opis'] as String?
      ..dostupnaKolicina = (json['dostupnaKolicina'] as num?)?.toInt()
      ..slika = json['slika'] as String?
      ..cijena = (json['cijena'] as num?)?.toDouble()
      ..vrstaProizvodaId = (json['vrstaProizvodaId'] as num?)?.toInt()
      ..jedinicaMjereId = (json['jedinicaMjereId'] as num?)?.toInt()
      ..slikaThumb = json['slikaThumb'] as String?;

Map<String, dynamic> _$ProizvodToJson(Proizvod instance) => <String, dynamic>{
      'proizvodId': instance.proizvodId,
      'naziv': instance.naziv,
      'opis': instance.opis,
      'dostupnaKolicina': instance.dostupnaKolicina,
      'slika': instance.slika,
      'cijena': instance.cijena,
      'vrstaProizvodaId': instance.vrstaProizvodaId,
      'jedinicaMjereId': instance.jedinicaMjereId,
      'slikaThumb': instance.slikaThumb,
    };
