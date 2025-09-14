import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:mundi_flutter_platform_client_app/app/core/exception/connection_exception.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/search/cubit/search_state.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/entrepeneur/i_entrepreneur_repository.dart';

class SearchCubit extends Cubit<SearchState> {
  final IEntrepreneurRepository repository;

  SearchCubit({required this.repository}) : super(const SearchState.initial());

  Future<void> loadData() async {
    emit(state.copyWith(status: SearchStateStatus.loading));
    try {
      final entrepreneurs = await repository.searchAll();

      emit(
        state.copyWith(
          status: SearchStateStatus.loaded,
          entrepreneurs: entrepreneurs,
        ),
      );
    } on ConnectionException {
      emit(state.copyWith(status: SearchStateStatus.error));
    }
  }

  Future<void> applyFilter(String filterText) async {
    try {
      emit(state.copyWith(status: SearchStateStatus.loading));

      final filteredEntrepreneurs = await repository.searchAll(filterText);

      emit(
        state.copyWith(
          entrepreneurs: filteredEntrepreneurs,
          status: SearchStateStatus.loaded,
        ),
      );
    } catch (e) {
      state.copyWith(entrepreneurs: state.entrepreneurs);
    }
  }
}
