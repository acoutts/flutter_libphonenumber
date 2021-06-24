import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:flutter_libphonenumber/src/country_data.dart';
import 'package:flutter_libphonenumber/src/input_formatter/phone_mask.dart';
import 'package:flutter_libphonenumber/src/phone_number_format.dart';
import 'package:flutter_libphonenumber/src/phone_number_type.dart';

class LibPhonenumberTextFormatter extends TextInputFormatter {
  LibPhonenumberTextFormatter({
    required this.country,
    this.phoneNumberType = PhoneNumberType.mobile,
    this.phoneNumberFormat = PhoneNumberFormat.international,
    this.onFormatFinished,

    /// When true, mask will be applied to input assuming the country
    /// code is not present in the input.
    bool hideCountryCode = false,

    /// Additional digits to include
    this.additionalDigits = 0,
  }) : this.countryData = CountryManager().countries {
    var m = country.getPhoneMask(
      format: phoneNumberFormat,
      type: phoneNumberType,
      maskWithoutCountryCode: hideCountryCode,
    );

    /// Allow additional digits on the mask
    if (m != null && additionalDigits > 0) {
      m += List.filled(additionalDigits, '0').reduce((a, b) => a + b);
    }

    _mask = PhoneMask(m ?? '');
  }

  /// The country to format this number with.
  final CountryWithPhoneCode country;

  /// Optionally override the country data. Useful for testing.
  List<CountryWithPhoneCode>? countryData;

  /// Specify if the number should be formatted as a mobile or land line number. Will default to [PhoneNumberType.mobile]
  final PhoneNumberType phoneNumberType;

  /// Specify if the number should be formatted to its national or international pattern. Will default to [PhoneNumberFormat.international]
  final PhoneNumberFormat phoneNumberFormat;

  /// Optional function to execute after we are finished formatting the number.
  /// Useful if you need to get the formatted value for something else to use.
  final FutureOr Function(String val)? onFormatFinished;

  /// Allow additional digits on the end of the mask. This is useful for countries like Austria where the
  /// libphonenumber example number doesn't include all of the possibilities. This way we can still format
  /// the number but allow additional digits on the end.
  final int additionalDigits;

  late final PhoneMask _mask;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    /// Apply mask to the input
    String maskedValue = _mask.apply(newValue.text);

    /// Optionally pass the formatted value to the supplied callback
    if (onFormatFinished != null) {
      onFormatFinished!(maskedValue);
    }

    return TextEditingValue(
      selection: TextSelection.collapsed(offset: maskedValue.length),
      text: maskedValue,
    );
  }
}
