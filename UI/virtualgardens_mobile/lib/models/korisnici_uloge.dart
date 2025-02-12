import 'package:json_annotation/json_annotation.dart';
import 'package:virtualgardens_mobile/models/uloga.dart';

part 'korisnici_uloge.g.dart';

@JsonSerializable()
class KorisnikUloga {
  int korisniciUlogeId;
  int korisnikId;
  int ulogaId;
  Uloga uloga;

  KorisnikUloga({
    required this.korisniciUlogeId,
    required this.korisnikId,
    required this.ulogaId,
    required this.uloga,
  });

  factory KorisnikUloga.fromJson(Map<String, dynamic> json) =>
      _$KorisnikUlogaFromJson(json);

  Map<String, dynamic> toJson() => _$KorisnikUlogaToJson(this);
}
