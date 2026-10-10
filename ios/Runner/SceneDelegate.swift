import Flutter
import UIKit
import FirebaseAuth

class SceneDelegate: FlutterSceneDelegate {
  override func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    // With Firebase swizzling disabled, reCAPTCHA redirects arrive here.
    let unhandledContexts = Set(URLContexts.filter { !Auth.auth().canHandle($0.url) })
    if !unhandledContexts.isEmpty {
      super.scene(scene, openURLContexts: unhandledContexts)
    }
  }
}
