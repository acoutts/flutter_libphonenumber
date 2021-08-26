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
        ),
      );
      expect(mask.apply('+447752555555'), '+44 7752 555555');
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
        await CountryManager().loadCountries(
          overrides: {'US': CountryWithPhoneCode.us()},
        );

        final res = CountryWithPhoneCode.getCountryDataByPhone('+14194444444');
        expect(res?.countryCode, 'US');
      });
    });
  });

  group('getPhoneMask', () {
    test('with removeCountryCodeFromMask=false', () async {
      final res = CountryWithPhoneCode.us().getPhoneMask(
        format: PhoneNumberFormat.international,
        type: PhoneNumberType.mobile,
        removeCountryCodeFromMask: false,
      );

      expect(
        res,
        '+0 000-000-0000',
        reason: 'mask should contain country code in it',
      );
    });

    test('with removeCountryCodeFromMask=true', () async {
      final res = CountryWithPhoneCode.us().getPhoneMask(
        format: PhoneNumberFormat.international,
        type: PhoneNumberType.mobile,
        removeCountryCodeFromMask: true,
      );

      expect(
        res,
        '000-000-0000',
        reason: 'mask should not contain country code in it',
      );
    });
  });

  group('LibPhonenumberTextFormatter', () {
    test('with inputContainsCountryCode=true', () {
      final formatter = LibPhonenumberTextFormatter(
        country: CountryWithPhoneCode.us(),
        inputContainsCountryCode: true,
      );

      final formatResult = formatter.formatEditUpdate(
        TextEditingValue(text: ''),
        TextEditingValue(text: '+14194444444'),
      );

      expect(
        formatResult.text,
        '+1 419-444-4444',
        reason:
            'formatting with a country code should apply the mask with the country code in it',
      );
    });

    test('with inputContainsCountryCode=false', () {
      final formatter = LibPhonenumberTextFormatter(
        country: CountryWithPhoneCode.us(),
        inputContainsCountryCode: false,
      );

      final formatResult = formatter.formatEditUpdate(
        TextEditingValue(text: ''),
        TextEditingValue(text: '4194444444'),
      );

      expect(
        formatResult.text,
        '419-444-4444',
        reason:
            'formatting with a country code should apply the mask with the country code in it',
      );
    });
  });
}
