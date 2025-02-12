import 'package:json_annotation/json_annotation.dart';
import 'package:virtualgardens_admin/models/korisnici_uloge.dart';

part 'korisnici.g.dart';

@JsonSerializable()
class Korisnik {
  int korisnikId;
  String korisnickoIme;
  String email;
  String ime;
  String prezime;
  String? brojTelefona;
  String? adresa;
  String? grad;
  String? drzava;
  DateTime datumRegistracije;
  DateTime? zadnjiLogin;
  bool jeAktivan;
  DateTime? datumRodjenja;
  String? slika;
  List<KorisnikUloga> korisniciUloges;

  Korisnik(
      {required this.korisnikId,
      required this.korisnickoIme,
      required this.email,
      required this.ime,
      required this.prezime,
      required this.datumRegistracije,
      this.brojTelefona,
      this.adresa,
      this.grad,
      this.drzava,
      this.zadnjiLogin,
      this.jeAktivan = true,
      this.datumRodjenja,
      this.slika,
      this.korisniciUloges = const []});

  factory Korisnik.fromJson(Map<String, dynamic> json) =>
      _$KorisnikFromJson(json);

  Map<String, dynamic> toJson() => _$KorisnikToJson(this);
}
