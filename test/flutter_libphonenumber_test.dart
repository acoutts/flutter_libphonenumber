import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:flutter_libphonenumber/src/input_formatter/phone_mask.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PhoneMask', () {
    test('UK mobile international', () {
      final mask = PhoneMask(
        CountryWithPhoneCode.gb().getPhoneMask(
              format: PhoneNumberFormat.international,
              type: PhoneNumberType.mobile,
            ) ??
            '',
      );
      expect(mask.apply('+447752513731'), '+44 7752 513731');
    });

    test('Italian mobile international', () {
      final mask = PhoneMask('+00 000 000 0000');
      expect(mask.apply('+393937224790'), '+39 393 722 4790');
    });

    test('Austrian 11 character number', () {
      final mask = PhoneMask('+00 000 000 0000');
      expect(mask.apply('+393937224790'), '+39 393 722 4790');
    });

    group('getCountryDataByPhone', () {
      test('US number', () async {
        await CountryManager().loadCountries(overrides: {
          'US': CountryWithPhoneCode.us(),
        });

        final res = CountryWithPhoneCode.getCountryDataByPhone('+14199139457');
        expect(res?.countryCode, 'US');
      });

      test('US number without code', () async {
        await CountryManager().loadCountries(overrides: {
          'US': CountryWithPhoneCode.us(),
        });

        final res = FlutterLibphonenumber().formatNumberSync('+14199139457', removeCountryCode: true);
        expect(res, '419-913-9457');
      });

      test('US number with code', () async {
        await CountryManager().loadCountries(overrides: {
          'US': CountryWithPhoneCode.us(),
        });

        final res = FlutterLibphonenumber().formatNumberSync('+14199139457', removeCountryCode: false);
        expect(res, '+1 419-913-9457');
      });
    });
  });
}
