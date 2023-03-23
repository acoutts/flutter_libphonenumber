import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter_libphonenumber/src/web/base.dart';
import 'package:flutter_libphonenumber/src/web/libphonenumber.dart';
import 'package:flutter_libphonenumber/src/web/utils.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'dart:html' as html;

const String libPhoneNumberVersion = '3.2.32';
const String libPhoneNumberUrl =
    'https://cdn.jsdelivr.net/npm/google-libphonenumber@$libPhoneNumberVersion/dist/libphonenumber.min.js';

class FlutterLibphonenumberWebPlugin {
  static late Future _jsLibrariesLoadingFuture;
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel('flutter_libphonenumber', const StandardMethodCodec(), registrar);
    channel.setMethodCallHandler(FlutterLibphonenumberWebPlugin.handleMethodCall);
    setupScripts();
  }

  static void setupScripts() {
    final libraries = [JsLibrary(contextName: 'libphonenumber', url: libPhoneNumberUrl, usesRequireJs: true)];
    final helperScriptTag = html.ScriptElement()
      ..type = 'application/javascript'
      ..text = '''
      function libPhoneNumberFlutterGetRegionDisplayNames(lang) {
          return new Intl.DisplayNames([lang], {type: 'region'});
      }
    ''';

    html.document.head!.append(helperScriptTag);
    _jsLibrariesLoadingFuture = injectJSLibraries(libraries);
  }

  static Future<dynamic> handleMethodCall(MethodCall call) async {
    await _jsLibrariesLoadingFuture;
    switch (call.method) {
      case 'get_all_supported_regions':
        return getAllSupportedRegions();
      case 'parse':
        return parse(call);
      case 'format':
        return format(call);
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: "The flutter_libphonenumber plugin for web doesn't implement the method ${call.method}",
        );
    }
  }

  static Future<Map<String, Map<String, String>>> getAllSupportedRegions() async {
    final util = PhoneNumberUtil.getInstance();
    final res = <String, Map<String, String>>{};
    final displayNames = libPhoneNumberFlutterGetRegionDisplayNames(window.locale.languageCode);
    for (final region in util.getSupportedRegions()) {
      final exampleNumberMobile = util.getExampleNumberForType(region, PhoneNumberType.MOBILE) ?? PhoneNumber();
      final exampleNumberFixedLine = util.getExampleNumberForType(region, PhoneNumberType.FIXED_LINE) ?? PhoneNumber();
      final phoneCode = util.getCountryCodeForRegion(region).toString();
      final item = {
        'phoneCode': phoneCode,
        'exampleNumberMobileNational': formatNational(exampleNumberMobile).toString(),
        'exampleNumberFixedLineNational': formatNational(exampleNumberFixedLine).toString(),
        'phoneMaskMobileNational': maskNumber(formatNational(exampleNumberMobile).toString(), phoneCode),
        'phoneMaskFixedLineNational': maskNumber(formatNational(exampleNumberFixedLine).toString(), phoneCode),
        'exampleNumberMobileInternational': formatInternational(exampleNumberMobile).toString(),
        'exampleNumberFixedLineInternational': formatInternational(exampleNumberFixedLine).toString(),
        'phoneMaskMobileInternational': maskNumber(formatInternational(exampleNumberMobile).toString(), phoneCode),
        'phoneMaskFixedLineInternational':
            maskNumber(formatInternational(exampleNumberFixedLine).toString(), phoneCode),
        'countryName': displayNames.of(region),
      };
      res[region] = item;
    }
    return res;
  }

  static Future<Map<String, String>> parse(MethodCall methodCall) async {
    final region = methodCall.arguments['region'] as String?;
    final phone = methodCall.arguments['phone'] as String?;
    if (phone == null) {
      throw PlatformException(code: 'InvalidParameters', message: "Invalid 'phone' parameter.");
    }
    final util = PhoneNumberUtil.getInstance();
    final res = util.parseStringAndRegion(phone, region);
    if (res != null) {
      return res;
    } else {
      throw PlatformException(code: 'InvalidNumber', message: 'Number $phone is invalid');
    }
  }

  static Future<Map<String, String>> format(MethodCall methodCall) async {
    final region = methodCall.arguments['region'] as String?;
    final phone = methodCall.arguments['phone'] as String?;
    if (phone == null) {
      throw PlatformException(code: 'InvalidParameters', message: "Invalid 'phone' parameter.");
    }
    try {
      final formatter = AsYouTypeFormatter(region);
      formatter.clear();
      String formatted = '';
      for (final char in phone.split('')) {
        formatted = formatter.inputDigit(char);
      }
      return {'formatted': formatted};
    } catch (_) {
      throw PlatformException(code: 'InvalidNumber', message: 'Number $phone is invalid');
    }
  }

  static String maskNumber(String phoneNumber, String phoneCode) => phoneNumber.replaceAll(RegExp(r'\d'), '0');

  static String formatNational(PhoneNumber phoneNumber) =>
      PhoneNumberUtil.getInstance().format(phoneNumber, PhoneNumberFormat.NATIONAL);

  static String formatInternational(PhoneNumber phoneNumber) =>
      PhoneNumberUtil.getInstance().format(phoneNumber, PhoneNumberFormat.INTERNATIONAL);
}
