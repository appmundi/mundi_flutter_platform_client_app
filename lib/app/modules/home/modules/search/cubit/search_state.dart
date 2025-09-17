import 'package:equatable/equatable.dart';

// ignore: depend_on_referenced_packages
import 'package:match/match.dart';
import 'package:mundi_flutter_platform_client_app/app/models/entrepreneur.dart';

part 'search_state.g.dart';

@match
enum SearchStateStatus { initial, loading, error, loaded }

class SearchState extends Equatable {
  final SearchStateStatus status;
  final String? errorMessage;
  final List<Entrepreneur>? entrepreneurs;

  const SearchState({
    required this.status,
    this.entrepreneurs,
    this.errorMessage,
  });

  const SearchState.initial()
    : status = SearchStateStatus.initial,
      entrepreneurs = null,
      errorMessage = null;

  @override
  List<Object?> get props => [status, entrepreneurs, errorMessage];

  SearchState copyWith({
    SearchStateStatus? status,
    String? errorMessage,
    List<Entrepreneur>? entrepreneurs,
  }) {
    return SearchState(
      status: status ?? this.status,
      entrepreneurs: entrepreneurs ?? this.entrepreneurs,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
