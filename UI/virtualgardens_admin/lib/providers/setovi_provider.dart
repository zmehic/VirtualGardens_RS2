import 'package:virtualgardens_admin/models/set.dart';
import 'package:virtualgardens_admin/providers/base_provider.dart';

class SetoviProvider extends BaseProvider<Set> {
  SetoviProvider() : super("api/Setovi");

  @override
  Set fromJson(data) {
    return Set.fromJson(data);
  }
}
