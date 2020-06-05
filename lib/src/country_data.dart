import 'dart:developer';
import 'dart:io';

import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:iso_countries/iso_countries.dart';

class CountryWithPhoneCode extends Country {
  CountryWithPhoneCode({
    this.phoneCode,
    this.phoneMask,
    String name,
    String countryCode,
  }) : super(name: name, countryCode: countryCode);

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

  /// GB locale, useful for dummy values
  const CountryWithPhoneCode.gb()
      : phoneCode = '44',
        phoneMask = '+00 0000 000000',
        super(
          name: 'United Kingdom',
          countryCode: 'GB',
        );

  /// US locale, useful for dummy values
  const CountryWithPhoneCode.us()
      : phoneCode = '1',
        phoneMask = '+0 (000) 000-0000',
        super(
          name: 'United States',
          countryCode: 'US',
        );

  final String phoneCode;
  final String phoneMask;
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
      Map<String, dynamic> phoneCodesList;
      List<Country> countriesList;

      await Future.wait(<Future>[
        FlutterLibphonenumber()
            .getAllSupportedRegions()
            .then((e) => phoneCodesList = e),
        IsoCountries.iso_countries.then((e) => countriesList = e),
      ]);

      /// Get the device locale
      try {
        deviceLocaleCountryCode = Platform.localeName.split('_').last;
      } catch (e) {
        print('Error detecting deviceLocaleCountryCode, setting default GB');
        deviceLocaleCountryCode = 'GB';
      }

      /// Create our countries list and use the phone lib library to
      /// piece together the country phone code with it.
      final phoneCodeMap = phoneCodesList
          .map((key, value) => MapEntry(key.toUpperCase(), value));

      final parsedCountriesList = countriesList
          .map((country) {
            // This is sometimes null which means there's no phone conde for that country
            final phoneCodeEntry = Map<String, String>.from(
                phoneCodeMap[country.countryCode] ?? {});

            return CountryWithPhoneCode(
              countryCode: country.countryCode.toUpperCase(),
              name: country.name,
              phoneCode: (phoneCodeEntry ?? {})['phoneCode'],
              phoneMask: (phoneCodeEntry ?? {})['phoneMask'],
            );
          })
          .where((f) => f.phoneCode != null) // Skip any null phone codes
          .toList();

      /// Now order it so the user's default locale country is on top
      countries = [
        parsedCountriesList.firstWhere(
          (element) => element.countryCode == deviceLocaleCountryCode,
          orElse: () => CountryWithPhoneCode.gb(),
        ),
        ...parsedCountriesList
            .where((element) => element.countryCode != deviceLocaleCountryCode),
      ];

      initialized = true;
    } catch (err) {
      print('Error loading countries: $err');
    }
  }
}
