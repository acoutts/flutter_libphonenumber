import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_libphonenumber_web/flutter_libphonenumber_web_method_channel.dart';

void main() {
  MethodChannelFlutterLibphonenumberWeb platform = MethodChannelFlutterLibphonenumberWeb();
  const MethodChannel channel = MethodChannel('flutter_libphonenumber_web');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
