import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_libphonenumber_android_platform_interface.dart';

/// An implementation of [FlutterLibphonenumberAndroidPlatform] that uses method channels.
class MethodChannelFlutterLibphonenumberAndroid extends FlutterLibphonenumberAndroidPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_libphonenumber_android');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
