import 'package:virtualgardens_mobile/models/zaposlenici.dart';
import 'package:virtualgardens_mobile/providers/base_provider.dart';

class ZaposlenikProvider extends BaseProvider<Zaposlenik> {
  ZaposlenikProvider() : super("api/Zaposlenici");

  @override
  Zaposlenik fromJson(data) {
    return Zaposlenik.fromJson(data);
  }
}
