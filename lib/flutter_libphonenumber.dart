import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_libphonenumber/src/country_data.dart';
import 'package:flutter_libphonenumber/src/input_formatter.dart';

export 'package:flutter_libphonenumber/src/input_formatter.dart';
export 'package:flutter_libphonenumber/src/country_data.dart';

class FlutterLibphonenumber {
  static final FlutterLibphonenumber _instance =
      FlutterLibphonenumber._internal();
  factory FlutterLibphonenumber() => _instance;
  FlutterLibphonenumber._internal();

  /// Method channel
  MethodChannel _channel = const MethodChannel('flutter_libphonenumber');

  // List<CountryWithPhoneCode> get countries => CountryManager().countries;

  /// Must call this before anything else so the countries data is populated
  Future<void> init() async {
    return CountryManager().loadCountries();
  }

  /// Return all available regions with their country code, phone code, and formatted
  /// example number as a mask. Useful to later format phone numbers using a mask.
  ///
  /// The response will be a [CountryWithPhoneCode]:
  ///
  /// There are some performance considerations for this so you might want to cache the
  /// result and re-use it elsewhere. There's a lot of data to iterate over.
  Future<Map<String, CountryWithPhoneCode>> getAllSupportedRegions() async {
    /// Here is what will return from the platform call:
    /// ```
    /// {
    ///   "UK": {
    ///     "phoneCode": 44,
    ///     "exampleNumberMobileNational": "07400 123456",
    ///     "exampleNumberFixedLineNational": "0121 234 5678",
    ///     "phoneMaskMobileNational": "+00 00000 000000",
    ///     "phoneMaskFixedLineNational": "+00 0000 000 0000",
    ///     "exampleNumberMobileInternational": "+44 7400 123456",
    ///     "exampleNumberFixedLineInternational": "+44 121 234 5678",
    ///     "phoneMaskMobileInternational": "+00 +00 0000 000000",
    ///     "phoneMaskFixedLineInternational": "+00 +00 000 000 0000",
    ///     "countryName": "United Kingdom"
    ///   }
    /// }
    /// ```
    final result = await _channel
        .invokeMapMethod<String, dynamic>("get_all_supported_regions");
    final returnMap = <String, CountryWithPhoneCode>{};
    result.forEach((k, v) => returnMap[k] = CountryWithPhoneCode(
          countryName: v['countryName'],
          phoneCode: v['phoneCode'],
          countryCode: k,
          exampleNumberMobileNational: v['exampleNumberMobileNational'],
          exampleNumberFixedLineNational: v['exampleNumberFixedLineNational'],
          phoneMaskMobileNational: v['phoneMaskMobileNational'],
          phoneMaskFixedLineNational: v['phoneMaskFixedLineNational'],
          exampleNumberMobileInternational:
              v['exampleNumberMobileInternational'],
          exampleNumberFixedLineInternational:
              v['exampleNumberFixedLineInternational'],
          phoneMaskMobileInternational: v['phoneMaskMobileInternational'],
          phoneMaskFixedLineInternational: v['phoneMaskFixedLineInternational'],
        ));
    return returnMap;
  }

  /// Formats a phone number using libphonenumber. Will return the parsed number.
  ///
  /// Example response:
  /// ```
  /// {
  ///   formatted: "1 (414) 444-4444",
  /// }
  /// ```
  Future<Map<String, String>> format(String phone, String region) {
    return _channel.invokeMapMethod<String, String>("format", {
      "phone": _ensureLeadingPlus(phone),
      "region": region,
    });
  }

  /// Parse a single string and return a map in the format below. Throws an error if the
  /// number is not a valid e164 phone number.
  ///
  /// Given a passed [phone] like '+4930123123123', the response will be:
  /// ```
  /// {
  ///   country_code: 49,
  ///   e164: '+4930123123123',
  ///   national: '030 123 123 123',
  ///   type: 'mobile',
  ///   international: '+49 30 123 123 123',
  ///   national_number: '030123123123',
  /// }
  /// ```
  Future<Map<String, dynamic>> parse(String phone, {String region}) {
    return _channel.invokeMapMethod<String, dynamic>("parse", {
      "phone": _ensureLeadingPlus(phone),
      "region": region,
    });
  }

  /// Given a phone number, format it automatically using the masks we have from libphonenumber's example numbers.
  String formatNumberSync(
    String phone, {
    phoneNumberType = PhoneNumberType.mobile,
    phoneNumberFormat = PhoneNumberFormat.international,
  }) {
    return LibPhonenumberTextFormatter(
      phoneNumberType: phoneNumberType,
      phoneNumberFormat: phoneNumberFormat,
    )
        .formatEditUpdate(
            TextEditingValue(text: ''), TextEditingValue(text: phone))
        .text;
  }

  /// Asynchronously formats a phone number with libphonenumber. Will return the formatted number
  /// and if it's a valid/complete number, will return the e164 value as well. Uses libphonenumber's
  /// parse function to verify if it's a valid number or not.
  Future<FormatPhoneResult> formatParsePhonenumberAsync(
    String phoneNumber,
    CountryWithPhoneCode country, {
    phoneNumberType = PhoneNumberType.mobile,
    phoneNumberFormat = PhoneNumberFormat.international,
  }) async {
    // print(
    //     '[formatParsePhonenumberAsync] phoneNumber: \'$phoneNumber\' | country: ${country.countryCode}');

    /// What we will return
    final returnResult = FormatPhoneResult();

    /// Format the number with appropriate mask
    final formattedResult = LibPhonenumberTextFormatter(
      overrideSkipCountryCode: country.countryCode,
      phoneNumberType: phoneNumberType,
    )
        .formatEditUpdate(
            TextEditingValue(text: ''), TextEditingValue(text: phoneNumber))
        .text;
    returnResult.formattedNumber = formattedResult;

    /// Try to parse the number to update our e164
    try {
      final parsedResult =
          await parse('+${country.phoneCode}${onlyDigits(phoneNumber)}');
      // print('[formatParsePhonenumberAsync] parsedResult: $parsedResult');
      returnResult.e164 = parsedResult['e164'];
      returnResult.formattedNumber = parsedResult['national'];
    } catch (e) {
      // print(e);
    }

    return returnResult;
  }
}

class FormatPhoneResult {
  String formattedNumber;
  String e164;

  @override
  String toString() {
    return 'FormatPhoneResult[formattedNumber: $formattedNumber, e164: $e164]';
  }
}

/// Ensure phone number has a leading `+` in it
String _ensureLeadingPlus(String phoneNumber) {
  var fixedNum = phoneNumber;
  if (fixedNum.isNotEmpty && fixedNum[0] != '+') {
    fixedNum = '+$fixedNum';
  }
  return fixedNum;
}
