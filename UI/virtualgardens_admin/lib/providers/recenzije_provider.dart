import 'package:virtualgardens_admin/models/recenzija.dart';
import 'package:virtualgardens_admin/providers/base_provider.dart';

class RecenzijeProvider extends BaseProvider<Recenzija> {
  RecenzijeProvider() : super("api/Recenzije");

  @override
  Recenzija fromJson(data) {
    return Recenzija.fromJson(data);
  }
}
