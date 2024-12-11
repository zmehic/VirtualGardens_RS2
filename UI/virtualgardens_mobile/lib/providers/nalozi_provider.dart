import 'package:virtualgardens_mobile/models/nalozi.dart';
import 'package:virtualgardens_mobile/providers/base_provider.dart';

class NaloziProvider extends BaseProvider<Nalog> {
  NaloziProvider() : super("api/Nalozi");

  @override
  Nalog fromJson(data) {
    return Nalog.fromJson(data);
  }
}
