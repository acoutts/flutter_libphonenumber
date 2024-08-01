import 'dart:js_interop';

import 'package:flutter/services.dart';
import 'package:flutter_libphonenumber_platform_interface/flutter_libphonenumber_platform_interface.dart';
import 'package:flutter_libphonenumber_web/src/base.dart';
import 'package:flutter_libphonenumber_web/src/libphonenumber.dart'
    as phoneutil;
import 'package:flutter_libphonenumber_web/src/utils.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart';

/// The version of libphonenumber to use
const String libPhoneNumberVersion = 'b7fe84af9b553f0f2db765a6e20c27fa867a971d';
const String libPhoneNumberUrl =
    'https://cdn.jsdelivr.net/gh/ruimarinho/google-libphonenumber@$libPhoneNumberVersion/dist/libphonenumber.min.js';

class FlutterLibphonenumberPlugin extends FlutterLibphonenumberPlatform {
  static late Future _jsLibrariesLoadingFuture;

  /// Registers this class as the default instance of [FlutterLibphonenumberPlatform].
  static void registerWith(final Registrar registrar) {
    FlutterLibphonenumberPlatform.instance = FlutterLibphonenumberPlugin();
    _setupScripts();
  }

  static void _setupScripts() {
    final libraries = [
      const JsLibrary(
        contextName: 'libphonenumber',
        url: libPhoneNumberUrl,
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
