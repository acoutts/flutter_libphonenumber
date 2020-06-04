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

import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_libphonenumber/src/country_data.dart';

class LibPhonenumberTextFormatter extends TextInputFormatter {
  LibPhonenumberTextFormatter({
    this.onCountrySelected,
    this.useSeparators = true,
  });
  final ValueChanged<CountryWithPhoneCode> onCountrySelected;
  final bool useSeparators;
  CountryWithPhoneCode _countryData;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var isErasing = newValue.text.length < oldValue.text.length;
    if (isErasing) {
      if (newValue.text.isEmpty) {
        _clearCountry();
      }
      return newValue;
    }
    final onlyNumbers = toNumericString(newValue.text);
    String maskedValue = _applyMask(onlyNumbers);

    var endOffset = max(oldValue.text.length - oldValue.selection.end, 0);
    var selectionEnd = maskedValue.length - endOffset;
    return TextEditingValue(
        selection: TextSelection.collapsed(offset: selectionEnd),
        text: maskedValue);
  }

  /// this is a small dirty hask to be able to remove the firt characted
  Future _clearCountry() async {
    await Future.delayed(Duration(milliseconds: 5));
    _updateCountryData(null);
  }

  void _updateCountryData(CountryWithPhoneCode countryData) {
    _countryData = countryData;
    if (onCountrySelected != null) {
      onCountrySelected(_countryData);
    }
  }

  String _applyMask(String numericString) {
    if (numericString.isEmpty) {
      _updateCountryData(null);
    } else {
      var countryData =
          CountryWithPhoneCode.getCountryDataByPhone(numericString);
      if (countryData != null) {
        _updateCountryData(countryData);
      }
    }
    if (_countryData != null) {
      return _formatByMask(numericString, _countryData.phoneMask);
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
      onMatch: (m) => m.group(0), onNonMatch: (nm) => '');
}

bool isDigit(String character) {
  if (character == null || character.isEmpty || character.length > 1) {
    return false;
  }
  return _digitRegex.stringMatch(character) != null;
}
