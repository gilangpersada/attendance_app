import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyA4W_CWTupNmqaU_T7wHgA-zl3vMg0-0ts")
    GeneratedPluginRegistrant.register(with: self)
    // Use Firebase library to configure APIs
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
