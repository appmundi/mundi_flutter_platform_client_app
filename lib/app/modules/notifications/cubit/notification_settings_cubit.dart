import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app/core/notifications/notification_service.dart';

part 'notification_settings_state.dart';

class NotificationSettingsCubit
    extends Cubit<NotificationSettingsState> {
  NotificationSettingsCubit()
      : super(const NotificationSettingsState(marketingEnabled: true));

  Future<void> load() async {
    final sp = await SharedPreferences.getInstance();
    final marketing = sp.getBool('_notif_marketing') ?? true;
    emit(state.copyWith(marketingEnabled: marketing));
  }

  Future<void> toggleMarketing(bool enabled) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool('_notif_marketing', enabled);

    if (enabled) {
      await NotificationService.instance.subscribeToTopic('marketing_general');
    } else {
      await NotificationService.instance
          .unsubscribeFromTopic('marketing_general');
    }

    emit(state.copyWith(marketingEnabled: enabled));
  }
}
