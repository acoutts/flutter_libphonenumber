import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_libphonenumber_android/flutter_libphonenumber_android_method_channel.dart';

void main() {
  MethodChannelFlutterLibphonenumberAndroid platform = MethodChannelFlutterLibphonenumberAndroid();
  const MethodChannel channel = MethodChannel('flutter_libphonenumber_android');

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
