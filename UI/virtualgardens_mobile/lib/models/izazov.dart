import 'package:json_annotation/json_annotation.dart';
import 'package:virtualgardens_mobile/models/izazov_kategorija.dart';
import 'package:virtualgardens_mobile/models/korisnici.dart';

part 'izazov.g.dart';

@JsonSerializable()
class Izazov {
  int id;
  int korisnikId;
  Korisnik? korisnik;
  int izazovId;
  IzazovKategorija? izazov;
  DateTime datumPrihvatanja;
  int status;
  int brojPonavljanja;
  DateTime? vrijemeZavrsetka;

  Izazov(
      {required this.id,
      required this.korisnikId,
      this.korisnik,
      required this.izazovId,
      this.izazov,
      required this.datumPrihvatanja,
      required this.status,
      required this.brojPonavljanja,
      required this.vrijemeZavrsetka});

  factory Izazov.fromJson(Map<String, dynamic> json) => _$IzazovFromJson(json);

  Map<String, dynamic> toJson() => _$IzazovToJson(this);
}
