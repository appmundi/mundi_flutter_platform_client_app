import 'package:bloc/bloc.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/entrepreneur/cubit/entrepreneur_state.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/entrepeneur/i_entrepreneur_repository.dart';

class EntrepreneurCubit extends Cubit<EntrepreneurState> {
  final IEntrepreneurRepository repository;

  EntrepreneurCubit({
    required this.repository,
  }) : super(const EntrepreneurState.initial());

  Future<void> loadData(int entrepreneurId) async {
    emit(
      state.copyWith(
        status: EntrepreneurStateStatus.loading,
      ),
    );
    try {
      final entrepreneur = await repository.search(entrepreneurId);
      emit(state.copyWith(
        status: EntrepreneurStateStatus.loaded,
        entrepreneur: entrepreneur,
      ));
    } catch (e) {
      print(e);
      print(e.runtimeType);
      emit(
        state.copyWith(
          status: EntrepreneurStateStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
