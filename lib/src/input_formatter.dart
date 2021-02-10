/*
(c) Copyright 2020 Serov Konstantin.

Licensed under the MIT license:

    http://www.opensource.org/licenses/mit-license.php

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:flutter_libphonenumber/src/country_data.dart';

class LibPhonenumberTextFormatter extends TextInputFormatter {
  LibPhonenumberTextFormatter({
    this.onCountrySelected,
    this.overrideSkipCountryCode = '',
    this.onFormatFinished,
    this.phoneNumberType = PhoneNumberType.mobile,
    this.phoneNumberFormat = PhoneNumberFormat.international,
  });

  /// Specify if the number should be formatted as a mobile or land line number. Will default to [PhoneNumberType.mobile]
  final PhoneNumberType phoneNumberType;

  /// Specify if the number should be formatted to its national or international pattern. Will default to [PhoneNumberFormat.international]
  final PhoneNumberFormat phoneNumberFormat;

  /// Will be called with the selected country once the formatter determines the country
  /// from the leading country code that was inputted.
  final ValueChanged<CountryWithPhoneCode?>? onCountrySelected;

  /// When this is supplied then we will format the number using the
  /// supplied country code and mask with the country code removed.
  /// This is useful if you have the country code being selected
  /// in another text box and just need to format the number without
  /// its country code in it.
  final String overrideSkipCountryCode;

  /// Optional function to execute after we are finished formatting the number
  final FutureOr Function(String val)? onFormatFinished;

  CountryWithPhoneCode? _countryData;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    /// Will be true if teh new value is shorter than the last one
    var isErasing = newValue.text.length < oldValue.text.length;
    if (isErasing) {
      if (newValue.text.isEmpty) {
        _clearCountry();
      }

      /// Optionally pass the formatted value to the supplied callback
      if (onFormatFinished != null) {
        onFormatFinished!(newValue.text);
      }
      return newValue;
    }
    final onlyNumbers = toNumericString(newValue.text);
    String maskedValue = _applyMask(onlyNumbers);

    /// Optionally pass the formatted value to the supplied callback
    if (onFormatFinished != null) {
      onFormatFinished!(maskedValue);
    }

    return TextEditingValue(
        selection: TextSelection.collapsed(offset: maskedValue.length),
        text: maskedValue);
  }

  /// this is a small dirty hack to be able to remove the first character
  Future _clearCountry() async {
    await Future.delayed(Duration(milliseconds: 5));
    _updateCountryData(null);
  }

  void _updateCountryData(CountryWithPhoneCode? countryData) {
    _countryData = countryData;
    if (onCountrySelected != null) {
      onCountrySelected!(_countryData);
    }
  }

  String _applyMask(String numericString) {
    CountryWithPhoneCode? countryData;

    if (overrideSkipCountryCode.isNotEmpty) {
      /// If the user specified the country code, we will use that one directly.
      try {
        countryData = CountryManager().countries.firstWhere(
            (element) => element.countryCode == overrideSkipCountryCode);

        /// Since the source isn't going to have a country code in it, add the right country
        /// code, run it through the mask, and then take the result and return it with the
        /// country code removed.
        ///
        /// If the number coming in already starts with the country code then don't add the
        /// country code in again.
        String numericStringWithCountryCode;
        if (phoneNumberFormat == PhoneNumberFormat.international &&
            !numericString.startsWith(countryData.phoneCode)) {
          numericStringWithCountryCode =
              '${countryData.phoneCode}$numericString';
        } else {
          numericStringWithCountryCode = numericString;
        }

        /// Fix to remove leading zero on UK international numbers so the mask will work.
        /// An example UK mobile international number is `+44 7400 123456` but generally
        /// people express national numbers like this: `07400 123456`. So anyone who pastes
        /// in a national format to an international field, the number will be truncated.
        if (countryData.countryCode == 'GB' && numericString.length > 2) {
          numericStringWithCountryCode =
              numericStringWithCountryCode.replaceFirst('440', '44', 0);
        }

        var mask = countryData.getPhoneMask(
            format: phoneNumberFormat, type: phoneNumberType);

        if (phoneNumberFormat == PhoneNumberFormat.national) {
          mask = '+${countryData.phoneCode} $mask';
        }

        final maskedResult = _formatByMask(
          numericStringWithCountryCode,
          mask,
        );

        /// Since we are overriding the country code, trim off the country code. We
        /// trim it by the length of the phone code + 1 for the leading plus sign and
        /// then trim off any leading/trailing spaces if necessary.
        return maskedResult.substring(countryData.phoneCode.length + 1).trim();
      } on StateError catch (_) {
        //
      }
    } else {
      /// Otherwise we will try to determine the country from the nubmer input so far
      if (numericString.isEmpty) {
        _updateCountryData(null);
      } else {
        final countryData =
            CountryWithPhoneCode.getCountryDataByPhone(numericString);
        if (countryData != null) {
          _updateCountryData(countryData);
        }
      }
      if (_countryData != null) {
        var mask = _countryData!
            .getPhoneMask(format: phoneNumberFormat, type: phoneNumberType);

        if (phoneNumberFormat == PhoneNumberFormat.national) {
          mask = '+${_countryData!.phoneCode} $mask';
        }

        return _formatByMask(
          numericString.substring(
              phoneNumberFormat == PhoneNumberFormat.national
                  ? _countryData!.phoneCode.length
                  : 0),
          mask,
        );
      }
    }

    return numericString;
  }
}

String _formatByMask(String text, String mask) {
  var chars = text.split('');
  var result = <String>[];
  var index = 0;
  for (var i = 0; i < mask.length; i++) {
    if (index >= chars.length) {
      break;
    }
    var curChar = chars[index];
    if (mask[i] == '0') {
      if (isDigit(curChar)) {
        result.add(curChar);
        index++;
      } else {
        break;
      }
    } else {
      result.add(mask[i]);
    }
  }
  return result.join();
}

final RegExp _digitRegex = RegExp(r'[0-9]+');
final RegExp _digitWithPeriodRegex = RegExp(r'[0-9]+(\.[0-9]+)?');

String toNumericString(String inputString, {bool allowPeriod = false}) {
  if (inputString == null) return '';
  var regExp = allowPeriod ? _digitWithPeriodRegex : _digitRegex;
  return inputString.splitMapJoin(regExp,
      onMatch: (m) => m.group(0)!, onNonMatch: (nm) => '');
}

bool isDigit(String character) {
  if (character == null || character.isEmpty || character.length > 1) {
    return false;
  }
  return _digitRegex.stringMatch(character) != null;
}

String onlyDigits(String input) => input.replaceAll(RegExp(r'[^\d]+'), '');
