import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mundi_flutter_platform_client_app/app/models/address.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/cep_lookup/i_cep_lookup_repository.dart';

class CepLookupRepository implements ICepLookupRepository {
  static const _requestTimeout = Duration(seconds: 10);

  @override
  Future<Address?> lookupCep({required String cep}) async {
    final cleanedCep = cep.replaceAll(RegExp(r'\D'), '');
    print('[CepLookupRepository] lookupCep: cep=$cleanedCep');

    final viaCep = await _fetchFromViaCep(cleanedCep);

    var street = (viaCep?['logradouro'] ?? '').toString().trim();
    var neighborhood = (viaCep?['bairro'] ?? '').toString().trim();
    var city = (viaCep?['localidade'] ?? '').toString().trim();
    var state = (viaCep?['uf'] ?? '').toString().trim();
    var zipCode = (viaCep?['cep'] ?? '').toString().trim();

    // Logradouro vazio: ou o ViaCEP não conhece o CEP, ou conhece mas é um
    // CEP genérico (cidade/bairro inteiro sob um único CEP). Nos dois casos
    // a BrasilAPI v2 pode resolver cidade/UF mesmo sem rua.
    if (street.isEmpty) {
      print('[CepLookupRepository] Logradouro vazio → tentando BrasilAPI v2');
      final brasilApi = await _fetchFromBrasilApi(cleanedCep);
      if (viaCep == null && brasilApi == null) {
        print('[CepLookupRepository] CEP não encontrado em nenhum provedor');
        return null;
      }
      if (brasilApi != null) {
        final brasilApiStreet = (brasilApi['street'] ?? '').toString().trim();
        if (brasilApiStreet.isNotEmpty) street = brasilApiStreet;
        if (neighborhood.isEmpty) {
          neighborhood = (brasilApi['neighborhood'] ?? '').toString().trim();
        }
        if (city.isEmpty) city = (brasilApi['city'] ?? '').toString().trim();
        if (state.isEmpty) {
          state = (brasilApi['state'] ?? '').toString().trim();
        }
      }
    }

    if (city.isEmpty || state.isEmpty) {
      print('[CepLookupRepository] FALHA: cidade/UF vazios após os 2 provedores');
      return null;
    }

    // Com {"erro":"true"} o ViaCEP não devolve o campo cep: usa o digitado.
    if (zipCode.isEmpty) zipCode = _formatCep(cleanedCep);

    print(
      '[CepLookupRepository] resultado: rua="$street" bairro="$neighborhood" '
      '$city/$state isGeneric=${street.isEmpty}',
    );

    return Address(
      zipCode: zipCode,
      street: street,
      neighborhood: neighborhood.isEmpty ? null : neighborhood,
      city: city,
      state: state,
      isGeneric: street.isEmpty,
    );
  }

  Future<Map<String, dynamic>?> _fetchFromViaCep(String cleanedCep) async {
    try {
      final uri = Uri.parse('https://viacep.com.br/ws/$cleanedCep/json/');
      final response = await http.get(uri).timeout(_requestTimeout);
      if (response.statusCode != 200) return null;
      final data = jsonDecode(response.body);
      if (data is! Map<String, dynamic>) return null;
      // ViaCEP sinaliza CEP desconhecido com {"erro": "true"} — STRING, não bool.
      if (data['erro'] == true || data['erro'] == 'true') return null;
      return data;
    } catch (e) {
      print('[CepLookupRepository] ViaCEP: erro $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> _fetchFromBrasilApi(String cleanedCep) async {
    try {
      final uri =
          Uri.parse('https://brasilapi.com.br/api/cep/v2/$cleanedCep');
      final response = await http.get(uri).timeout(_requestTimeout);
      if (response.statusCode != 200) return null;
      final data = jsonDecode(response.body);
      if (data is! Map<String, dynamic>) return null;
      return data;
    } catch (e) {
      print('[CepLookupRepository] BrasilAPI: erro $e');
      return null;
    }
  }

  String _formatCep(String cleanedCep) {
    if (cleanedCep.length != 8) return cleanedCep;
    return '${cleanedCep.substring(0, 5)}-${cleanedCep.substring(5)}';
  }
}
