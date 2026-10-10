import UIKit
import Flutter
import GoogleMaps
import Firebase
import FirebaseAuth

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    #if DEBUG
    // Surfaces the real underlying cause behind generic FirebaseAuthException
    // codes like "internal-error" (e.g. the actual identitytoolkit HTTP
    // response), which never crosses the Dart platform channel otherwise.
    FirebaseConfiguration.shared.setLoggerLevel(.debug)
    #endif
    FirebaseApp.configure()
    GMSServices.provideAPIKey("AIzaSyA4tuYaOWXDRLICWhWKc_P1819Xo3A0Ebc")

    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate  // No need for the cast or protocol conformance
    }

    application.registerForRemoteNotifications()
    UIApplication.shared.beginReceivingRemoteControlEvents()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Plugin registration moved here from didFinishLaunchingWithOptions as
  // part of adopting the UIScene lifecycle (see SceneDelegate.swift +
  // UIApplicationSceneManifest in Info.plist) — the FlutterEngine/
  // FlutterViewController is now created by SceneDelegate, not directly by
  // AppDelegate, so plugins need to register once that engine actually
  // exists rather than unconditionally at app launch. Not adopting this
  // was flagged as a deprecation warning for a while ("UIScene lifecycle
  // will soon be required") and has since started hard-crashing at launch
  // (EXC_BREAKPOINT in UIApplicationEvaluateRuntimeIssueForNoSceneLifecycleAdoption)
  // on newer iOS/Xcode SDKs.
  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  // FirebaseAppDelegateProxyEnabled is set to false in Info.plist, which
  // disables Firebase's automatic method swizzling — these callbacks
  // that it would otherwise inject itself have to be forwarded manually, or
  // FirebaseAuth's phone-verification flow can't complete on either path:
  // the reCAPTCHA fallback (needs the URL callback below) or silent-push
  // verification on a real device (needs the APNs token below).

  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    if Auth.auth().canHandle(url) {
      return true
    }
    return super.application(app, open: url, options: options)
  }

  override func application(
    _ application: UIApplication,
    didReceiveRemoteNotification userInfo: [AnyHashable: Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
  ) {
    if Auth.auth().canHandleNotification(userInfo) {
      completionHandler(.noData)
      return
    }
    super.application(
      application,
      didReceiveRemoteNotification: userInfo,
      fetchCompletionHandler: completionHandler
    )
  }

  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    Auth.auth().setAPNSToken(deviceToken, type: .unknown)
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }
}
