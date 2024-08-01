@JS()
library libphonenumber;

import 'dart:js_interop';

@JS()
external DisplayNames libPhoneNumberFlutterGetRegionDisplayNames(
  final String lang,
);

@JS('Intl.DisplayNames')
extension type DisplayNames._(JSObject _) implements JSObject {
  external String of(final String countryCode);
}

@JS('libphonenumber.PhoneNumber')
extension type PhoneNumber._(JSObject _) implements JSObject {
  external PhoneNumber();
  external int getCountryCode();
  external int getNationalNumber();
}

@JS('libphonenumber.PhoneNumberFormat')
extension type PhoneNumberFormat._(JSObject _) implements JSObject {
  external static int E164;
  external static int INTERNATIONAL;
  external static int NATIONAL;
  external static int RFC3966;
}

@JS('libphonenumber.PhoneNumberType')
extension type PhoneNumberType._(JSObject _) implements JSObject {
  external static int FIXED_LINE;
  external static int MOBILE;
  external static int FIXED_LINE_OR_MOBILE;
  external static int TOLL_FREE;
  external static int PREMIUM_RATE;
  external static int SHARED_COST;
  external static int VOIP;
  external static int PERSONAL_NUMBER;
  external static int PAGER;
  external static int UAN;
  external static int VOICEMAIL;
  external static int UNKNOWN;
}

String numberTypeToString(final int type) {
  switch (type) {
    case 0:
      return 'fixedLine';
    case 1:
      return 'mobile';
    case 2:
      return 'fixedOrMobile';
    case 3:
      return 'tollFree';
    case 4:
      return 'premiumRate';
    case 5:
      return 'sharedCost';
    case 6:
      return 'voip';
    case 7:
      return 'personalNumber';
    case 8:
      return 'pager';
    case 9:
      return 'uan';
    case 10:
      return 'voiceMail';
    case -1:
      return 'unknown';
    default:
      return 'notParsed';
  }
}

@JS('libphonenumber.AsYouTypeFormatter')
extension type AsYouTypeFormatter._(JSObject _) implements JSObject {
  external AsYouTypeFormatter(final String? regionCode);
  external void clear();
  external String inputDigit(final String char);
}

@JS('libphonenumber.PhoneNumberUtil')
extension type PhoneNumberUtil._(JSObject _) implements JSObject {
  external static PhoneNumberUtil getInstance();
  external JSObject getExampleNumber(final String regionCode);
  external PhoneNumber parse(
    final String phoneNumber,
    final String? regionCode,
  );
  external bool isValidNumber(final PhoneNumber phoneNumber);
  external int getNumberType(final PhoneNumber phoneNumber);
  external String format(
    final PhoneNumber phoneNumber,
    final int phoneNumberFormat,
  );
  external String getRegionCodeForNumber(final PhoneNumber phoneNumber);
  external JSArray<JSString> getSupportedRegions();
  external int getCountryCodeForRegion(final String? region);
  external PhoneNumber? getExampleNumberForType(
    final String region,
    final int type,
  );
}

extension PhoneNumberUtilExt on PhoneNumberUtil {
  Map<String, String>? parseStringAndRegion(
    final String phone,
    final String? region,
  ) {
    try {
      final phoneNumber = parse(phone, region);
      if (!isValidNumber(phoneNumber)) {
        return null;
      } else {
        return {
          'type': numberTypeToString(getNumberType(phoneNumber)),
          'e164': format(phoneNumber, PhoneNumberFormat.E164),
          'international': format(phoneNumber, PhoneNumberFormat.INTERNATIONAL),
          'national': format(phoneNumber, PhoneNumberFormat.NATIONAL),
          'country_code': '${phoneNumber.getCountryCode()}',
          'region_code': getRegionCodeForNumber(phoneNumber),
          'national_number': '${phoneNumber.getNationalNumber()}',
        };
      }
    } catch (e) {
      return null;
    }
  }
}
