import 'package:virtualgardens_admin/models/ulazi.dart';
import 'package:virtualgardens_admin/providers/base_provider.dart';

class UlaziProvider extends BaseProvider<Ulaz> {
  UlaziProvider() : super("api/Ulazi");

  @override
  Ulaz fromJson(data) {
    return Ulaz.fromJson(data);
  }
}
