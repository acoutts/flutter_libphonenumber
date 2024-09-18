import 'package:flutter_libphonenumber_platform_interface/src/method_channel/flutter_libphonenumber_method_channel.dart';
import 'package:flutter_libphonenumber_platform_interface/src/types/country_with_phone_code.dart';
import 'package:flutter_libphonenumber_platform_interface/src/types/format_phone_result.dart';
import 'package:flutter_libphonenumber_platform_interface/src/types/phone_mask.dart';
import 'package:flutter_libphonenumber_platform_interface/src/types/phone_number_format.dart';
import 'package:flutter_libphonenumber_platform_interface/src/types/phone_number_type.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class FlutterLibphonenumberPlatform extends PlatformInterface {
  /// Constructs a FlutterLibphonenumberPlatform.
  FlutterLibphonenumberPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterLibphonenumberPlatform _instance =
      MethodChannelFlutterLibphonenumber();

  /// The default instance of [FlutterLibphonenumberPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterLibphonenumber].
  static FlutterLibphonenumberPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterLibphonenumberPlatform] when
  /// they register themselves.
  static set instance(final FlutterLibphonenumberPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Return all available regions with their country code, phone code, and formatted
  /// example number as a mask. Useful to later format phone numbers using a mask.
  ///
  /// The response will be a [CountryWithPhoneCode]:
  ///
  /// There are some performance considerations for this so you might want to cache the
  /// result and re-use it elsewhere. There's a lot of data to iterate over.
  ///
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
  Future<Map<String, CountryWithPhoneCode>> getAllSupportedRegions() async {
    throw UnimplementedError(
      'getAllSupportedRegions() has not been implemented.',
    );
  }

  /// Formats a phone number using platform libphonenumber. Will return the parsed number.
  ///
  /// Example response:
  /// ```
  /// {
  ///   formatted: "1 (414) 444-4444",
  /// }
  /// ```
  Future<Map<String, String>> format(
    final String phone,
    final String region,
  ) async {
    throw UnimplementedError('format() has not been implemented.');
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
  Future<Map<String, dynamic>> parse(
    final String phone, {
    final String? region,
  }) async {
    throw UnimplementedError('parse() has not been implemented.');
  }

  /// Must call this before anything else so the countries data is populated.
  ///
  /// Optionally provide a map of overrides where the key is the country code
  /// (ex: `GB` or `US`) and the value is a `CountryWithPhoneCode` object
  /// that should replace the data pulled from libphonenumber. This is useful
  /// if you want to customize the mask data for a given country.
  Future<void> init({
    final Map<String, CountryWithPhoneCode> overrides = const {},
  }) async {
    throw UnimplementedError('init() has not been implemented.');
  }

  /// Given a phone number, format it automatically using the masks we have from
  /// libphonenumber's example numbers. Optionally override the country (instead
  /// of auto-detecting), the number type, format.
  ///
  /// Use [removeCountryCodeFromResult] to strip the country code from the result
  /// and set [inputContainsCountryCode] based on if the input contains a country
  /// code or not so the correct mask can be used.
  String formatNumberSync(
    final String number, {
    final CountryWithPhoneCode? country,
    final PhoneNumberType phoneNumberType = PhoneNumberType.mobile,
    final PhoneNumberFormat phoneNumberFormat = PhoneNumberFormat.international,
    final bool removeCountryCodeFromResult = false,
    final bool inputContainsCountryCode = true,
  }) {
    final guessedCountry =
        country ?? CountryWithPhoneCode.getCountryDataByPhone(number);

    if (guessedCountry == null) {
      return number;
    }

    var formatResult = PhoneMask(
      mask: guessedCountry.getPhoneMask(
        format: phoneNumberFormat,
        type: phoneNumberType,
        removeCountryCodeFromMask: !inputContainsCountryCode,
      ),
      country: guessedCountry,
    ).apply(number);

    /// Remove the country code from the result if the user set removeCountryCodeFromResult=true.
    /// Take a substring of the phone code length + 2 to account for leading `+` and space between
    /// country code and the number.
    if (removeCountryCodeFromResult && inputContainsCountryCode) {
      formatResult =
          formatResult.substring(guessedCountry.phoneCode.length + 2);
    }

    return formatResult;
  }

  /// Asynchronously formats a number, returning the e164 and the number's requested format
  /// result by specifying a [PhoneNumberType] and [PhoneNumberFormat].
  ///
  /// If the number is invalid or cannot be parsed, it will return a null result.
  Future<FormatPhoneResult?> getFormattedParseResult(
    final String phoneNumber,
    final CountryWithPhoneCode country, {
    final PhoneNumberType phoneNumberType = PhoneNumberType.mobile,
    final PhoneNumberFormat phoneNumberFormat = PhoneNumberFormat.international,
  }) async {
    try {
      /// Try to parse the number and get our result
      final res = await parse(
        phoneNumber,
        region: country.countryCode,
      );

      late final String formattedNumber;
      if (phoneNumberFormat == PhoneNumberFormat.international) {
        formattedNumber = res['international'] ?? '';
      } else if (phoneNumberFormat == PhoneNumberFormat.national) {
        formattedNumber = res['national'] ?? '';
      } else {
        /// Should never happen
        formattedNumber = '';
      }

      /// Now construct the return value based on the requested format/type.
      return FormatPhoneResult(
        e164: res['e164'] ?? '',
        formattedNumber: formattedNumber,
      );
    } catch (e) {
      // print(e);
    }

    return null;
  }
}
