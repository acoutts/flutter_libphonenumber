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
    late final TextEditingValue result;

    try {
      /// Apply mask to the input
      final newMaskedValue = _mask.apply(newValue.text);

      /// Optionally pass the formatted value to the supplied callback
      if (onFormatFinished != null) {
        onFormatFinished!(newMaskedValue);
      }

      /// Force the cursor to the end of the input
      if (shouldKeepCursorAtEndOfInput) {
        result = TextEditingValue(
          selection: TextSelection.collapsed(
            offset: newMaskedValue.length,
          ),
          text: newMaskedValue,
        );
        return result;
      }

      /// After formatting, put the cursor at the same point it was
      /// at before formatting, within the input. It will put the cursor
      /// after the last character added or if a character was removed
      /// it puts it after the character in front of the one removed.

      //In case of a longer newValue
      if (oldValue.text.length < newValue.text.length &&
          oldValue.text.isNotEmpty) {
        var newValueBeforeCursor =
            newMaskedValue.substring(0, newValue.selection.baseOffset);

        final oldValueBeforeCursor =
            oldValue.text.substring(0, oldValue.selection.baseOffset);

        // print(
        //     '>> longer string | newValueBeforeCursor: "$newValueBeforeCursor" | oldValueBeforeCursor: "$oldValueBeforeCursor"');

        if (!newValueBeforeCursor.endsWith('-') &&
            !(newValueBeforeCursor.endsWith(' '))) {
          // print('subtracting one');
          newValueBeforeCursor = newValueBeforeCursor.substring(
            0,
            newValueBeforeCursor.length - 1,
          );
        }

        final beforeCursorLengthDiff =
            newValueBeforeCursor.length - oldValueBeforeCursor.length;

        result = TextEditingValue(
          selection: TextSelection.collapsed(
            offset: oldValue.selection.baseOffset +
                (newValue.text.length - oldValue.text.length) +
                beforeCursorLengthDiff,
          ),
          text: newMaskedValue,
        );
        return result;
      }
      // In this case characters got deleted
      else if (oldValue.text.length > newValue.text.length) {
        print(
            '>> shorter string | oldValue.selection.baseOffset: ${oldValue.selection.baseOffset} | oldValue.text.length: ${oldValue.text.length}');

        if (oldValue.selection.isCollapsed) {
          /// We deleted a single character from somewhere in the string
          if (oldValue.selection.baseOffset == oldValue.text.length) {
            /// This happens when we delete the character off the end of the string.
            result = TextEditingValue(
              selection: TextSelection.collapsed(
                offset: newMaskedValue.length,
              ),
              text: newMaskedValue,
            );
            return result;
          } else {
            /// This happens when we delete one character in the middle of the string
            result = TextEditingValue(
              selection: TextSelection.collapsed(
                offset: oldValue.selection.baseOffset - 1,
              ),
              text: newMaskedValue,
            );
            return result;
          }
        } else {
          /// Put a collapsed selection at the area where we removed those X characters
          result = TextEditingValue(
            selection: TextSelection.collapsed(
              offset: newValue.selection.baseOffset,
            ),
            text: newMaskedValue,
          );
          return result;
        }
      }
      // In the case length remained the same
      // Can happen if we select and replace part of the string either pasting or typing the value
      // Ex: select 1 character, type a new one
      // Ex: select 3 characters, paste 3 new ones
      else {
        print('>> same length string');

        result = TextEditingValue(
          selection: TextSelection.collapsed(
            offset: newValue.selection.baseOffset,
          ),
          text: newMaskedValue,
        );
        return result;
      }
    } finally {
      print(
        '>> oldValue: $oldValue\n>> newValue: $newValue\n>> result: $result',
      );
    }
  }
}
