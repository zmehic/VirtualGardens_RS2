import 'package:json_annotation/json_annotation.dart';
import 'package:virtualgardens_mobile/models/korisnici.dart';
import 'package:virtualgardens_mobile/models/proizvod.dart';

part 'recenzija.g.dart';

@JsonSerializable()
class Recenzija {
  int recenzijaId;
  int ocjena;
  String? komentar;
  int korisnikId;
  DateTime datum;
  int proizvodId;
  Korisnik? korisnik;
  Proizvod? proizvod;

  Recenzija({
    required this.recenzijaId,
    required this.ocjena,
    this.komentar,
    required this.korisnikId,
    required this.datum,
    required this.proizvodId,
    this.korisnik,
    this.proizvod,
  });

  factory Recenzija.fromJson(Map<String, dynamic> json) =>
      _$RecenzijaFromJson(json);

  Map<String, dynamic> toJson() => _$RecenzijaToJson(this);
}
