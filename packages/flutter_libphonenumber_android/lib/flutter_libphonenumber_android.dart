
import 'flutter_libphonenumber_android_platform_interface.dart';

class FlutterLibphonenumberAndroid {
  Future<String?> getPlatformVersion() {
    return FlutterLibphonenumberAndroidPlatform.instance.getPlatformVersion();
  }
}
