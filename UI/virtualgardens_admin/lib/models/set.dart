import 'package:json_annotation/json_annotation.dart';
import 'package:virtualgardens_admin/models/narudzbe.dart';
import 'package:virtualgardens_admin/models/proizvodi_setovi.dart';

part 'set.g.dart';

@JsonSerializable()
class Set {
  int setId;
  int cijena;
  int? popust;
  int? narudzbaId;
  int? cijenaSaPopustom;
  Narudzba? narudzba;
  List<ProizvodiSet> proizvodiSets;

  Set({
    required this.setId,
    required this.cijena,
    this.popust,
    this.narudzbaId,
    this.cijenaSaPopustom,
    this.narudzba,
    this.proizvodiSets = const [],
  });

  factory Set.fromJson(Map<String, dynamic> json) => _$SetFromJson(json);

  Map<String, dynamic> toJson() => _$SetToJson(this);
}
