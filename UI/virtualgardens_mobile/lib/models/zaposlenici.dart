import 'package:json_annotation/json_annotation.dart';

part 'zaposlenici.g.dart';

@JsonSerializable()
class Zaposlenik {
  int zaposlenikId;
  String email;
  String ime;
  String prezime;
  String? brojTelefona;
  String? adresa;
  String? grad;
  String? drzava;
  bool jeAktivan;
  DateTime? datumRodjenja;

  Zaposlenik({
    required this.zaposlenikId,
    required this.email,
    required this.ime,
    required this.prezime,
    this.brojTelefona,
    this.adresa,
    this.grad,
    this.drzava,
    required this.jeAktivan,
    this.datumRodjenja,
  });

  factory Zaposlenik.fromJson(Map<String, dynamic> json) =>
      _$ZaposlenikFromJson(json);

  Map<String, dynamic> toJson() => _$ZaposlenikToJson(this);
}
