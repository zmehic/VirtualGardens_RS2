import 'package:virtualgardens_mobile/models/ulazi.dart';
import 'package:virtualgardens_mobile/providers/base_provider.dart';

class UlaziProvider extends BaseProvider<Ulaz> {
  UlaziProvider() : super("api/Ulazi");

  @override
  Ulaz fromJson(data) {
    return Ulaz.fromJson(data);
  }
}
