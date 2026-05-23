import 'package:mundi_flutter_platform_client_app/app/models/entrepreneur.dart';

abstract class ICategoryRepository {
  Future<List<Category>> getAll();
}
