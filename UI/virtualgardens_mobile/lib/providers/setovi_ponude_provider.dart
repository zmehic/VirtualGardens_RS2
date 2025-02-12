import 'package:virtualgardens_mobile/models/setovi_ponude.dart';
import 'package:virtualgardens_mobile/providers/helper_providers/base_provider.dart';

class SetoviPonudeProvider extends BaseProvider<SetoviPonude> {
  SetoviPonudeProvider() : super("api/SetoviPonude");

  @override
  SetoviPonude fromJson(data) {
    return SetoviPonude.fromJson(data);
  }
}
