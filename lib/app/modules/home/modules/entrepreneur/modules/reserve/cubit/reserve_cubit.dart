import 'package:bloc/bloc.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/modules/entrepreneur/modules/reserve/cubit/reserve_state.dart';

import '../../../../../../../repository/reserve/i_reserve_repository.dart';

class ReserveCubit extends Cubit<ReserveState> {
  final IReserveRepository reserveRepository;

  ReserveCubit({required this.reserveRepository})
    : super(const ReserveState.initial());

  Future<void> createReserve({
    required int entrepreneurId,
    required String scheduledDate,
    required List<int> modalityIds,
    required String description,
  }) async {
    try {
      emit(state.copyWith(status: ReserveStatus.loading));
      print("Data e hr > ${scheduledDate}");
      await reserveRepository.createReserve(
        entrepreneurId: entrepreneurId,
        scheduledDate: scheduledDate,
        modalityIds: modalityIds,
        description: description,
      );

      emit(state.copyWith(status: ReserveStatus.success));
    } catch(e) {
      emit(
        state.copyWith(
          status: ReserveStatus.error,
          errorMessage: 'Erro ao realizar reserva',
        ),
      );
    }
  }

  Future<void> checkHour({
    required int entrepreneurId,
    required String date,
    int? duration,
  }) async {
    try {
      emit(state.copyWith(status: ReserveStatus.loading));
      List<String> res = await reserveRepository.checkHour(
        entrepreneurId: entrepreneurId,
        date: date,
        duration: duration,
      );

      emit(state.copyWith(status: ReserveStatus.loaded, checkHour: res));
    } catch (e) {
      print("Error check $e");
    }
  }
}
