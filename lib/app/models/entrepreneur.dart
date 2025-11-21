import 'dart:convert';
import 'dart:typed_data';

import 'package:mundi_flutter_platform_client_app/app/core/ui/extension/string_extension.dart';
import 'package:mundi_flutter_platform_client_app/app/models/work.dart';

class Entrepreneur {
  final int id;
  final String name;
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

  Entrepreneur({
    required this.id,
    required this.name,
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
  });

  String get fullAddress =>
      "$address, $addressNumber,\n$city - ${state.replaceAll('State of', '')}, $cnpj";

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
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
      cep: map['cep'],
      id: map['entrepreneurId']?.toInt() ?? 0,
      name: map['name'] ?? '',
      numberOfAvaliations: map['numberOfAvaliations']?.toInt() ?? 0,
      discountPercentage: map['discountPercentage']?.toInt() ?? 0,
      address: map['address'] ?? '',
      addressNumber: int.parse(map['addressNumber']),
      cnpj: map['doc'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      operation: List<Operation>.from(
        json.decode(map['operation'])?.map((x) => Operation.fromMap(x)) ??
            const [],
      ),
      works: List<Work>.from(
        map['works']?.map((x) => Work.fromMap(x)) ?? const [],
      ),
      ratings:
          map['avaliation'] != null
              ? List<Rating>.from(
                map['avaliation']?.map((x) => Rating.fromMap(x)),
              )
              : null,
      distance: double.parse(map['distance'] ?? "0.0"),
      latitude: map['latitude'].toDouble() ?? 0.0,
      longitude: map['longitude'].toDouble() ?? 0.0,
      profileImage: (map['profileImage'] as String?)?.bytesFromBase64,
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

  factory Operation.fromMap(Map<String, dynamic> data) {
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
    return Category(id: data['id'], type: data['type']);
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
