// ignore: depend_on_referenced_packages
import 'package:equatable/equatable.dart';
// ignore: depend_on_referenced_packages
import 'package:match/match.dart';

part 'reserve_state.g.dart';

@match
enum ReserveStatus { init, loading, loaded, success, error }

class ReserveState extends Equatable {
  final ReserveStatus status;
  final String? errorMessage;
  final List<String>? checkHour;

  const ReserveState({required this.status, this.errorMessage,required this.checkHour});

  const ReserveState.initial()
      : status = ReserveStatus.init,
        errorMessage = null,
        checkHour = null;

  @override
  List<Object?> get props => [status, errorMessage, checkHour];

  ReserveState copyWith({ReserveStatus? status, String? errorMessage, List<String>? checkHour}) {
    return ReserveState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        checkHour: checkHour ?? this.checkHour);
  }
}
