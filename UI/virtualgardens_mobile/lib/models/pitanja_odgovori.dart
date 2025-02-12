import 'package:json_annotation/json_annotation.dart';
import 'package:virtualgardens_mobile/models/korisnici.dart';
import 'package:virtualgardens_mobile/models/narudzbe.dart';

part 'pitanja_odgovori.g.dart';

@JsonSerializable()
class PitanjeOdgovor {
  int pitanjeId;
  String tekst;
  DateTime datum;
  int korisnikId;
  int narudzbaId;
  Korisnik? korisnik;
  Narudzba? narudzba;

  PitanjeOdgovor({
    required this.pitanjeId,
    required this.tekst,
    required this.datum,
    required this.korisnikId,
    required this.narudzbaId,
    this.korisnik,
    this.narudzba,
  });

  factory PitanjeOdgovor.fromJson(Map<String, dynamic> json) =>
      _$PitanjeOdgovorFromJson(json);

  Map<String, dynamic> toJson() => _$PitanjeOdgovorToJson(this);
}
