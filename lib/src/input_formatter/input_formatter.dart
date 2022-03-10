import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:flutter_libphonenumber/src/input_formatter/phone_mask.dart';

class LibPhonenumberTextFormatter extends TextInputFormatter {
  LibPhonenumberTextFormatter({
    required this.country,
    this.phoneNumberType = PhoneNumberType.mobile,
    this.phoneNumberFormat = PhoneNumberFormat.international,
    this.onFormatFinished,

    /// When true, mask will be applied assuming the input contains
    /// a country code in it.
    bool inputContainsCountryCode = false,

    /// Additional digits to include
    this.additionalDigits = 0,

    /// Force cursor the end of input when formatting.
    this.shouldKeepCursorAtEndOfInput = true,
  }) : countryData = CountryManager().countries {
    var m = country.getPhoneMask(
      format: phoneNumberFormat,
      type: phoneNumberType,
      removeCountryCodeFromMask: !inputContainsCountryCode,
    );

    /// Allow additional digits on the mask
    if (additionalDigits > 0) {
      m += List.filled(additionalDigits, '0').reduce((a, b) => a + b);
    }

    _mask = PhoneMask(m);
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

  /// When shouldKeepCursorAtEndOfInput is true, the cursor will be forced to the end of the input after a format happened. Will default to true,
  final bool shouldKeepCursorAtEndOfInput;

  late final PhoneMask _mask;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    /// Apply mask to the input
    final newMaskedValue = _mask.apply(newValue.text);
    if (!shouldKeepCursorAtEndOfInput) {
      //In case of a longer newValue
      if (oldValue.text.length < newValue.text.length) {
        var newValueBeforeCursor =
            newMaskedValue.substring(0, newValue.selection.baseOffset);

        final oldValueBeforeCursor =
            oldValue.text.substring(0, oldValue.selection.baseOffset);

        if (!newValueBeforeCursor.endsWith('-')) {
          newValueBeforeCursor = newValueBeforeCursor.substring(
              0, newValueBeforeCursor.length - 1);
        }

        final beforeCursorLengthDiff =
            newValueBeforeCursor.length - oldValueBeforeCursor.length;

        /// Optionally pass the formatted value to the supplied callback
        if (onFormatFinished != null) {
          onFormatFinished!(newMaskedValue);
        }
        return TextEditingValue(
          selection: TextSelection.collapsed(
            offset: oldValue.selection.baseOffset +
                (newValue.text.length - oldValue.text.length) +
                beforeCursorLengthDiff,
          ),
          text: newMaskedValue,
        );
      }
      //In this case characters got deleted
      else if (oldValue.text.length > newValue.text.length) {
        if (oldValue.selection.baseOffset == oldValue.text.length) {
          return TextEditingValue(
            selection: TextSelection.collapsed(
              offset: newMaskedValue.length,
            ),
            text: newMaskedValue,
          );
        }
        return TextEditingValue(
          selection: TextSelection.collapsed(
            offset: (oldValue.selection.baseOffset < newMaskedValue.length)
                ? oldValue.selection.baseOffset - 1
                : newMaskedValue.length - 1,
          ),
          text: newMaskedValue,
        );
      }
      // In the case length remained the same (probably because of paste)
      else {
        return TextEditingValue(
          selection: TextSelection.collapsed(
            offset: newMaskedValue.length,
          ),
          text: newMaskedValue,
        );
      }
    } else {
      return TextEditingValue(
        selection: TextSelection.collapsed(
          offset: newMaskedValue.length,
        ),
        text: newMaskedValue,
      );
    }
  }
}
