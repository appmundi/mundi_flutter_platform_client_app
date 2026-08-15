import Flutter
import UIKit
import awesome_notifications
import awesome_notifications_fcm

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Background isolates (notification taps and FCM silent data) start without
    // the plugins registered by GeneratedPluginRegistrant, so awesome_notifications
    // has to be registered again for each one — otherwise createNotification()
    // throws MissingPluginException and nothing is rendered.
    SwiftAwesomeNotificationsPlugin.setPluginRegistrantCallback { registry in
      SwiftAwesomeNotificationsPlugin.register(
        with: registry.registrar(forPlugin: "AwesomeNotificationsPlugin")!)
    }

    SwiftAwesomeNotificationsFcmPlugin.setPluginRegistrantCallback { registry in
      SwiftAwesomeNotificationsPlugin.register(
        with: registry.registrar(forPlugin: "AwesomeNotificationsPlugin")!)
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
