import 'package:json_annotation/json_annotation.dart';
import 'package:virtualgardens_mobile/models/korisnici.dart';

part 'narudzbe.g.dart';

@JsonSerializable()
class Narudzba {
  int narudzbaId;
  String brojNarudzbe;
  bool? otkazana;
  DateTime datum;
  bool placeno;
  bool? status;
  String? stateMachine;
  double ukupnaCijena;
  int korisnikId;
  int? nalogId;
  Korisnik? korisnik;

  Narudzba({
    required this.narudzbaId,
    required this.brojNarudzbe,
    this.otkazana,
    required this.datum,
    required this.placeno,
    this.status,
    this.stateMachine,
    required this.ukupnaCijena,
    required this.korisnikId,
    this.nalogId,
    this.korisnik,
  });

  factory Narudzba.fromJson(Map<String, dynamic> json) =>
      _$NarudzbaFromJson(json);

  Map<String, dynamic> toJson() => _$NarudzbaToJson(this);
}
