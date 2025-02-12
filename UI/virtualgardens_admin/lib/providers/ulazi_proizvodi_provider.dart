import 'package:virtualgardens_admin/models/ulazi_proizvodi.dart';
import 'package:virtualgardens_admin/providers/helper_providers/base_provider.dart';

class UlaziProizvodiProvider extends BaseProvider<UlazProizvod> {
  UlaziProizvodiProvider() : super("api/UlaziProizvodi");

  @override
  UlazProizvod fromJson(data) {
    return UlazProizvod.fromJson(data);
  }
}
