import 'package:bloc/bloc.dart';
import 'package:mundi_flutter_platform_client_app/app/core/exception/connection_exception.dart';
import 'package:mundi_flutter_platform_client_app/app/models/entrepreneur.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/home/cubit/home_state.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/entrepeneur/i_entrepreneur_repository.dart';

import '../../../repository/schedule/i_schedule_repository.dart';

class HomeCubit extends Cubit<HomeState> {
  final IEntrepreneurRepository repository;
  final IScheduleRepository schedulesRepository;

  HomeCubit({required this.repository, required this.schedulesRepository})
      : super(const HomeState.initial());

  Future<void> loadData() async {
    emit(state.copyWith(status: HomeStateStatus.loading));
    try {
      final all = await repository.searchAll();
      final entrepreneurs = all ?? [];

      emit(state.copyWith(
        status: HomeStateStatus.loaded,
        entrepreneurs: entrepreneurs,
        specialOffers: _computeSpecialOffers(entrepreneurs),
        recommended: _computeRecommended(entrepreneurs),
        availableToday: _computeAvailableToday(entrepreneurs),
      ));
    } on ConnectionException {
      emit(state.copyWith(status: HomeStateStatus.error));
    }
  }

  Future<void> applyFilter(String filterText) async {
    try {
      emit(state.copyWith(status: HomeStateStatus.loading));
      final filteredEntrepreneurs = await repository.searchAll(filterText);
      emit(state.copyWith(
          filteredEntrepreneurs: filteredEntrepreneurs,
          status: HomeStateStatus.loaded));
    } catch (e) {
      state.copyWith(filteredEntrepreneurs: state.entrepreneurs);
    }
  }

  List<Entrepreneur> _computeSpecialOffers(List<Entrepreneur> all) {
    final withDiscount = all
        .where((e) => e.discountPercentage > 0)
        .toList()
      ..sort((a, b) => b.discountPercentage.compareTo(a.discountPercentage));
    if (withDiscount.isNotEmpty) return withDiscount;
    return _computeRecommended(all).take(10).toList();
  }

  List<Entrepreneur> _computeRecommended(List<Entrepreneur> all) {
    double avgRating(Entrepreneur e) {
      final ratings = e.ratings;
      if (ratings == null || ratings.isEmpty) return 0;
      return ratings.map((r) => r.rating).reduce((a, b) => a + b) /
          ratings.length;
    }

    return [...all]..sort((a, b) {
        final diff = avgRating(b).compareTo(avgRating(a));
        if (diff != 0) return diff;
        return b.numberOfAvaliations.compareTo(a.numberOfAvaliations);
      });
  }

  List<Entrepreneur> _computeAvailableToday(List<Entrepreneur> all) {
    const weekdays = [
      'domingo',
      'segunda-feira',
      'terça-feira',
      'quarta-feira',
      'quinta-feira',
      'sexta-feira',
      'sábado'
    ];
    final now = DateTime.now();
    // Dart weekday: Mon=1 .. Sun=7; our list: Sun=0 .. Sat=6
    final todayName = weekdays[now.weekday % 7];
    final nowMinutes = now.hour * 60 + now.minute;

    return all.where((e) {
      try {
        return e.operation.any((op) {
          if (op.day.trim().toLowerCase() != todayName || !op.isActive) {
            return false;
          }
          final parts = op.closingTime.split(':');
          if (parts.length < 2) return false;
          final closingMinutes =
              int.parse(parts[0]) * 60 + int.parse(parts[1]);
          return closingMinutes > nowMinutes + 60;
        });
      } catch (_) {
        return false;
      }
    }).toList();
  }
}
