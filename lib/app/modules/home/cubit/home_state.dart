import 'package:equatable/equatable.dart';
// ignore: depend_on_referenced_packages
import 'package:match/match.dart';
import 'package:mundi_flutter_platform_client_app/app/models/entrepreneur.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/entrepeneur/entrepreneur_search_result.dart';

import '../../../models/chats.dart';

part 'home_state.g.dart';

@match
enum HomeStateStatus { initial, loading, error, loaded }

@match
enum HomeScheduleStatus { initial, loading, error, loaded }

class HomeState extends Equatable {
  final HomeStateStatus status;
  final String? errorMessage;
  final List<Entrepreneur>? entrepreneurs;
  final List<Chat>? chats;
  final List<Entrepreneur>? specialOffers;
  final List<Entrepreneur>? recommended;
  final List<Entrepreneur>? availableToday;
  final AppliedGeoFilter appliedFilter;
  final String? clientUf;

  const HomeState(
      {required this.status,
      this.entrepreneurs,
      this.errorMessage,
      this.chats,
      this.specialOffers,
      this.recommended,
      this.availableToday,
      this.appliedFilter = AppliedGeoFilter.none,
      this.clientUf});

  const HomeState.initial()
      : status = HomeStateStatus.initial,
        entrepreneurs = null,
        chats = null,
        errorMessage = null,
        specialOffers = null,
        recommended = null,
        availableToday = null,
        appliedFilter = AppliedGeoFilter.none,
        clientUf = null;

  @override
  List<Object?> get props => [
        status,
        entrepreneurs,
        errorMessage,
        chats,
        specialOffers,
        recommended,
        availableToday,
        appliedFilter,
        clientUf,
      ];

  HomeState copyWith(
      {List<Chat>? chats,
      HomeStateStatus? status,
      HomeScheduleStatus? statusSchedule,
      String? errorMessage,
      List<Entrepreneur>? entrepreneurs,
      List<Entrepreneur>? specialOffers,
      List<Entrepreneur>? recommended,
      List<Entrepreneur>? availableToday,
      AppliedGeoFilter? appliedFilter,
      String? clientUf}) {
    return HomeState(
        status: status ?? this.status,
        entrepreneurs: entrepreneurs ?? this.entrepreneurs,
        errorMessage: errorMessage ?? this.errorMessage,
        chats: chats ?? this.chats,
        specialOffers: specialOffers ?? this.specialOffers,
        recommended: recommended ?? this.recommended,
        availableToday: availableToday ?? this.availableToday,
        appliedFilter: appliedFilter ?? this.appliedFilter,
        clientUf: clientUf ?? this.clientUf);
  }
}
