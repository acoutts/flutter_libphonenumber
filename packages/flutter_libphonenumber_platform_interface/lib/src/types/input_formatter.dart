import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_libphonenumber_platform_interface/flutter_libphonenumber_platform_interface.dart';
import 'package:flutter_libphonenumber_platform_interface/src/types/recognize_country_data_by_phone.dart';

class LibPhonenumberTextFormatter extends TextInputFormatter {
  LibPhonenumberTextFormatter({
    required this.country,
    this.phoneNumberType = PhoneNumberType.mobile,
    this.phoneNumberFormat = PhoneNumberFormat.international,
    this.onFormatFinished,
    this.onCountryRecognized,
    this.inputContainsCountryCode = false,

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
      m += List.filled(additionalDigits, '0')
          .reduce((final a, final b) => a + b);
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

  /// Optional callback that is called when it is possible to recognize the country as a result
  /// of selecting a phone number from OS autofill suggestions or pasting from the clipboard
  final void Function(CountryWithPhoneCode country)? onCountryRecognized;

  /// When true, mask will be applied assuming the input contains a country code in it.
  final bool inputContainsCountryCode;

  /// Allow additional digits on the end of the mask. This is useful for countries like Austria where the
  /// libphonenumber example number doesn't include all of the possibilities. This way we can still format
  /// the number but allow additional digits on the end.
  final int additionalDigits;

  /// When shouldKeepCursorAtEndOfInput is true, the cursor will be forced to the end of the input after a format happened. Will default to true,
  final bool shouldKeepCursorAtEndOfInput;

  late final PhoneMask _mask;

  @override
  TextEditingValue formatEditUpdate(
    final TextEditingValue oldValue,
    final TextEditingValue newValue,
  ) {

    /// First, let's try to recognize the whole number
    final recognizedValue = _tryRecognizePhoneWithCountry(oldValue, newValue);
    if (recognizedValue != null) {
      return recognizedValue;
    }


    late final TextEditingValue result;

    /// Apply mask to the input
    final newMaskedValue = _mask.apply(newValue.text);

    /// Optionally pass the formatted value to the supplied callback
    if (onFormatFinished != null) {
      onFormatFinished!.call(newMaskedValue);
    }

    // print('>> oldValue: $oldValue\n>> newValue: $newValue\n');

    /// Force the cursor to the end of the input if requested
    if (shouldKeepCursorAtEndOfInput) {
      result = TextEditingValue(
        selection: TextSelection.collapsed(
          offset: newMaskedValue.length,
        ),
        text: newMaskedValue,
      );
      // print('>> result: $result');
      return result;
    }

    /// True if the new input ends with a non-digit value
    final endsWithNonNumber = RegExp(r'^.*(\D)$').hasMatch(newValue.text);

    if (newValue.text.length > oldValue.text.length) {
      ///////////////////////////////////
      /// Character(s) added
      ///
      /// Ex: We typed in a new digit
      /// Ex: We pasted in a longer value over an existing selection
      ///////////////////////////////////

      // print(
      //     '>> longer string | oldValue.selection.baseOffset: ${oldValue.selection.baseOffset} | oldValue.text.length: ${oldValue.text.length}');

      /// We have to account for any new non-digit characters added to the string.
      /// Say we have a current value of: "+1 444-867" and we add a new digit (9).
      /// newValue is then "+1 444-8679" but newMaskedValue is "+1 444-867-9".
      /// The baseOffset in newValue would be off by 1 because the mask added a new dash.
      final charsInOld = RegExp(r'(\D+)').allMatches(oldValue.text).length;
      final charsInNew = RegExp(r'(\D+)').allMatches(newMaskedValue).length;
      final charsAdded = charsInNew - charsInOld;

      // print('>> charsInOld: $charsInOld | charsInNew = $charsInNew');

      result = TextEditingValue(
        selection: TextSelection.collapsed(
          offset: min(
            newMaskedValue.length, // don't go more than the end of the string
            newValue.selection.baseOffset + charsAdded,
          ),
        ),
        text: newMaskedValue,
      );
      // print('>> result: $result');
      return result;
    } else if (newValue.text.length < oldValue.text.length) {
      ///////////////////////////////////
      /// Character(s) removed
      ///
      /// Ex: We deleted one character with backspace
      /// Ex: We pasted a shorter value over an existing selection
      ///////////////////////////////////

      // print(
      //   '>> shorter string | oldValue.selection.baseOffset: ${oldValue.selection.baseOffset} | oldValue.text.length: ${oldValue.text.length}',
      // );

      if (oldValue.selection.isCollapsed) {
        /// A collapsed selection means it's just a cursor with nothing selected.

        // print('>> oldValue.selection.isCollapsed');

        if (oldValue.selection.baseOffset == oldValue.text.length) {
          /// We deleted a character from the end of the string. In that case just put the cursor
          /// at the end of the new string.

          // print('>> oldValue.selection.baseOffset == oldValue.text.length');

          result = TextEditingValue(
            selection: TextSelection.collapsed(
              offset: newMaskedValue.length,
            ),
            text: newMaskedValue,
          );
          // print('>> result: $result');
          return result;
        } else {
          /// We deleted a character from somewhere within the string. We have to put the cursor
          /// where it was before.

          // print('>> oldValue.selection.baseOffset != oldValue.text.length');

          result = TextEditingValue(
            selection: TextSelection.collapsed(
              offset: oldValue.selection.baseOffset - 1,
            ),
            text: newMaskedValue,
          );
          // print('>> result: $result');
          return result;
        }
      } else {
        /// A non-collapsed selection means there's one or more characters selected.
        /// We have to put the cursor at the end of the new value inputted.

        // print('>> oldValue.selection.isNotCollapsed');

        result = TextEditingValue(
          selection: TextSelection.collapsed(
            offset: newValue.selection.baseOffset - (endsWithNonNumber ? 1 : 0),
          ),
          text: newMaskedValue,
        );
        // print('>> result: $result');
        return result;
      }
    } else {
      ///////////////////////////////////
      /// Character(s) replaced
      ///
      /// In the case length remained the same
      /// Can happen if we select and replace part of the string either pasting or typing the value
      /// Ex: select 1 character, type a new one
      /// Ex: select 3 characters, paste 3 new ones
      ///////////////////////////////////

      // print('>> same length string');

      result = TextEditingValue(
        selection: TextSelection.collapsed(
          offset: newValue.selection.baseOffset - (endsWithNonNumber ? 1 : 0),
        ),
        text: newMaskedValue,
      );
      // print('>> result: $result');
      return result;
    }
  }

  /// Recognizes phone from iOS suggestions or clipboard
  TextEditingValue? _tryRecognizePhoneWithCountry(
    final TextEditingValue oldValue,
    final TextEditingValue newValue,
  ) {
    // user tapped on suggested phone or pasted from clipboard
    // but this not sure, so we have additional checks inside
    final seemsUserTappedSuggestionOrPasted = oldValue.text.isEmpty && newValue.text.length > 1 && newValue.text.startsWith('+');

    if (seemsUserTappedSuggestionOrPasted) {
      final CountryWithPhoneCode? recognizedCountry = recognizeCountryDataByPhone(newValue.text);
      if (recognizedCountry != null) {
        // build mask for recognized country
        final rawMask = recognizedCountry.getPhoneMask(format: phoneNumberFormat, type: phoneNumberType, removeCountryCodeFromMask: false);
        // print('  mask: $rawMask');
        final mask = PhoneMask(rawMask);

        // apply mask to the input
        var maskedStr = mask.apply(newValue.text);
        // print('masked: $maskedStr');

        // tell parent code what we recognized country
        // it can be used for update flag or prefix in another widget
        onCountryRecognized?.call(recognizedCountry);

        // remove country code from already masked string
        // 2 means one for the leading + and one for the space between country code and number
        if (!inputContainsCountryCode) {
          maskedStr = maskedStr.substring(recognizedCountry.phoneCode.length + 2);
        }

        return TextEditingValue(
          text: maskedStr,
          selection: TextSelection.collapsed(offset: maskedStr.length), // force cursor to the end
        );
      }
    }

    return null;
  }
}
