import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:flutter_libphonenumber/src/phone_number_type.dart';

/// Manages countries by code and name
class CountryManager {
  static final CountryManager _instance = CountryManager._internal();
  factory CountryManager() => _instance;
  CountryManager._internal();

  var _countries = <CountryWithPhoneCode>[];
  var _initialized = false;

  /// List of all supported countries on the device with phone code metadata
  List<CountryWithPhoneCode> get countries => _countries;

  Future<void> loadCountries({
    Map<String, CountryWithPhoneCode> overrides = const {},
  }) async {
    if (_initialized) {
      return;
    }

    try {
      final phoneCodesMap =
          await FlutterLibphonenumber().getAllSupportedRegions();

      /// Apply any overrides to masks / country data
      overrides.forEach((key, value) {
        phoneCodesMap[key] = value;
        // print('Applied override for $key');
      });

      /// Save list of the countries
      _countries = phoneCodesMap.values.toList();

      _initialized = true;
    } catch (err) {
      _countries = overrides.values.toList();
      // log('[CountryManager] Error loading countries: $err');
    }
  }
}

class CountryWithPhoneCode {
  CountryWithPhoneCode({
    required this.phoneCode,
    required this.countryCode,
    required this.exampleNumberMobileNational,
    required this.exampleNumberFixedLineNational,
    required this.phoneMaskMobileNational,
    required this.phoneMaskFixedLineNational,
    required this.exampleNumberMobileInternational,
    required this.exampleNumberFixedLineInternational,
    required this.phoneMaskMobileInternational,
    required this.phoneMaskFixedLineInternational,
    required this.countryName,
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
        phoneMaskMobileInternational = '+00 0000 000000',
        phoneMaskFixedLineInternational = '+00 000 000 0000',
        countryName = 'United Kingdom';

  /// US locale, useful for dummy values
  const CountryWithPhoneCode.us()
      : phoneCode = '1',
        countryCode = 'US',
        exampleNumberMobileNational = '(201) 555-0123',
        exampleNumberFixedLineNational = '(201) 555-0123',
        phoneMaskMobileNational = '(000) 000-0000',
        phoneMaskFixedLineNational = '(000) 000-0000',
        exampleNumberMobileInternational = '+1 201-555-0123',
        exampleNumberFixedLineInternational = '+1 201-555-0123',
        phoneMaskMobileInternational = '+0 000-000-0000',
        phoneMaskFixedLineInternational = '+0 000-000-0000',
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
  final String? exampleNumberMobileNational;

  /// Example fixed line number in national format.
  /// ```
  /// 0121 234 5678
  /// ```
  final String? exampleNumberFixedLineNational;

  /// Phone mask for mobile number in national format.
  /// ```
  /// 00000 000000
  /// ```
  final String? phoneMaskMobileNational;

  /// Phone mask for fixed line number in national format.
  /// ```
  /// 0000 000 0000
  /// ```
  final String? phoneMaskFixedLineNational;

  /// Example mobile number in international format.
  /// ```
  /// +44 7400 123456
  /// ```
  final String? exampleNumberMobileInternational;

  /// Example fixed line number in international format.
  /// ```
  /// +44 121 234 5678
  /// ```
  final String? exampleNumberFixedLineInternational;

  /// Phone mask for mobile number in international format.
  /// ```
  /// +00 0000 000000
  /// ```
  final String? phoneMaskMobileInternational;

  /// Phone mask for fixed line number in international format.
  /// ```
  /// +00 000 000 0000
  /// ```
  final String? phoneMaskFixedLineInternational;

  /// Country name
  /// ```
  /// United Kingdom
  /// ```
  final String? countryName;

  @override
  String toString() =>
      '[CountryWithPhoneCode(countryName: $countryName, regionCode: $countryCode, phoneCode: $phoneCode, exampleNumberMobileNational: $exampleNumberMobileNational, exampleNumberFixedLineNational: $exampleNumberFixedLineNational, phoneMaskMobileNational: $phoneMaskMobileNational, phoneMaskFixedLineNational: $phoneMaskFixedLineNational, exampleNumberMobileInternational: $exampleNumberMobileInternational, exampleNumberFixedLineInternational: $exampleNumberFixedLineInternational, phoneMaskMobileInternational: $phoneMaskMobileInternational, phoneMaskFixedLineInternational: $phoneMaskFixedLineInternational)]';

  /// Get the phone mask based on number type and format
  String? getPhoneMask({
    required PhoneNumberFormat format,
    required PhoneNumberType type,
    bool maskWithoutCountryCode = false,
  }) {
    String? returnVal;
    if (type == PhoneNumberType.mobile) {
      if (format == PhoneNumberFormat.international) {
        returnVal = phoneMaskMobileInternational;
      } else {
        returnVal = phoneMaskMobileNational;
      }
    } else {
      if (format == PhoneNumberFormat.international) {
        returnVal = phoneMaskFixedLineInternational;
      } else {
        returnVal = phoneMaskFixedLineNational;
      }
    }

    /// If we want to get the mask without the country code, strip
    /// out the country code from the mask now.
    if (maskWithoutCountryCode && returnVal != null) {
      /// Return the mask after the country code and 2 characters,
      /// one for the leading + and the other for the space between
      /// country code and number.
      returnVal = returnVal.substring(phoneCode.length + 2);
    }

    return returnVal;
  }

  /*
  (c) Copyright 2020 Serov Konstantin.
  Licensed under the MIT license:
      http://www.opensource.org/licenses/mit-license.php
  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:
  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.
  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
  */
  static final RegExp _digitRegex = RegExp(r'[0-9]+');
  static final RegExp _digitWithPeriodRegex = RegExp(r'[0-9]+(\.[0-9]+)?');

  /// Try to guess country from phone
  static CountryWithPhoneCode? getCountryDataByPhone(
    String phone, {
    int? subscringLength,
  }) {
    /// If number is empty, return null
    if (phone.isEmpty) return null;

    /// Unless otherwise specified, start trying to match from the
    /// end of the inputted phone string.
    subscringLength = subscringLength ?? phone.length;

    /// Must provide valid offset to start searching from
    if (subscringLength < 1) return null;
    var phoneCode = phone.substring(0, subscringLength);

    try {
      final countries = CountryManager().countries;
      final retCountry = countries.firstWhere((data) {
        final res =
            _toNumericString(data.phoneCode) == _toNumericString(phoneCode);
        return res;
      });

      return retCountry;
    } on StateError catch (_) {
      return getCountryDataByPhone(phone, subscringLength: subscringLength - 1);
    }
  }

  static String _toNumericString(
    String inputString, {
    bool allowPeriod = false,
  }) {
    var regExp = allowPeriod ? _digitWithPeriodRegex : _digitRegex;
    return inputString.splitMapJoin(regExp,
        onMatch: (m) => m.group(0)!, onNonMatch: (nm) => '');
  }
}
