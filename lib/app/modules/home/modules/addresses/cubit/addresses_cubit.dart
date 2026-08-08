import 'package:bloc/bloc.dart';
import 'package:mundi_flutter_platform_client_app/app/models/address.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/user_address/i_user_address_repository.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/addresses/cubit/addresses_state.dart';

class AddressesCubit extends Cubit<AddressesState> {
  final IUserAddressRepository userAddressRepository;

  AddressesCubit({required this.userAddressRepository})
      : super(const AddressesState.initial());

  Future<void> load() async {
    emit(state.copyWith(status: AddressesStatus.loading));
    try {
      final addresses = await userAddressRepository.list();
      emit(state.copyWith(
        status: AddressesStatus.loaded,
        addresses: addresses,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AddressesStatus.error,
        addresses: state.addresses,
        errorMessage: _messageOf(e, 'Erro ao carregar seus endereços'),
      ));
    }
  }

  /// Retorna o endereço criado (com id) em caso de sucesso, ou null se falhar
  /// — a página decide o que fazer (a mensagem de erro já foi emitida aqui).
  Future<Address?> create(Address address) async {
    try {
      final created = await userAddressRepository.create(address);
      emit(state.copyWith(
        status: AddressesStatus.loaded,
        addresses: [created, ...state.addresses],
      ));
      return created;
    } catch (e) {
      emit(state.copyWith(
        status: AddressesStatus.error,
        addresses: state.addresses,
        errorMessage: _messageOf(e, 'Erro ao salvar o endereço'),
      ));
      return null;
    }
  }

  Future<bool> delete(int id) async {
    try {
      await userAddressRepository.delete(id);
      emit(state.copyWith(
        status: AddressesStatus.loaded,
        addresses: state.addresses.where((a) => a.id != id).toList(),
      ));
      return true;
    } catch (e) {
      emit(state.copyWith(
        status: AddressesStatus.error,
        addresses: state.addresses,
        errorMessage: _messageOf(e, 'Erro ao excluir o endereço'),
      ));
      return false;
    }
  }

  String _messageOf(Object error, String fallback) {
    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }
    return fallback;
  }
}
