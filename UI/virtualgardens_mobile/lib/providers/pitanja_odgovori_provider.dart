import 'package:virtualgardens_mobile/models/pitanja_odgovori.dart';
import 'package:virtualgardens_mobile/providers/base_provider.dart';

class PitanjaOdgovoriProvider extends BaseProvider<PitanjeOdgovor> {
  PitanjaOdgovoriProvider() : super("api/PitanjaOdgovori");

  @override
  PitanjeOdgovor fromJson(data) {
    return PitanjeOdgovor.fromJson(data);
  }
}
