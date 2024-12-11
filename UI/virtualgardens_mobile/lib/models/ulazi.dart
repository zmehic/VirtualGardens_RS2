import 'package:json_annotation/json_annotation.dart';
import 'package:virtualgardens_mobile/models/korisnici.dart';

part 'ulazi.g.dart';

@JsonSerializable()
class Ulaz {
  int ulazId;
  String brojUlaza;
  DateTime datumUlaza;
  int korisnikId;
  Korisnik korisnik;

  Ulaz({
    required this.ulazId,
    required this.brojUlaza,
    required this.datumUlaza,
    required this.korisnikId,
    required this.korisnik,
  });

  factory Ulaz.fromJson(Map<String, dynamic> json) => _$UlazFromJson(json);

  Map<String, dynamic> toJson() => _$UlazToJson(this);
}
