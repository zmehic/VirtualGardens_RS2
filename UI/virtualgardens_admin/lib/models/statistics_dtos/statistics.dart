import 'package:json_annotation/json_annotation.dart';
import 'package:virtualgardens_admin/models/statistics_dtos/buyers.dart';
import 'package:virtualgardens_admin/models/statistics_dtos/workers.dart';
part 'statistics.g.dart';

@JsonSerializable()
class StatisticsDTO {
  List<Buyers> kupci;
  List<Workers> workers;
  List<int> narudzbe;
  List<double> prihodi;

  StatisticsDTO({
    required this.kupci,
    required this.workers,
    required this.narudzbe,
    required this.prihodi,
  });

  factory StatisticsDTO.fromJson(Map<String, dynamic> json) =>
      _$StatisticsDTOFromJson(json);

  Map<String, dynamic> toJson() => _$StatisticsDTOToJson(this);
}
