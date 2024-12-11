import 'package:virtualgardens_mobile/models/ulazi_proizvodi.dart';
import 'package:virtualgardens_mobile/providers/base_provider.dart';

class UlaziProizvodiProvider extends BaseProvider<UlazProizvod> {
  UlaziProizvodiProvider() : super("api/UlaziProizvodi");

  @override
  UlazProizvod fromJson(data) {
    return UlazProizvod.fromJson(data);
  }
}
