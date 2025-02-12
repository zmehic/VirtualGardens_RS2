import 'package:virtualgardens_admin/models/pitanja_odgovori.dart';
import 'package:virtualgardens_admin/providers/helper_providers/base_provider.dart';

class PitanjaOdgovoriProvider extends BaseProvider<PitanjeOdgovor> {
  PitanjaOdgovoriProvider() : super("api/PitanjaOdgovori");

  @override
  PitanjeOdgovor fromJson(data) {
    return PitanjeOdgovor.fromJson(data);
  }
}
