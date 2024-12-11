import 'package:json_annotation/json_annotation.dart';
import 'package:virtualgardens_mobile/models/set.dart';

part 'setovi_ponude.g.dart';

@JsonSerializable()
class SetoviPonude {
  int setoviPonudeId;
  int setId;
  int ponudaId;
  Set? set;

  SetoviPonude({
    required this.setoviPonudeId,
    required this.setId,
    required this.ponudaId,
    this.set,
  });

  factory SetoviPonude.fromJson(Map<String, dynamic> json) =>
      _$SetoviPonudeFromJson(json);

  Map<String, dynamic> toJson() => _$SetoviPonudeToJson(this);
}
