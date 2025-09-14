import 'dart:convert';

class User {
  String name;
  String email;
  String password;
  String doc;
  String phone;
  String address;
  String addressNumber;
  String cep;
  String city;
  String state;
  String imageUrl;
  User({
    this.name = '',
    this.email = '',
    this.password = '',
    this.doc = '',
    this.phone = '',
    this.address = '',
    this.addressNumber = '',
    this.cep = '',
    this.city = '',
    this.state = '',
    this.imageUrl = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'doc': doc.replaceAll(".", "").replaceAll("-", ""),
      'phone': phone
          .replaceAll("(", "")
          .replaceAll(")", "")
          .replaceAll(" ", "")
          .replaceAll("-", ""),
      'address': address,
      'addressNumber': addressNumber,
      'cep': cep,
      'city': city,
      'state': state,
      'imageUrl': imageUrl,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      doc: map['doc'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      addressNumber: map['addressNumber'] ?? '',
      cep: map['cep'],
      city: map['city'],
      state: map['state'],
      imageUrl: map['imageUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User{name: $name, email: $email, password: $password, doc: $doc, phone: $phone, address: $address, addressNumber: $addressNumber, cep: $cep, city: $city, state: $state, image: $imageUrl}';
  }
}
