import 'package:json_annotation/json_annotation.dart';
import 'package:virtualgardens_mobile/models/proizvod.dart';

part 'proizvodi_setovi.g.dart';

@JsonSerializable()
class ProizvodiSet {
  int proizvodSetId;
  int proizvodId;
  int setId;
  int kolicina;
  Proizvod? proizvod;

  ProizvodiSet({
    required this.proizvodSetId,
    required this.proizvodId,
    required this.setId,
    required this.kolicina,
    this.proizvod,
  });

  factory ProizvodiSet.fromJson(Map<String, dynamic> json) =>
      _$ProizvodiSetFromJson(json);

  Map<String, dynamic> toJson() => _$ProizvodiSetToJson(this);
}
