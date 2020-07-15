import 'dart:developer';
import 'dart:io';

import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';

/// Manages countries by code and name
class CountryManager {
  static final CountryManager _instance = CountryManager._internal();
  factory CountryManager() => _instance;
  CountryManager._internal();

  List<CountryWithPhoneCode> _countries = [];
  String deviceLocaleCountryCode;
  var _initialized = false;

  /// List of all supported countries on the device with phone code metadata
  List<CountryWithPhoneCode> get countries => _countries;

  Future<void> loadCountries(
      {Map<String, CountryWithPhoneCode> overrides}) async {
    if (_initialized) {
      return;
    }

    try {
      final phoneCodesMap =
          await FlutterLibphonenumber().getAllSupportedRegions();

      /// Apply any overrides to masks / country data
      (overrides ?? {}).forEach((key, value) {
        phoneCodesMap[key] = value;
        // print('Applied override for $key');
      });

      /// Get the device locale
      try {
        final locale = await Devicelocale.currentLocale;
        deviceLocaleCountryCode = locale.substring(locale.length - 2);
      } catch (e) {
        // print('Error detecting deviceLocaleCountryCode, setting default GB');
        deviceLocaleCountryCode = 'GB';
      }

      /// Save list of the countries
      _countries = phoneCodesMap.values.toList();

      _initialized = true;
    } catch (err) {
      // log('[CountryManager] Error loading countries: $err');
    }
  }
}

class CountryWithPhoneCode {
  CountryWithPhoneCode({
    @required this.phoneCode,
    @required this.countryCode,
    @required this.exampleNumberMobileNational,
    @required this.exampleNumberFixedLineNational,
    @required this.phoneMaskMobileNational,
    @required this.phoneMaskFixedLineNational,
    @required this.exampleNumberMobileInternational,
    @required this.exampleNumberFixedLineInternational,
    @required this.phoneMaskMobileInternational,
    @required this.phoneMaskFixedLineInternational,
    @required this.countryName,
  });

  /// GB locale, useful for dummy values
  const CountryWithPhoneCode.gb()
      : phoneCode = '44',
        countryCode = 'GB',
        exampleNumberMobileNational = '07400 123456',
        exampleNumberFixedLineNational = '0121 234 5678',
        phoneMaskMobileNational = '+00 00000 000000',
        phoneMaskFixedLineNational = '+00 0000 000 0000',
        exampleNumberMobileInternational = '+44 7400 123456',
        exampleNumberFixedLineInternational = '+44 121 234 5678',
        phoneMaskMobileInternational = '+00 +00 0000 000000',
        phoneMaskFixedLineInternational = '+00 +00 000 000 0000',
        countryName = 'United Kingdom';

  /// US locale, useful for dummy values
  const CountryWithPhoneCode.us()
      : phoneCode = '1',
        countryCode = 'US',
        exampleNumberMobileNational = '(201) 555-0123',
        exampleNumberFixedLineNational = '(201) 555-0123',
        phoneMaskMobileNational = '+0 (000) 000-0000',
        phoneMaskFixedLineNational = '+0 (000) 000-0000',
        exampleNumberMobileInternational = '+1 201-555-0123',
        exampleNumberFixedLineInternational = '+1 201-555-0123',
        phoneMaskMobileInternational = '+00 +00 0000 000000',
        phoneMaskFixedLineInternational = '+00 +00 000 000 0000',
        countryName = 'United States';

  /// Country locale code.
  /// ```
  /// GB
  /// ```
  final String countryCode;

  /// Country phone code.
  /// ```
  /// 44
  /// ```
  final String phoneCode;

  /// Example mobile number in national format.
  /// ```
  /// 07400 123456
  /// ```
  final String exampleNumberMobileNational;

  /// Example fixed line number in national format.
  /// ```
  /// 0121 234 5678
  /// ```
  final String exampleNumberFixedLineNational;

  /// Phone mask for mobile number in national format.
  /// ```
  /// 00000 000000
  /// ```
  final String phoneMaskMobileNational;

  /// Phone mask for fixed line number in national format.
  /// ```
  /// 0000 000 0000
  /// ```
  final String phoneMaskFixedLineNational;

  /// Example mobile number in international format.
  /// ```
  /// +44 7400 123456
  /// ```
  final String exampleNumberMobileInternational;

  /// Example fixed line number in international format.
  /// ```
  /// +44 121 234 5678
  /// ```
  final String exampleNumberFixedLineInternational;

  /// Phone mask for mobile number in international format.
  /// ```
  /// +00 0000 000000
  /// ```
  final String phoneMaskMobileInternational;

  /// Phone mask for fixed line number in international format.
  /// ```
  /// +00 000 000 0000
  /// ```
  final String phoneMaskFixedLineInternational;

  /// Country name
  /// ```
  /// United Kingdom
  /// ```
  final String countryName;

  @override
  String toString() =>
      '[CountryWithPhoneCode(countryName: $countryName, regionCode: $countryCode, phoneCode: $phoneCode, exampleNumberMobileNational: $exampleNumberMobileNational, exampleNumberFixedLineNational: $exampleNumberFixedLineNational, phoneMaskMobileNational: $phoneMaskMobileNational, phoneMaskFixedLineNational: $phoneMaskFixedLineNational, exampleNumberMobileInternational: $exampleNumberMobileInternational, exampleNumberFixedLineInternational: $exampleNumberFixedLineInternational, phoneMaskMobileInternational: $phoneMaskMobileInternational, phoneMaskFixedLineInternational: $phoneMaskFixedLineInternational)]';

  static CountryWithPhoneCode getCountryDataByPhone(String phone,
      {int subscringLength}) {
    if (phone.isEmpty) return null;
    subscringLength = subscringLength ?? phone.length;

    if (subscringLength < 1) return null;
    var phoneCode = phone.substring(0, subscringLength);

    var rawData = CountryManager().countries.firstWhere(
        (data) => toNumericString(data.phoneCode.toString()) == phoneCode,
        orElse: () => null);
    if (rawData != null) {
      return rawData;
    }
    return getCountryDataByPhone(phone, subscringLength: subscringLength - 1);
  }

  /// Get the phone mask based on number type and format
  getPhoneMask(
      {@required PhoneNumberFormat format, @required PhoneNumberType type}) {
    if (format == PhoneNumberFormat.international &&
        type == PhoneNumberType.mobile) {
      return phoneMaskMobileInternational;
    } else if (format == PhoneNumberFormat.international &&
        type == PhoneNumberType.fixedLine) {
      return phoneMaskFixedLineInternational;
    } else if (format == PhoneNumberFormat.national &&
        type == PhoneNumberType.mobile) {
      return phoneMaskMobileNational;
    } else {
      return phoneMaskFixedLineNational;
    }
  }
}

/// Used for phone masks to know how to format numbers
enum PhoneNumberType { mobile, fixedLine }

/// Used to format with national or international format
enum PhoneNumberFormat { national, international }
