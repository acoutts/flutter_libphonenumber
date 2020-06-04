import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_libphonenumber/src/country_data.dart';
import 'package:flutter_libphonenumber/src/input_formatter.dart';
export 'package:flutter_libphonenumber/src/input_formatter.dart';

class FlutterLibphonenumber {
  static final FlutterLibphonenumber _instance =
      FlutterLibphonenumber._internal();
  factory FlutterLibphonenumber() => _instance;
  FlutterLibphonenumber._internal();

  /// Method channel
  MethodChannel _channel = const MethodChannel('flutter_libphonenumber');

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

  Future<Map<String, dynamic>> format(String phone, String region) {
    return _channel.invokeMapMethod<String, dynamic>("format", {
      "phone": phone,
      "region": region,
    });
  }

  /// Parse a single string and return a map in the format below.
  ///
  /// Given a passed [string] or '+4930123123123', the response will be:
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
      "phone": phone,
      "region": region,
    });
  }

  /// Given a phone number, format it automatically using the masks we have
  /// from libphonenumber's example numbers.
  String formatPhone(String phone) {
    return LibPhonenumberTextFormatter()
        .formatEditUpdate(
            TextEditingValue(text: ''), TextEditingValue(text: phone))
        .text;
  }
}
