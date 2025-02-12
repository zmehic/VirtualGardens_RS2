import 'package:virtualgardens_admin/models/nalozi.dart';
import 'package:virtualgardens_admin/providers/helper_providers/base_provider.dart';

class NaloziProvider extends BaseProvider<Nalog> {
  NaloziProvider() : super("api/Nalozi");

  @override
  Nalog fromJson(data) {
    return Nalog.fromJson(data);
  }
}
