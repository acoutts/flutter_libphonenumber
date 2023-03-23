import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_libphonenumber_android/flutter_libphonenumber_android.dart';
import 'package:flutter_libphonenumber_android/flutter_libphonenumber_android_platform_interface.dart';
import 'package:flutter_libphonenumber_android/flutter_libphonenumber_android_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterLibphonenumberAndroidPlatform
    with MockPlatformInterfaceMixin
    implements FlutterLibphonenumberAndroidPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterLibphonenumberAndroidPlatform initialPlatform = FlutterLibphonenumberAndroidPlatform.instance;

  test('$MethodChannelFlutterLibphonenumberAndroid is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterLibphonenumberAndroid>());
  });

  test('getPlatformVersion', () async {
    FlutterLibphonenumberAndroid flutterLibphonenumberAndroidPlugin = FlutterLibphonenumberAndroid();
    MockFlutterLibphonenumberAndroidPlatform fakePlatform = MockFlutterLibphonenumberAndroidPlatform();
    FlutterLibphonenumberAndroidPlatform.instance = fakePlatform;

    expect(await flutterLibphonenumberAndroidPlugin.getPlatformVersion(), '42');
  });
}
