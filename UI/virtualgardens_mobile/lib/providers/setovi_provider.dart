import 'package:virtualgardens_mobile/models/set.dart';
import 'package:virtualgardens_mobile/providers/helper_providers/base_provider.dart';

class SetoviProvider extends BaseProvider<Set> {
  SetoviProvider() : super("api/Setovi");

  @override
  Set fromJson(data) {
    return Set.fromJson(data);
  }
}
