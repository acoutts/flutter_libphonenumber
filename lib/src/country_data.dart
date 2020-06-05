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
                phoneMask: data['phoneMask'],
                exampleNumber: data['exampleNumber'],
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
    this.phoneMask,
    this.name,
    this.countryCode,
    this.exampleNumber,
  });

  /// GB locale, useful for dummy values
  const CountryWithPhoneCode.gb()
      : phoneCode = '44',
        phoneMask = '+00 0000 000000',
        name = 'United Kingdom',
        exampleNumber = '0121 234 5678',
        countryCode = 'GB';

  /// US locale, useful for dummy values
  const CountryWithPhoneCode.us()
      : phoneCode = '1',
        phoneMask = '+0 (000) 000-0000',
        name = 'United States',
        exampleNumber = '(201) 555-0123',
        countryCode = 'US';

  final String phoneCode;
  final String phoneMask;
  final String name;
  final String countryCode;
  final String exampleNumber;

  @override
  String toString() =>
      '[CountryWithPhoneCode(name: $name, countryCode: $countryCode, phoneCode: $phoneCode, phoneMask: $phoneMask)]';

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
