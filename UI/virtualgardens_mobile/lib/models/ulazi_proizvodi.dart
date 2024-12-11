import 'package:json_annotation/json_annotation.dart';
import 'package:virtualgardens_mobile/models/proizvod.dart';

part 'ulazi_proizvodi.g.dart';

@JsonSerializable()
class UlazProizvod {
  int ulaziProizvodiId;
  int ulazId;
  int proizvodId;
  int kolicina;
  Proizvod? proizvod;

  UlazProizvod({
    required this.ulaziProizvodiId,
    required this.ulazId,
    required this.proizvodId,
    required this.kolicina,
    this.proizvod,
  });

  factory UlazProizvod.fromJson(Map<String, dynamic> json) =>
      _$UlazProizvodFromJson(json);

  Map<String, dynamic> toJson() => _$UlazProizvodToJson(this);
}
