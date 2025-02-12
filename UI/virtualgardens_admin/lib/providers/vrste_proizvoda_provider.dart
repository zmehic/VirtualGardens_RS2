import 'package:virtualgardens_admin/models/vrsta_proizvoda.dart';
import 'package:virtualgardens_admin/providers/helper_providers/base_provider.dart';

class VrsteProizvodaProvider extends BaseProvider<VrstaProizvoda> {
  VrsteProizvodaProvider() : super("api/VrsteProizvoda");

  @override
  VrstaProizvoda fromJson(data) {
    return VrstaProizvoda.fromJson(data);
  }
}
