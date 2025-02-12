import 'package:json_annotation/json_annotation.dart';

part 'jedinice_mjere.g.dart';

@JsonSerializable()
class JediniceMjere {
  int? jedinicaMjereId;
  String? naziv;
  String? skracenica;
  String? opis;

  JediniceMjere({this.jedinicaMjereId, this.naziv});

  factory JediniceMjere.fromJson(Map<String, dynamic> json) =>
      _$JediniceMjereFromJson(json);

  Map<String, dynamic> toJson() => _$JediniceMjereToJson(this);
}
