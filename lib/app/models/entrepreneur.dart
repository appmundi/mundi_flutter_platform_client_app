import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:mundi_flutter_platform_client_app/app/core/ui/extension/string_extension.dart';
import 'package:mundi_flutter_platform_client_app/app/models/work.dart';

class Entrepreneur {
  final int id;
  final String name;
  /// Nome fantasia / empresa (API: companyName).
  final String companyName;
  final int numberOfAvaliations;
  final int discountPercentage;
  final String address;
  final int addressNumber;
  final String cnpj;
  final String cep;
  final String city;
  final String state;
  final String phone;
  final String email;
  final List<Work> works;
  final List<Operation> operation;
  List<Rating>? ratings;
  double? distance;
  final Uint8List? profileImage;
  final List<int>? imagesID;
  final bool optionwork;
  final List<Category> category;
  final double longitude;
  final double latitude;
  final String? description;

  Entrepreneur({
    required this.id,
    required this.name,
    this.companyName = '',
    required this.address,
    required this.addressNumber,
    required this.city,
    required this.cnpj,
    required this.cep,
    required this.discountPercentage,
    required this.numberOfAvaliations,
    required this.state,
    required this.works,
    required this.email,
    required this.phone,
    required this.operation,
    required this.latitude,
    required this.longitude,
    this.ratings,
    this.distance,
    this.profileImage,
    this.imagesID,
    this.optionwork = false,
    required this.category,
    this.description,
  });

  /// Nome exibido ao cliente: empresa, se existir; senão o nome do responsável.
  String get displayName {
    final c = companyName.trim();
    return c.isNotEmpty ? c : name;
  }

  String get fullAddress {
    final stateFmt = state.replaceAll('State of', '').trim();
    final cepFmt = cep.trim();
    final parts = <String>[
      '$address, $addressNumber',
      '$city - $stateFmt',
    ];
    // `cep` já vem só como 8 dígitos formatados (00000-000); evita repetir texto de endereço.
    if (cepFmt.isNotEmpty) {
      parts.add('CEP $cepFmt');
    }
    return parts.join('\n');
  }

  /// Extrai só a sequência numérica do CEP (8 dígitos). Ignora texto que não seja CEP.
  static String _normalizeCepFromMap(Map<String, dynamic> map) {
    const keys = ['cep', 'zipCode', 'zip', 'postalCode'];
    for (final key in keys) {
      final raw = map[key];
      if (raw == null) continue;
      final digits = raw.toString().replaceAll(RegExp(r'\D'), '');
      if (digits.length == 8) {
        return '${digits.substring(0, 5)}-${digits.substring(5)}';
      }
    }
    return '';
  }

  static Uint8List? _decodeProfileImage(dynamic profileImageData) {
    if (profileImageData == null) return null;
    
    final profileImageString = profileImageData as String?;
    if (profileImageString == null || profileImageString.isEmpty) {
      return null;
    }
    
    try {
      return profileImageString.bytesFromBase64;
    } catch (e) {
      print('Erro ao decodificar profileImage: $e');
      return null;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'companyName': companyName,
      'numberOfAvaliations': numberOfAvaliations,
      'discountPercentage': discountPercentage,
      'address': address,
      'addressNumber': addressNumber,
      'cnpj': cnpj,
      'city': city,
      'state': state,
      'phone': phone,
      'email': email,
      'works': works.map((x) => x.toMap()).toList(),
      //'ratings': ratings?.map((x) => x?.toMap())?.toList(),
      'distance': distance,
      'category': category,
    };
  }

  factory Entrepreneur.fromMap(Map<String, dynamic> map) {
    return Entrepreneur(
      cep: _normalizeCepFromMap(map),
      id: map['entrepreneurId']?.toInt() ?? 0,
      name: map['name']?.toString() ?? '',
      companyName: map['companyName']?.toString() ?? '',
      numberOfAvaliations: map['numberOfAvaliations']?.toInt() ?? 0,
      discountPercentage: map['discountPercentage']?.toInt() ?? 0,
      address: map['address'] ?? '',
      addressNumber: int.tryParse(map['addressNumber']?.toString() ?? '') ?? 0,
      // API expõe CPF em `doc` ou `document` — não usar como CEP no endereço.
      cnpj: map['doc']?.toString() ?? map['document']?.toString() ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      operation: (() {
        final operationData = map['operation'];

        if (operationData == null) {
          return <Operation>[];
        }

        if (operationData is String) {
          return List<Operation>.from(
            (json.decode(operationData) as List)
                .map((x) => Operation.fromMap(x)),
          );
        }

        if (operationData is List) {
          return List<Operation>.from(
            operationData.map((x) => Operation.fromMap(x)),
          );
        }

        return <Operation>[];
      })(),
      works: List<Work>.from(
        map['works']?.map((x) => Work.fromMap(x)) ?? const [],
      ),
      ratings:
          map['avaliation'] != null
              ? List<Rating>.from(
                map['avaliation']?.map((x) => Rating.fromMap(x)),
              )
              : null,
      distance: double.tryParse(map['distance']?.toString() ?? '') ?? 0.0,
      latitude: (map['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 0.0,
      profileImage: _decodeProfileImage(map['profileImage']),
      imagesID:
          ((map['images'] as List?) ?? []).map((item) => item as int).toList(),
      optionwork:
          map['optionwork'] != null
              ? map['optionwork'] is int
                  ? map['optionwork'] == 1
                  : map['optionwork']
              : false,
      category:
          map['category'] == null
              ? []
              : map['category']
                  .map<Category>((x) => Category.fromMap(x))
                  .toList(),
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Entrepreneur.fromJson(String source) =>
      Entrepreneur.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Entrepreneur{id: $id, name: $name, numberOfAvaliations: $numberOfAvaliations, discountPercentage: $discountPercentage, address: $address, addressNumber: $addressNumber, cnpj: $cnpj, cep: $cep, city: $city, state: $state, phone: $phone, email: $email, works: $works, operation: $operation, ratings: $ratings, distance: $distance}';
  }
}

class Operation {
  String day;
  bool isActive;
  String openinHours;
  String closingTime;

  Operation({
    required this.day,
    this.isActive = false,
    this.openinHours = "9:00",
    this.closingTime = "18:00",
  });

  factory Operation.fromMap(dynamic data) {
    return Operation(
      day: data['day'],
      closingTime: data['closingTime'],
      isActive: data['isActive'],
      openinHours: data['openinHours'],
    );
  }

  @override
  String toString() {
    return 'Operation{day: $day, isActive: $isActive, openinHours: $openinHours, closingTime: $closingTime}';
  }
}

class Category {
  int id;
  String type;

  Category({required this.id, this.type = "Barbearia"});

  factory Category.fromMap(Map<String, dynamic> data) {
    return Category(
      id: data['id'] is int ? data['id'] as int : int.tryParse(data['id']?.toString() ?? '0') ?? 0,
      type: data['type']?.toString() ?? 'Barbearia',
    );
  }

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source));
}

class Rating {
  int id;
  double rating;
  String comment;
  String name;

  Rating({
    required this.comment,
    required this.id,
    required this.rating,
    required this.name,
  });

  factory Rating.fromMap(Map<String, dynamic> map) {
    return Rating(
      comment: map['comment'],
      id: map['id'],
      rating: double.parse(map['rating'].toString()),
      name: map['name'],
    );
  }
}
