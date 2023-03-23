
import 'flutter_libphonenumber_web_platform_interface.dart';

class FlutterLibphonenumberWeb {
  Future<String?> getPlatformVersion() {
    return FlutterLibphonenumberWebPlatform.instance.getPlatformVersion();
  }
}
