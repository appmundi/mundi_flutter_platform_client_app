import 'package:mundi_flutter_platform_client_app/app/core/exception/connection_exception.dart';
import 'package:mundi_flutter_platform_client_app/app/core/rest/rest_client.dart';
import 'package:mundi_flutter_platform_client_app/app/models/entrepreneur.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/category/i_category_repository.dart';

class CategoryRepository implements ICategoryRepository {
  final RestClient _rest;

  CategoryRepository({
    required RestClient rest,
  }) : _rest = rest;

  @override
  Future<List<Category>> getAll() async {
    try {
      final response = await _rest.get(
        "/category",
        headers: {
          'Content-Type': 'application/json',
        },
      );

      final categories = (response.data as List)
          .map<Category>((data) => Category.fromMap(data))
          .toList();

      return categories;
    } catch (e) {
      print('Erro ao buscar categorias: $e');
      throw ConnectionException();
    }
  }
}
