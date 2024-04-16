import 'package:dlibphonenumber/dlibphonenumber.dart';
// import 'package:collection/collection.dart'; // firstWhereOrNull extension
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_libphonenumber_platform_interface/flutter_libphonenumber_platform_interface.dart';

/// Original method CountryWithPhoneCode.getCountryDataByPhone(phone)
/// has bad implementation because it based in substring comparison.
///
/// For example for USA numbers it returns Bahamas, because these countries has same prefix
/// but Bahamas is alphabetically first
CountryWithPhoneCode? recognizeCountryDataByPhone(final String phone) {
  // working with dlibphonenumber
  final PhoneNumberUtil phoneUtil = PhoneNumberUtil.instance;
  final PhoneNumber number;
  try {
    number = phoneUtil.parse(phone, 'ZZ');
  } on NumberParseException catch (e) {
    if (kDebugMode) print('NumberParseException was thrown: ${e.toString()}');
    return null;
  }

  // working with flutter_libphonenumber
  final String? regionCode = phoneUtil.getRegionCodeForNumber(number);
  // print('regionCode: $regionCode');
  if (regionCode != null) {
    final country = CountryManager().countries.firstWhereOrNull((country) => country.countryCode == regionCode);
    return country;
  }
  return null;
}
