import 'package:json_annotation/json_annotation.dart';
import 'package:virtualgardens_admin/models/setovi_ponude.dart';

part 'ponuda.g.dart';

@JsonSerializable()
class Ponuda {
  int ponudaId;
  String naziv;
  int? popust;
  String? stateMachine;
  DateTime datumKreiranja;
  List<SetoviPonude> setoviPonudes;

  Ponuda({
    required this.ponudaId,
    required this.naziv,
    this.popust,
    this.stateMachine,
    required this.datumKreiranja,
    this.setoviPonudes = const [],
  });

  factory Ponuda.fromJson(Map<String, dynamic> json) => _$PonudaFromJson(json);

  Map<String, dynamic> toJson() => _$PonudaToJson(this);
}
