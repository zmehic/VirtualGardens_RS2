import 'package:virtualgardens_admin/models/narudzbe.dart';
import 'package:virtualgardens_admin/providers/base_provider.dart';

class NarudzbaProvider extends BaseProvider<Narudzba> {
  NarudzbaProvider() : super("api/Narudzbe");

  @override
  Narudzba fromJson(data) {
    return Narudzba.fromJson(data);
  }
}
