import 'dart:io';

import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';

class CountryWithPhoneCode {
  CountryWithPhoneCode({
    this.phoneCode,
    this.phoneMask,
    this.name,
    this.countryCode,
  });

  /// GB locale, useful for dummy values
  const CountryWithPhoneCode.gb()
      : phoneCode = '44',
        phoneMask = '+00 0000 000000',
        name = 'United Kingdom',
        countryCode = 'GB';

  /// US locale, useful for dummy values
  const CountryWithPhoneCode.us()
      : phoneCode = '1',
        phoneMask = '+0 (000) 000-0000',
        name = 'United States',
        countryCode = 'US';

  final String phoneCode;
  final String phoneMask;
  final String name;
  final String countryCode;

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

/// Manages countries by code and name
class CountryManager {
  static final CountryManager _instance = CountryManager._internal();
  factory CountryManager() => _instance;
  CountryManager._internal();

  List<CountryWithPhoneCode> countries = [];
  String deviceLocaleCountryCode;
  var initialized = false;

  Future<void> loadCountries() async {
    if (initialized) {
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
          .forEach((region, data) => countries.add(CountryWithPhoneCode(
                countryCode: region,
                name: data['countryName'],
                phoneCode: data['phoneCode'],
                phoneMask: data['phoneMask'],
              )));

      initialized = true;
    } catch (err) {
      print('Error loading countries: $err');
    }
  }
}
