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
  /// The response will be:
  /// ```
  /// {
  ///   "US": {
  ///     "phoneCode": "1",
  ///     "phoneMask": "+0 (000) 000-0000"
  ///   }
  /// }
  /// ```
  ///
  /// There are some performance considerations for this so you might want to cache the
  /// result and re-use it in the future.
  Future<Map<String, dynamic>> getAllSupportedRegions() async {
    return await _channel
        .invokeMapMethod<String, dynamic>("get_all_supported_regions");
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
  String formatNumberSync(String phone) {
    return LibPhonenumberTextFormatter()
        .formatEditUpdate(
            TextEditingValue(text: ''), TextEditingValue(text: phone))
        .text;
  }

  /// Asynchronously formats a phone number with libphonenumber. Will return the formatted number
  /// and if it's a valid/complete number, will return the e164 value as well. Uses libphonenumber's
  /// parse function to verify if it's a valid number or not.
  Future<FormatPhoneResult> formatParsePhonenumberAsync(
      String phoneNumber, CountryWithPhoneCode country) async {
    // print(
    //     '[formatPhoneWithCountry] phoneNumber: \'$phoneNumber\' | country: ${country.countryCode}');

    /// What we will return
    final returnResult = FormatPhoneResult();

    /// Format the number with AsYouType
    final formattedResult = await FlutterLibphonenumber()
        .format(toNumericString(phoneNumber), country.countryCode);
    returnResult.formattedNumber = formattedResult['formatted'];
    // print('formatted: ${formattedResult['formatted']}');

    /// Try to parse the number to update our e164
    try {
      final parsedResult =
          await parse('+${country.phoneCode}${toNumericString(phoneNumber)}');
      // print('parsedResult: $parsedResult');
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
}

/// Ensure phone number has a leading `+` in it
String _ensureLeadingPlus(String phoneNumber) {
  var fixedNum = phoneNumber;
  if (fixedNum.isNotEmpty && fixedNum[0] != '+') {
    fixedNum = '+$fixedNum';
  }
  return fixedNum;
}
