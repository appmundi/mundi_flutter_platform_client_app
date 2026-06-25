import 'package:flutter_modular/flutter_modular.dart';
import 'package:mundi_flutter_platform_client_app/app/core/notifications/notification_service.dart';
import 'package:mundi_flutter_platform_client_app/app/core/rest/rest_client.dart';
import 'package:mundi_flutter_platform_client_app/app/core/storage/local_storage.dart';

import 'repositories/device_token_repository.dart';
import 'repositories/i_device_token_repository.dart';
import 'use_cases/handle_notification_tap_use_case.dart';
import 'use_cases/register_fcm_token_use_case.dart';
import 'use_cases/render_cancellation_use_case.dart';
import 'use_cases/render_service_step_use_case.dart';
import 'use_cases/schedule_daily_reminder_use_case.dart';
import 'cubit/notification_settings_cubit.dart';

class NotificationsModule extends Module {
  @override
  void binds(Injector i) {
    i.addLazySingleton<IDeviceTokenRepository>(
      () => DeviceTokenRepository(
        rest: Modular.get<RestClient>(),
        storage: Modular.get<LocalStorage>(),
      ),
    );

    i.addLazySingleton<RegisterFcmTokenUseCase>(
      () => RegisterFcmTokenUseCase(Modular.get<IDeviceTokenRepository>()),
    );

    i.addLazySingleton<RenderServiceStepUseCase>(
      () => RenderServiceStepUseCase(NotificationService.instance),
    );

    i.addLazySingleton<RenderCancellationUseCase>(
      () => RenderCancellationUseCase(NotificationService.instance),
    );

    i.addLazySingleton<ScheduleDailyReminderUseCase>(
      () => ScheduleDailyReminderUseCase(NotificationService.instance),
    );

    i.addLazySingleton<HandleNotificationTapUseCase>(
      () => HandleNotificationTapUseCase(),
    );

    i.addLazySingleton<NotificationSettingsCubit>(
      () => NotificationSettingsCubit(),
    );
  }
}
