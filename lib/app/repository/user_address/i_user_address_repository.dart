import 'package:mundi_flutter_platform_client_app/app/models/address.dart';

abstract class IUserAddressRepository {
  /// Endereços salvos do usuário autenticado, mais recente primeiro.
  Future<List<Address>> list();

  /// Cria um endereço salvo; retorna com `id` preenchido pela API.
  Future<Address> create(Address address);

  Future<void> delete(int id);
}
