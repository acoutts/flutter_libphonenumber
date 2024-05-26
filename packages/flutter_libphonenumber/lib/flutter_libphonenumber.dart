import 'package:flutter_libphonenumber_platform_interface/flutter_libphonenumber_platform_interface.dart';

export 'package:flutter_libphonenumber_platform_interface/flutter_libphonenumber_platform_interface.dart'
    show
        CountryManager,
        CountryWithPhoneCode,
        FormatPhoneResult,
        LibPhonenumberTextFormatter,
        PhoneMask,
        PhoneNumberFormat,
        PhoneNumberType;

@override
Future<Map<String, String>> format(
  final String phone,
  final String region,
) async {
  return FlutterLibphonenumberPlatform.instance.format(phone, region);
}

@override
Future<Map<String, CountryWithPhoneCode>> getAllSupportedRegions() async {
  return FlutterLibphonenumberPlatform.instance.getAllSupportedRegions();
}

@override
Future<Map<String, dynamic>> parse(
  final String phone, {
  final String? region,
}) async {
  return FlutterLibphonenumberPlatform.instance.parse(phone, region: region);
}

@override
Future<void> init({
  final Map<String, CountryWithPhoneCode> overrides = const {},
}) async {
  return FlutterLibphonenumberPlatform.instance.init(overrides: overrides);
}

String formatNumberSync(
  final String number, {
  final CountryWithPhoneCode? country,
  final PhoneNumberType phoneNumberType = PhoneNumberType.mobile,
  final PhoneNumberFormat phoneNumberFormat = PhoneNumberFormat.international,
  final bool removeCountryCodeFromResult = false,
  final bool inputContainsCountryCode = true,
}) {
  return FlutterLibphonenumberPlatform.instance.formatNumberSync(
    number,
    country: country,
    phoneNumberType: phoneNumberType,
    phoneNumberFormat: phoneNumberFormat,
    removeCountryCodeFromResult: removeCountryCodeFromResult,
    inputContainsCountryCode: inputContainsCountryCode,
  );
}

Future<FormatPhoneResult?> getFormattedParseResult(
  final String phoneNumber,
  final CountryWithPhoneCode country, {
  final PhoneNumberType phoneNumberType = PhoneNumberType.mobile,
  final PhoneNumberFormat phoneNumberFormat = PhoneNumberFormat.international,
}) async {
  return FlutterLibphonenumberPlatform.instance.getFormattedParseResult(
    phoneNumber,
    country,
    phoneNumberType: phoneNumberType,
    phoneNumberFormat: phoneNumberFormat,
  );
}
