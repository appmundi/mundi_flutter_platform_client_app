class Address {
  int? id; // null até ser salvo via POST /user/address
  String? label; // "Casa", "Trabalho"... só relevante para endereços salvos
  String zipCode;
  String street;
  String? neighborhood;
  String city;
  String state;
  String number; // '' até o usuário digitar — preenchido depois da busca de CEP
  String? complement;

  /// CEP sem logradouro próprio (cidade/bairro inteiro sob um único CEP).
  /// Transiente — nunca enviado à API, só orienta o formulário a deixar a
  /// rua editável.
  bool isGeneric;

  Address({
    this.id,
    this.label,
    required this.zipCode,
    required this.street,
    this.neighborhood,
    required this.city,
    required this.state,
    this.number = '',
    this.complement,
    this.isGeneric = false,
  });

  /// Campos que `Schedule.address` aceita no POST /scheduling/schedule.
  /// Sem id/label — o backend não tem onde guardá-los na reserva.
  Map<String, dynamic> toReservationPayload() {
    return {
      'zipCode': zipCode,
      'street': street,
      'neighborhood': neighborhood,
      'city': city,
      'state': state,
      'number': number,
      'complement': complement,
    };
  }

  /// Corpo de POST /user/address — inclui label, nunca id (gerado pela API).
  Map<String, dynamic> toCreateDto() {
    return {
      'label': label,
      'zipCode': zipCode,
      'street': street,
      'neighborhood': neighborhood,
      'city': city,
      'state': state,
      'number': number,
      'complement': complement,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'] as int?,
      label: map['label'] as String?,
      zipCode: map['zipCode']?.toString() ?? '',
      street: map['street']?.toString() ?? '',
      neighborhood: map['neighborhood'] as String?,
      city: map['city']?.toString() ?? '',
      state: map['state']?.toString() ?? '',
      number: map['number']?.toString() ?? '',
      complement: map['complement'] as String?,
    );
  }

  @override
  String toString() =>
      'Address(id: $id, label: $label, zipCode: $zipCode, street: $street, '
      'neighborhood: $neighborhood, city: $city, state: $state, '
      'number: $number, complement: $complement)';
}
