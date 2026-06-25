part of 'notification_settings_cubit.dart';

class NotificationSettingsState extends Equatable {
  final bool marketingEnabled;

  const NotificationSettingsState({required this.marketingEnabled});

  NotificationSettingsState copyWith({bool? marketingEnabled}) {
    return NotificationSettingsState(
      marketingEnabled: marketingEnabled ?? this.marketingEnabled,
    );
  }

  @override
  List<Object?> get props => [marketingEnabled];
}
