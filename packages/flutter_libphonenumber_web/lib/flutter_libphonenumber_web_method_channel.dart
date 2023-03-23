import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_libphonenumber_web_platform_interface.dart';

/// An implementation of [FlutterLibphonenumberWebPlatform] that uses method channels.
class MethodChannelFlutterLibphonenumberWeb extends FlutterLibphonenumberWebPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_libphonenumber_web');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
