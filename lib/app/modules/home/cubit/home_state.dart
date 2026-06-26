import 'package:equatable/equatable.dart';
// ignore: depend_on_referenced_packages
import 'package:match/match.dart';
import 'package:mundi_flutter_platform_client_app/app/models/entrepreneur.dart';

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
  final List<Entrepreneur>? filteredEntrepreneurs;
  final List<Entrepreneur>? filteredCategoryEntrepreneurs;
  final List<Entrepreneur>? specialOffers;
  final List<Entrepreneur>? recommended;
  final List<Entrepreneur>? availableToday;

  const HomeState(
      {required this.status,
      this.entrepreneurs,
      this.errorMessage,
      this.chats,
      this.filteredEntrepreneurs,
      this.filteredCategoryEntrepreneurs,
      this.specialOffers,
      this.recommended,
      this.availableToday});

  const HomeState.initial()
      : status = HomeStateStatus.initial,
        entrepreneurs = null,
        chats = null,
        errorMessage = null,
        filteredEntrepreneurs = null,
        filteredCategoryEntrepreneurs = null,
        specialOffers = null,
        recommended = null,
        availableToday = null;

  @override
  List<Object?> get props => [
        status,
        entrepreneurs,
        errorMessage,
        chats,
        filteredEntrepreneurs,
        filteredCategoryEntrepreneurs,
        specialOffers,
        recommended,
        availableToday,
      ];

  HomeState copyWith(
      {List<Chat>? chats,
      HomeStateStatus? status,
      HomeScheduleStatus? statusSchedule,
      String? errorMessage,
      List<Entrepreneur>? entrepreneurs,
      List<Entrepreneur>? filteredEntrepreneurs,
      List<Entrepreneur>? filteredCategoryEntrepreneurs,
      List<Entrepreneur>? specialOffers,
      List<Entrepreneur>? recommended,
      List<Entrepreneur>? availableToday}) {
    return HomeState(
        status: status ?? this.status,
        entrepreneurs: entrepreneurs ?? this.entrepreneurs,
        errorMessage: errorMessage ?? this.errorMessage,
        chats: chats ?? this.chats,
        filteredEntrepreneurs:
            filteredEntrepreneurs ?? this.filteredEntrepreneurs,
        filteredCategoryEntrepreneurs: filteredCategoryEntrepreneurs ??
            this.filteredCategoryEntrepreneurs,
        specialOffers: specialOffers ?? this.specialOffers,
        recommended: recommended ?? this.recommended,
        availableToday: availableToday ?? this.availableToday);
  }
}
