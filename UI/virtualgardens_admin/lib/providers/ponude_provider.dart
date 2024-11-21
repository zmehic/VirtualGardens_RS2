import 'package:virtualgardens_admin/models/ponuda.dart';
import 'package:virtualgardens_admin/providers/base_provider.dart';

class PonudeProvider extends BaseProvider<Ponuda> {
  PonudeProvider() : super("api/Ponude");

  @override
  Ponuda fromJson(data) {
    return Ponuda.fromJson(data);
  }
}
