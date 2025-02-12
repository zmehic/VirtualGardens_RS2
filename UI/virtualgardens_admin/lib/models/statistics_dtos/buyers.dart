import 'package:json_annotation/json_annotation.dart';
import 'package:virtualgardens_admin/models/korisnici.dart';

part 'buyers.g.dart';

@JsonSerializable()
class Buyers {
  Korisnik korisnik;
  int brojNarudzbi;

  Buyers({required this.korisnik, this.brojNarudzbi = 0});

  factory Buyers.fromJson(Map<String, dynamic> json) => _$BuyersFromJson(json);

  Map<String, dynamic> toJson() => _$BuyersToJson(this);
}
