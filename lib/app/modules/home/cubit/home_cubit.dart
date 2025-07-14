import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mundi_flutter_platform_client_app/app/core/exception/connection_exception.dart';
import 'package:mundi_flutter_platform_client_app/app/models/entrepreneur.dart';
import 'package:mundi_flutter_platform_client_app/app/models/messages.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/cubit/home_state.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/entrepreneur/cubit/entrepreneur_state.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/entrepeneur/i_entrepreneur_repository.dart';

import '../../../core/helpers/firebase_api.dart';
import '../../../models/chats.dart';
import '../../../repository/schedule/i_schedule_repository.dart';

class HomeCubit extends Cubit<HomeState> {
  final IEntrepreneurRepository repository;
  final IScheduleRepository schedulesRepository;
  FirebaseApi firebaseApi = FirebaseApi();

  HomeCubit({required this.repository, required this.schedulesRepository})
      : super(const HomeState.initial());

  Future<void> loadData() async {
    emit(
      state.copyWith(
        status: HomeStateStatus.loading,
      ),
    );
    try {
      final entrepreneurs = await repository.searchAll();

      emit(
        state.copyWith(
          status: HomeStateStatus.loaded,
          entrepreneurs: entrepreneurs,
        ),
      );
    } on ConnectionException {
      emit(
        state.copyWith(
          status: HomeStateStatus.error,
        ),
      );
    }
  }

  Future<void> applyFilter(String filterText) async {
    print('apply');
    try {
      emit(state.copyWith(status: HomeStateStatus.loading));

      final filteredEntrepreneurs = await repository.searchAll(filterText);

      emit(state.copyWith(filteredEntrepreneurs: filteredEntrepreneurs, status: HomeStateStatus.loaded));
    } catch (e) {
      state.copyWith(filteredEntrepreneurs: state.entrepreneurs);
    }
  }

  Future<void> applyFilterCategory(String filterText) async {
    print('apply');
    try {
      emit(state.copyWith(status: HomeStateStatus.loading));

      final newList = state.entrepreneurs!.where((Entrepreneur element) {
        return element.address.toLowerCase().contains(filterText.toString().toLowerCase());
        log("Categoria > ${element}");
        //return element.category.toLowerCase().contains(filterText.toString().toLowerCase());
      }).toList();

      print("Nova Lista > ${newList}");

      emit(state.copyWith(filteredCategoryEntrepreneurs: newList, status: HomeStateStatus.loaded));
    } catch (e) {
      state.copyWith(filteredCategoryEntrepreneurs: state.entrepreneurs);
    }
  }
}
