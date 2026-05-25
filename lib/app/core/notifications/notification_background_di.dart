import 'package:get_it/get_it.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/notifications/use_cases/handle_notification_tap_use_case.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/notifications/use_cases/register_fcm_token_use_case.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/notifications/use_cases/render_cancellation_use_case.dart';
import 'package:mundi_flutter_platform_client_app/app/modules/notifications/use_cases/render_service_step_use_case.dart';

import 'notification_service.dart';

/// Scoped get_it container for the four @pragma('vm:entry-point') static
/// listeners. These can run in a background isolate where flutter_modular's
/// DI tree is not available. Foreground code continues to use Modular.
class NotificationBackgroundDI {
  static final _gi = GetIt.instance;
  static bool _done = false;

  /// Safe to call from any isolate; idempotent — no-op if already registered.
  static void setup() {
    if (_done) return;

    _gi.registerLazySingleton<NotificationService>(
      () => NotificationService.instance,
    );

    _gi.registerLazySingleton<RenderServiceStepUseCase>(
      () => RenderServiceStepUseCase(_gi<NotificationService>()),
    );

    _gi.registerLazySingleton<RenderCancellationUseCase>(
      () => RenderCancellationUseCase(_gi<NotificationService>()),
    );

    _gi.registerLazySingleton<HandleNotificationTapUseCase>(
      () => HandleNotificationTapUseCase(),
    );

    // Token storage uses SharedPreferences which works across isolates.
    // HTTP registration is deferred to the next foreground launch via run().
    _gi.registerLazySingleton<RegisterFcmTokenUseCase>(
      () => RegisterFcmTokenUseCase.backgroundSafe(),
    );

    _done = true;
  }
}
