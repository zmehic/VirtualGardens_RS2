import 'package:json_annotation/json_annotation.dart';
import 'package:virtualgardens_admin/models/zaposlenici.dart';

part 'workers.g.dart';

@JsonSerializable()
class Workers {
  Zaposlenik zaposlenik;
  int brojNarudzbi;

  Workers({required this.zaposlenik, this.brojNarudzbi = 0});

  factory Workers.fromJson(Map<String, dynamic> json) =>
      _$WorkersFromJson(json);

  Map<String, dynamic> toJson() => _$WorkersToJson(this);
}
