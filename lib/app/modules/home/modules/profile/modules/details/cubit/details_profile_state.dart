import 'package:equatable/equatable.dart';
// ignore: depend_on_referenced_packages
import 'package:match/match.dart';
import 'package:mundi_flutter_platform_client_app/app/models/user.dart';


part 'details_profile_state.g.dart';

@match
enum DetailsProfileStatus { init, loading, success, error, updated }

class DetailProfileState extends Equatable {
  final DetailsProfileStatus status;
  final String? errorMessage;
  final User? user;

  const DetailProfileState(
      {required this.status,
        this.errorMessage,
        this.user,});

  @override
  List<Object?> get props => [status, errorMessage, user];

  const DetailProfileState.initial()
      : status = DetailsProfileStatus.init,
        user = null,
        errorMessage = null;

  DetailProfileState copyWith(
      {DetailsProfileStatus? status,
        String? errorMessage,
        User? user}) {
    return DetailProfileState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        user: user ?? this.user);
  }
}
