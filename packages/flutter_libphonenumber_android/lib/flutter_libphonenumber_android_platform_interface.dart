import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_libphonenumber_android_method_channel.dart';

abstract class FlutterLibphonenumberAndroidPlatform extends PlatformInterface {
  /// Constructs a FlutterLibphonenumberAndroidPlatform.
  FlutterLibphonenumberAndroidPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterLibphonenumberAndroidPlatform _instance = MethodChannelFlutterLibphonenumberAndroid();

  /// The default instance of [FlutterLibphonenumberAndroidPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterLibphonenumberAndroid].
  static FlutterLibphonenumberAndroidPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterLibphonenumberAndroidPlatform] when
  /// they register themselves.
  static set instance(FlutterLibphonenumberAndroidPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
