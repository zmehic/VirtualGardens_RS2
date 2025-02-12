// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Buyers _$BuyersFromJson(Map<String, dynamic> json) => Buyers(
      korisnik: Korisnik.fromJson(json['korisnik'] as Map<String, dynamic>),
      brojNarudzbi: (json['brojNarudzbi'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$BuyersToJson(Buyers instance) => <String, dynamic>{
      'zaposlenik': instance.korisnik,
      'brojNarudzbi': instance.brojNarudzbi,
    };
