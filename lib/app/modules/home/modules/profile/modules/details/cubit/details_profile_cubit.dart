import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/profile/modules/details/cubit/details_profile_state.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/auth/i_auth_repository.dart';

class DetailProfileCubit extends Cubit<DetailProfileState> {
  final IAuthRepository authRepository;

  DetailProfileCubit({required this.authRepository})
      : super(const DetailProfileState.initial());

  void setToInit() {
    emit(state.copyWith(status: DetailsProfileStatus.init));
  }

  Future<void> findOneById(int userId) async {
    try {
      emit(state.copyWith(status: DetailsProfileStatus.loading));

      final user = await authRepository.findOneById(userId);

      print("Usuario > ${user.toString()}");

      emit(state.copyWith(user: user, status: DetailsProfileStatus.success));
    } catch (e) {
      print("Error > ${e}");
    }
  }

  Future<void> updateUser(int userId, String name, String email, String phone, File? image) async {
    try {
      emit(state.copyWith(status: DetailsProfileStatus.loading));

      await authRepository.updateUser(userId, name, email, phone);
      if(image != null) {
        await updateImage(userId, image);
      }

      emit(state.copyWith(status: DetailsProfileStatus.updated));
    } catch (e) {
      print("Error > ${e}");
    }
  }

  Future<void> updateImage(int userId, File image) async {
    emit(state.copyWith(status: DetailsProfileStatus.loading));
    try {
      await authRepository.updateImage(userId, image);

      emit(state.copyWith(status: DetailsProfileStatus.success));
    } catch(e) {
      print(e);
      emit(state.copyWith(status: DetailsProfileStatus.error, errorMessage: 'Erro ao atualizar imagem'));
    }
  }

  Future<void> deleteImage(int userId) async {
    emit(state.copyWith(status: DetailsProfileStatus.loading));
    try {
      await authRepository.deleteImage(userId);

      emit(state.copyWith(status: DetailsProfileStatus.success));
    } catch(e) {
      print(e);
      emit(state.copyWith(status: DetailsProfileStatus.error, errorMessage: 'Erro ao atualizar imagem'));
    }
  }
}
