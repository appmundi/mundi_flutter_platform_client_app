import 'package:mundi_flutter_platform_client_app/app/models/address.dart';

abstract class ICepLookupRepository {
  /// Busca cidade/UF/rua/bairro a partir do CEP (ViaCEP com fallback
  /// BrasilAPI v2). Retorna null só quando o CEP realmente não existe
  /// (ambos os provedores falham). Quando o CEP é genérico (sem logradouro
  /// próprio — comum em cidades pequenas), volta com `street` vazio e
  /// `isGeneric = true`: a tela deixa rua e bairro editáveis e obrigatórios.
  Future<Address?> lookupCep({required String cep});
}
