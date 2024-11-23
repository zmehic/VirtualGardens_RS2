import 'package:virtualgardens_admin/models/proizvodi_setovi.dart';
import 'package:virtualgardens_admin/providers/base_provider.dart';

class SetProizvodProvider extends BaseProvider<ProizvodiSet> {
  SetProizvodProvider() : super("api/ProizvodiSetovi");

  @override
  ProizvodiSet fromJson(data) {
    return ProizvodiSet.fromJson(data);
  }
}
