import 'dart:js_interop';

import 'package:flutter/services.dart';
import 'package:flutter_libphonenumber_platform_interface/flutter_libphonenumber_platform_interface.dart';
import 'package:flutter_libphonenumber_web/src/base.dart';
import 'package:flutter_libphonenumber_web/src/libphonenumber.dart'
    as phoneutil;
import 'package:flutter_libphonenumber_web/src/utils.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart' as io;

class FlutterLibphonenumberPlugin extends FlutterLibphonenumberPlatform {
  static late Future _jsLibrariesLoadingFuture;

  /// Registers this class as the default instance of [FlutterLibphonenumberPlatform].
  static void registerWith(final Registrar registrar) {
    FlutterLibphonenumberPlatform.instance = FlutterLibphonenumberPlugin();
    _setupScripts();
  }

  static Future<String> getJsFilePath(final String assetPath) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = io.File('${directory.path}/libphonenumber.js');
    final byteData = await rootBundle.load(assetPath);
    final buffer = byteData.buffer;
    await file.writeAsBytes(
      buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),);
    return file.uri.toString();
  }

  static Future<void> _setupScripts() async {
    final libraries = [
      JsLibrary(
        contextName: 'libphonenumber',
        url: await getJsFilePath('assets/libphonenumber.js'),
        usesRequireJs: true,
      ),
    ];

    final helperScriptTag = HTMLScriptElement()
      ..type = 'application/javascript'
      ..text = '''
      function libPhoneNumberFlutterGetRegionDisplayNames(lang) {
          return new Intl.DisplayNames([lang], {type: 'region'});
      }
    ''';

    document.head!.append(helperScriptTag);
    _jsLibrariesLoadingFuture = injectJSLibraries(libraries);
  }

  @override
  Future<Map<String, String>> format(
    final String phone,
    final String region,
  ) async {
    await _jsLibrariesLoadingFuture;

    try {
      final formatter = phoneutil.AsYouTypeFormatter(region);
      formatter.clear();
      String formatted = '';
      for (final char in phone.split('')) {
        formatted = formatter.inputDigit(char);
      }
      return {'formatted': formatted};
    } catch (_) {
      throw PlatformException(
        code: 'InvalidNumber',
        message: 'Number $phone is invalid',
      );
    }
  }

  @override
  Future<Map<String, CountryWithPhoneCode>> getAllSupportedRegions() async {
    await _jsLibrariesLoadingFuture;

    final util = phoneutil.PhoneNumberUtil.getInstance();

    final res = <String, CountryWithPhoneCode>{};

    final displayNames = phoneutil
        .libPhoneNumberFlutterGetRegionDisplayNames(window.navigator.language);

    final regions = util.getSupportedRegions().toDart;
    for (final regionJs in regions) {
      final region = regionJs.toDart;
      final exampleNumberMobile = util.getExampleNumberForType(
            region,
            phoneutil.PhoneNumberType.MOBILE,
          ) ??
          phoneutil.PhoneNumber();

      final exampleNumberFixedLine = util.getExampleNumberForType(
            region,
            phoneutil.PhoneNumberType.FIXED_LINE,
          ) ??
          phoneutil.PhoneNumber();

      final phoneCode = util.getCountryCodeForRegion(region).toString();

      res[region] = CountryWithPhoneCode(
        phoneCode: phoneCode,
        countryCode: region,
        exampleNumberMobileNational: _formatNational(exampleNumberMobile),
        exampleNumberFixedLineNational: _formatNational(exampleNumberFixedLine),
        phoneMaskMobileNational: _maskNumber(
          _formatNational(exampleNumberMobile),
          phoneCode,
        ),
        phoneMaskFixedLineNational: _maskNumber(
          _formatNational(exampleNumberFixedLine),
          phoneCode,
        ),
        exampleNumberMobileInternational:
            _formatInternational(exampleNumberMobile),
        exampleNumberFixedLineInternational:
            _formatInternational(exampleNumberFixedLine),
        phoneMaskMobileInternational: _maskNumber(
          _formatInternational(exampleNumberMobile),
          phoneCode,
        ),
        phoneMaskFixedLineInternational: _maskNumber(
          _formatInternational(exampleNumberFixedLine),
          phoneCode,
        ),
        countryName: displayNames.of(region),
      );
    }
    return res;
  }

  @override
  Future<Map<String, dynamic>> parse(
    final String phone, {
    final String? region,
  }) async {
    await _jsLibrariesLoadingFuture;

    final util = phoneutil.PhoneNumberUtil.getInstance();
    final res = util.parseStringAndRegion(phone, region);
    if (res != null) {
      return res;
    } else {
      throw PlatformException(
        code: 'InvalidNumber',
        message: 'Number $phone is invalid',
      );
    }
  }

  @override
  Future<void> init({
    final Map<String, CountryWithPhoneCode> overrides = const {},
  }) async {
    await _jsLibrariesLoadingFuture;

    return CountryManager().loadCountries(
      phoneCodesMap: await getAllSupportedRegions(),
      overrides: overrides,
    );
  }

  static String _maskNumber(final String phoneNumber, final String phoneCode) =>
      phoneNumber.replaceAll(RegExp(r'\d'), '0');

  static String _formatNational(final phoneutil.PhoneNumber phoneNumber) =>
      phoneutil.PhoneNumberUtil.getInstance()
          .format(phoneNumber, phoneutil.PhoneNumberFormat.NATIONAL);

  static String _formatInternational(final phoneutil.PhoneNumber phoneNumber) =>
      phoneutil.PhoneNumberUtil.getInstance().format(
        phoneNumber,
        phoneutil.PhoneNumberFormat.INTERNATIONAL,
      );
}
