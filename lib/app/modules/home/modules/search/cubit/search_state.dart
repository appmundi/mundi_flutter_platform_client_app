import 'package:equatable/equatable.dart';

// ignore: depend_on_referenced_packages
import 'package:match/match.dart';
import 'package:mundi_flutter_platform_client_app/app/models/entrepreneur.dart';
import 'package:mundi_flutter_platform_client_app/app/repository/entrepeneur/entrepreneur_search_result.dart';

part 'search_state.g.dart';

@match
enum SearchStateStatus { initial, loading, error, loaded }

class SearchState extends Equatable {
  final SearchStateStatus status;
  final String? errorMessage;
  final List<Entrepreneur>? entrepreneurs;
  final AppliedGeoFilter appliedFilter;
  final String? clientUf;

  const SearchState({
    required this.status,
    this.entrepreneurs,
    this.errorMessage,
    this.appliedFilter = AppliedGeoFilter.none,
    this.clientUf,
  });

  const SearchState.initial()
    : status = SearchStateStatus.initial,
      entrepreneurs = null,
      errorMessage = null,
      appliedFilter = AppliedGeoFilter.none,
      clientUf = null;

  @override
  List<Object?> get props =>
      [status, entrepreneurs, errorMessage, appliedFilter, clientUf];

  SearchState copyWith({
    SearchStateStatus? status,
    String? errorMessage,
    List<Entrepreneur>? entrepreneurs,
    AppliedGeoFilter? appliedFilter,
    String? clientUf,
  }) {
    return SearchState(
      status: status ?? this.status,
      entrepreneurs: entrepreneurs ?? this.entrepreneurs,
      errorMessage: errorMessage ?? this.errorMessage,
      appliedFilter: appliedFilter ?? this.appliedFilter,
      clientUf: clientUf ?? this.clientUf,
    );
  }
}
