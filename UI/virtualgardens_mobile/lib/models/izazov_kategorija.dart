import 'package:json_annotation/json_annotation.dart';
import 'package:virtualgardens_mobile/models/korisnici.dart';

part 'izazov_kategorija.g.dart';

@JsonSerializable()
class IzazovKategorija {
  int id;
  String naziv;
  String praviloUspjeha;
  int tip;

  IzazovKategorija({
    required this.id,
    required this.naziv,
    required this.praviloUspjeha,
    required this.tip,
  });

  factory IzazovKategorija.fromJson(Map<String, dynamic> json) =>
      _$IzazovKategorijaFromJson(json);

  Map<String, dynamic> toJson() => _$IzazovKategorijaToJson(this);
}
