import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_libphonenumber_web/flutter_libphonenumber_web.dart';
import 'package:flutter_libphonenumber_web/flutter_libphonenumber_web_platform_interface.dart';
import 'package:flutter_libphonenumber_web/flutter_libphonenumber_web_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterLibphonenumberWebPlatform
    with MockPlatformInterfaceMixin
    implements FlutterLibphonenumberWebPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterLibphonenumberWebPlatform initialPlatform = FlutterLibphonenumberWebPlatform.instance;

  test('$MethodChannelFlutterLibphonenumberWeb is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterLibphonenumberWeb>());
  });

  test('getPlatformVersion', () async {
    FlutterLibphonenumberWeb flutterLibphonenumberWebPlugin = FlutterLibphonenumberWeb();
    MockFlutterLibphonenumberWebPlatform fakePlatform = MockFlutterLibphonenumberWebPlatform();
    FlutterLibphonenumberWebPlatform.instance = fakePlatform;

    expect(await flutterLibphonenumberWebPlugin.getPlatformVersion(), '42');
  });
}
