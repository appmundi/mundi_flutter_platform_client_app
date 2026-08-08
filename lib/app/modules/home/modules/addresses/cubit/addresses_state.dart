import 'package:equatable/equatable.dart';
import 'package:mundi_flutter_platform_client_app/app/models/address.dart';

enum AddressesStatus { initial, loading, loaded, error }

class AddressesState extends Equatable {
  final AddressesStatus status;
  final List<Address> addresses;
  final String? errorMessage;

  const AddressesState({
    required this.status,
    required this.addresses,
    this.errorMessage,
  });

  const AddressesState.initial()
      : status = AddressesStatus.initial,
        addresses = const [],
        errorMessage = null;

  @override
  List<Object?> get props => [status, addresses, errorMessage];

  AddressesState copyWith({
    AddressesStatus? status,
    List<Address>? addresses,
    String? errorMessage,
  }) {
    return AddressesState(
      status: status ?? this.status,
      addresses: addresses ?? this.addresses,
      errorMessage: errorMessage,
    );
  }
}
