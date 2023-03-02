// ignore_for_file: non_constant_identifier_names
@JS()
library libphonenumber;

import 'package:js/js.dart';

@JS()
external DisplayNames libPhoneNumberFlutterGetRegionDisplayNames(String lang);

@JS('Intl.DisplayNames')
class DisplayNames {
  external String of(String countryCode);
}

@JS('libphonenumber.PhoneNumber')
class PhoneNumber {
  external PhoneNumber();
  external String getCountryCode();
  external String getNationalNumber();
}

@JS('libphonenumber.PhoneNumberFormat')
class PhoneNumberFormat {
  external static int E164;
  external static int INTERNATIONAL;
  external static int NATIONAL;
  external static int RFC3966;
}

@JS('libphonenumber.PhoneNumberType')
class PhoneNumberType {
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

String numberTypeToString(int type) {
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
class AsYouTypeFormatter {
  external AsYouTypeFormatter(String? regionCode);
  external void clear();
  external String inputDigit(String char);
}

@JS('libphonenumber.PhoneNumberUtil')
class PhoneNumberUtil {
  external static PhoneNumberUtil getInstance();
  external Map<String, dynamic> getExampleNumber(String regionCode);
  external PhoneNumber parse(String phoneNumber, String? regionCode);
  external bool isValidNumber(PhoneNumber phoneNumber);
  external int getNumberType(PhoneNumber phoneNumber);
  external String format(PhoneNumber phoneNumber, int phoneNumberFormat);
  external String getRegionCodeForNumber(PhoneNumber phoneNumber);
  external List<String> getSupportedRegions();
  external int getCountryCodeForRegion(String? region);
  external PhoneNumber? getExampleNumberForType(String region, int type);
}

extension PhoneNumberUtilExt on PhoneNumberUtil {
  Map<String, String>? parseStringAndRegion(String phone, String? region) {
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
          'country_code': phoneNumber.getCountryCode(),
          'region_code': getRegionCodeForNumber(phoneNumber),
          'national_number': phoneNumber.getNationalNumber(),
        };
      }
    } catch (e) {
      return null;
    }
  }
}
