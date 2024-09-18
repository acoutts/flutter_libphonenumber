import 'package:flutter_libphonenumber_platform_interface/src/types/country_manager.dart';
import 'package:flutter_libphonenumber_platform_interface/src/types/country_with_phone_code.dart';
import 'package:flutter_libphonenumber_platform_interface/src/types/input_formatter.dart';
import 'package:flutter_libphonenumber_platform_interface/src/types/phone_mask.dart';
import 'package:flutter_libphonenumber_platform_interface/src/types/phone_number_format.dart';
import 'package:flutter_libphonenumber_platform_interface/src/types/phone_number_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PhoneMask', () {
    test('UK mobile international', () {
      final mask = PhoneMask(
        mask: const CountryWithPhoneCode.gb().getPhoneMask(
          format: PhoneNumberFormat.international,
          type: PhoneNumberType.mobile,
        ),
        country: const CountryWithPhoneCode.gb(),
      );
      expect(mask.apply('+447752555555'), '+44 7752 555555');
    });

    test('Italian mobile international', () {
      final mask = PhoneMask(
        mask: '+00 000 000 0000',
        country: CountryWithPhoneCode(
          phoneCode: '+39',
          countryCode: '',
          exampleNumberMobileNational: '',
          exampleNumberFixedLineNational: '',
          phoneMaskMobileNational: '',
          phoneMaskFixedLineNational: '',
          exampleNumberMobileInternational: '',
          exampleNumberFixedLineInternational: '',
          phoneMaskMobileInternational: '',
          phoneMaskFixedLineInternational: '',
          countryName: '',
        ),
      );
      expect(mask.apply('+393937224790'), '+39 393 722 4790');
    });

    group('getCountryDataByPhone', () {
      test('US number', () async {
        await CountryManager().loadCountries(
          phoneCodesMap: {},
          overrides: {'US': const CountryWithPhoneCode.us()},
        );

        final res = CountryWithPhoneCode.getCountryDataByPhone('+14194444444');
        expect(res?.countryCode, 'US');
      });
    });
  });

  group('getPhoneMask', () {
    test('with removeCountryCodeFromMask=false', () async {
      final res = const CountryWithPhoneCode.us().getPhoneMask(
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
      final res = const CountryWithPhoneCode.us().getPhoneMask(
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

    test(
        'with phoneNumberFormat=PhoneNumberFormat.national and phoneNumberType=PhoneNumberType.mobile',
        () async {
      final res = PhoneMask(
        mask: const CountryWithPhoneCode.us().getPhoneMask(
          format: PhoneNumberFormat.national,
          type: PhoneNumberType.mobile,
        ),
        country: const CountryWithPhoneCode.us(),
      );
      final applied = res.apply('+14194444444');

      expect(
        applied,
        '(419) 444-4444',
        reason: 'mask should not contain country code in it',
      );
    });

    test(
        'with phoneNumberFormat=PhoneNumberFormat.international and phoneNumberType=PhoneNumberType.mobile',
        () async {
      final res = PhoneMask(
        mask: const CountryWithPhoneCode.us().getPhoneMask(
          format: PhoneNumberFormat.international,
          type: PhoneNumberType.mobile,
        ),
        country: const CountryWithPhoneCode.us(),
      );
      final applied = res.apply('+14194444444');

      expect(
        applied,
        '+1 419-444-4444',
        reason: 'mask should not contain country code in it',
      );
    });
  });

  group('LibPhonenumberTextFormatter', () {
    test('with inputContainsCountryCode=true', () {
      final formatter = LibPhonenumberTextFormatter(
        country: const CountryWithPhoneCode.us(),
        inputContainsCountryCode: true,
      );

      final formatResult = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '+14194444444'),
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
        country: const CountryWithPhoneCode.us(),
        inputContainsCountryCode: false,
      );

      final formatResult = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '4194444444'),
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
