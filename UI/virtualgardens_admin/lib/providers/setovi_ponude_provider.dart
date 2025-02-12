import 'package:virtualgardens_admin/models/setovi_ponude.dart';
import 'package:virtualgardens_admin/providers/helper_providers/base_provider.dart';

class SetoviPonudeProvider extends BaseProvider<SetoviPonude> {
  SetoviPonudeProvider() : super("api/SetoviPonude");

  @override
  SetoviPonude fromJson(data) {
    return SetoviPonude.fromJson(data);
  }
}
