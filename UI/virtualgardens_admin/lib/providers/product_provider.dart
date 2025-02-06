import 'package:virtualgardens_admin/models/proizvod.dart';
import 'package:virtualgardens_admin/providers/helper_providers/base_provider.dart';

class ProductProvider extends BaseProvider<Proizvod> {
  ProductProvider() : super("Proizvodi");

  @override
  Proizvod fromJson(data) {
    return Proizvod.fromJson(data);
  }
}
