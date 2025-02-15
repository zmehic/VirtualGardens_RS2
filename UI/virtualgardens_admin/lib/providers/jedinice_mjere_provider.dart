import 'package:virtualgardens_admin/models/jedinice_mjere.dart';
import 'package:virtualgardens_admin/providers/helper_providers/base_provider.dart';

class JediniceMjereProvider extends BaseProvider<JediniceMjere> {
  JediniceMjereProvider() : super("api/JediniceMjere");

  @override
  JediniceMjere fromJson(data) {
    return JediniceMjere.fromJson(data);
  }
}
