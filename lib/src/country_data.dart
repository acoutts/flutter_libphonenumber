import 'dart:developer';
import 'dart:io';

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

  Future<void> loadCountries() async {
    if (_initialized) {
      return;
    }

    try {
      final phoneCodesList =
          await FlutterLibphonenumber().getAllSupportedRegions();

      /// Get the device locale
      try {
        deviceLocaleCountryCode = Platform.localeName.split('_').last;
      } catch (e) {
        print('Error detecting deviceLocaleCountryCode, setting default GB');
        deviceLocaleCountryCode = 'GB';
      }

      phoneCodesList
          .forEach((region, data) => _countries.add(CountryWithPhoneCode(
                countryCode: region,
                name: data['countryName'],
                phoneCode: data['phoneCode'],
                phoneMaskMobile: data['phoneMaskMobile'],
                phoneMaskFixedLine: data['phoneMaskFixedLine'],
                exampleNumberMobile: data['exampleNumberMobile'],
                exampleNumberFixedLine: data['exampleNumberFixedLine'],
              )));

      _initialized = true;
    } catch (err) {
      log('[CountryManager] Error loading countries: $err');
    }
  }
}

class CountryWithPhoneCode {
  CountryWithPhoneCode({
    this.phoneCode,
    this.phoneMaskFixedLine,
    this.phoneMaskMobile,
    this.name,
    this.countryCode,
    this.exampleNumberFixedLine,
    this.exampleNumberMobile,
  });

  /// GB locale, useful for dummy values
  const CountryWithPhoneCode.gb()
      : phoneCode = '44',
        phoneMaskMobile = '+00 00000 000000',
        phoneMaskFixedLine = '+00 0000 000 0000',
        name = 'United Kingdom',
        exampleNumberMobile = '07400 123456',
        exampleNumberFixedLine = '0121 234 5678',
        countryCode = 'GB';

  /// US locale, useful for dummy values
  const CountryWithPhoneCode.us()
      : phoneCode = '1',
        phoneMaskMobile = '+0 (000) 000-0000',
        phoneMaskFixedLine = '+0 (000) 000-0000',
        name = 'United States',
        exampleNumberMobile = '(201) 555-0123',
        exampleNumberFixedLine = '(201) 555-0123',
        countryCode = 'US';

  final String phoneCode;
  final String phoneMaskMobile;
  final String phoneMaskFixedLine;
  final String name;
  final String countryCode;
  final String exampleNumberMobile;
  final String exampleNumberFixedLine;

  @override
  String toString() =>
      '[CountryWithPhoneCode(name: $name, countryCode: $countryCode, phoneCode: $phoneCode, phoneMaskMobile: $phoneMaskMobile, phoneMaskFixedLine: $phoneMaskFixedLine, exampleNumberMobile: $exampleNumberMobile, exampleNumberMobile: $exampleNumberMobile)]';

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
}

/// Used for phone masks to know how to format numbers
enum PhoneNumberType { mobile, fixedLine }
