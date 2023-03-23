import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_libphonenumber_web_method_channel.dart';

abstract class FlutterLibphonenumberWebPlatform extends PlatformInterface {
  /// Constructs a FlutterLibphonenumberWebPlatform.
  FlutterLibphonenumberWebPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterLibphonenumberWebPlatform _instance = MethodChannelFlutterLibphonenumberWeb();

  /// The default instance of [FlutterLibphonenumberWebPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterLibphonenumberWeb].
  static FlutterLibphonenumberWebPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterLibphonenumberWebPlatform] when
  /// they register themselves.
  static set instance(FlutterLibphonenumberWebPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
