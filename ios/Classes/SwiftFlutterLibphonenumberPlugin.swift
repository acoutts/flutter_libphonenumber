import Flutter
import UIKit

public class SwiftFlutterLibphonenumberPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_libphonenumber", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterLibphonenumberPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "get_all_supported_regions":
            break;
        case "format":
            break;
        case "parse":
            break;
        default:
            result(FlutterMethodNotImplemented)
        }    }
}
