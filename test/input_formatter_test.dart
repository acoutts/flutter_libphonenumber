import 'package:flutter/services.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LibPhonenumberTextFormatter', () {
    /// Adding a new character to the end of the string
    test(
        'should keep cursor at the end when shouldKeepCursorAtEndOfInput is true and we add a new character to the end',
        () {
      final formatter = LibPhonenumberTextFormatter(
        inputContainsCountryCode: true,
        shouldKeepCursorAtEndOfInput: true,
        country: CountryWithPhoneCode.us(),
      );

      final formatResult = formatter.formatEditUpdate(
        // Old value
        TextEditingValue(
          text: '+1 419',
          selection: TextSelection.fromPosition(
            TextPosition(
              offset: 6,
            ),
          ),
        ),
        // New value
        TextEditingValue(
          text: '+1 4194',
          selection: TextSelection.fromPosition(
            TextPosition(
              offset: 7,
            ),
          ),
        ),
      );

      /// Expected formatted output
      expect(formatResult.text, '+1 419-4');

      /// Cursor is at end of line
      expect(formatResult.selection.baseOffset, 8);
    });

    /// Adding a new character in the middle of the string
    test(
        'should keep cursor at the end when shouldKeepCursorAtEndOfInput is true and we add a new character to the middle',
        () {
      final formatter = LibPhonenumberTextFormatter(
        inputContainsCountryCode: true,
        shouldKeepCursorAtEndOfInput: true,
        country: CountryWithPhoneCode.us(),
      );

      final formatResult = formatter.formatEditUpdate(
        // Old value
        TextEditingValue(
          text: '+1 419-4',
          selection: TextSelection.fromPosition(
            TextPosition(
              offset: 4,
            ),
          ),
        ),
        // New value
        TextEditingValue(
          text: '+1 4219-4',
          selection: TextSelection.fromPosition(
            TextPosition(
              offset: 5,
            ),
          ),
        ),
      );

      /// Expected formatted output
      expect(formatResult.text, '+1 421-94');

      /// Cursor is at end of line
      expect(formatResult.selection.baseOffset, 9);
    });

    /// Add a character in the middle of the string
    test(
        'should keep cursor at the same spot when shouldKeepCursorAtEndOfInput is false and we add one character in the middle of the string',
        () {
      final formatter = LibPhonenumberTextFormatter(
        inputContainsCountryCode: true,
        shouldKeepCursorAtEndOfInput: false,
        country: CountryWithPhoneCode.us(),
      );

      final formatResult = formatter.formatEditUpdate(
        // Old value
        TextEditingValue(
          text: '+1 419',
          selection: TextSelection.fromPosition(
            TextPosition(
              offset: 4,
            ),
          ),
        ),
        // New value
        TextEditingValue(
          text: '+1 4219',
          selection: TextSelection.fromPosition(
            TextPosition(
              offset: 5,
            ),
          ),
        ),
      );

      /// Expected formatted output
      expect(formatResult.text, '+1 421-9');

      /// Cursor is at the point where we deleted something
      expect(formatResult.selection.baseOffset, 5);
    });

    /// Add a character in the end of the string
    test(
        'should keep cursor at the same spot when shouldKeepCursorAtEndOfInput is false and we add one character in the end of the string',
        () {
      final formatter = LibPhonenumberTextFormatter(
        inputContainsCountryCode: true,
        shouldKeepCursorAtEndOfInput: false,
        country: CountryWithPhoneCode.us(),
      );

      final formatResult = formatter.formatEditUpdate(
        // Old value
        TextEditingValue(
          text: '+1 419',
          selection: TextSelection.fromPosition(
            TextPosition(
              offset: 6,
            ),
          ),
        ),
        // New value
        TextEditingValue(
          text: '+1 4192',
          selection: TextSelection.fromPosition(
            TextPosition(
              offset: 7,
            ),
          ),
        ),
      );

      /// Expected formatted output
      expect(formatResult.text, '+1 419-2');

      /// Cursor is at the point where we deleted something
      expect(formatResult.selection.baseOffset, 8);
    });

    /// Delete one character in the middle of the string (no selection)
    test(
        'should keep cursor at the same spot when shouldKeepCursorAtEndOfInput is false and we delete one character in the middle of the string without a selection',
        () {
      final formatter = LibPhonenumberTextFormatter(
        inputContainsCountryCode: true,
        shouldKeepCursorAtEndOfInput: false,
        country: CountryWithPhoneCode.us(),
      );

      final formatResult = formatter.formatEditUpdate(
        // Old value
        TextEditingValue(
          text: '+1 419-2',
          selection: TextSelection(
            baseOffset: 5,
            extentOffset: 5,
          ),
        ),
        // New value
        TextEditingValue(
          text: '+1 49-2',
          selection: TextSelection(
            baseOffset: 4,
            extentOffset: 4,
          ),
        ),
      );

      /// Expected formatted output
      expect(formatResult.text, '+1 492');

      /// Cursor is at the point where we deleted something
      expect(formatResult.selection.baseOffset, 4);
    });

    /// Delete one character at end of the string (no selection)
    test(
        'should keep cursor at the same spot when shouldKeepCursorAtEndOfInput is false and we delete one character at the end of the string without a selection',
        () {
      final formatter = LibPhonenumberTextFormatter(
        inputContainsCountryCode: true,
        shouldKeepCursorAtEndOfInput: false,
        country: CountryWithPhoneCode.us(),
      );

      final formatResult = formatter.formatEditUpdate(
        // Old value
        TextEditingValue(
          text: '+1 419-2',
          selection: TextSelection(
            baseOffset: 8,
            extentOffset: 8,
          ),
        ),
        // New value
        TextEditingValue(
          text: '+1 419-',
          selection: TextSelection(
            baseOffset: 7,
            extentOffset: 7,
          ),
        ),
      );

      /// Expected formatted output
      expect(formatResult.text, '+1 419');

      /// Cursor is at the point where we deleted something
      expect(formatResult.selection.baseOffset, 6);
    });

    /// Delete one character in the middle of the string (with selection)
    test(
        'should keep cursor at the same spot when shouldKeepCursorAtEndOfInput is false and we delete one character in the middle of the string with a selection',
        () {
      final formatter = LibPhonenumberTextFormatter(
        inputContainsCountryCode: true,
        shouldKeepCursorAtEndOfInput: false,
        country: CountryWithPhoneCode.us(),
      );

      final formatResult = formatter.formatEditUpdate(
        // Old value
        TextEditingValue(
          text: '+1 429-4',
          selection: TextSelection(
            baseOffset: 5,
            extentOffset: 6,
          ),
        ),
        // New value
        TextEditingValue(
          text: '+1 42-4',
          selection: TextSelection(
            baseOffset: 5,
            extentOffset: 5,
          ),
        ),
      );

      /// Expected formatted output
      expect(formatResult.text, '+1 424');

      /// Cursor is at the point where we deleted something
      expect(formatResult.selection.baseOffset, 5);
    });

    /// Delete one character at end of the string (with selection)
    test(
        'should keep cursor at the same spot when shouldKeepCursorAtEndOfInput is false and we delete one character at the end of the string with a selection',
        () {
      final formatter = LibPhonenumberTextFormatter(
        inputContainsCountryCode: true,
        shouldKeepCursorAtEndOfInput: false,
        country: CountryWithPhoneCode.us(),
      );

      final formatResult = formatter.formatEditUpdate(
        // Old value
        TextEditingValue(
          text: '+1 425-45',
          selection: TextSelection(
            baseOffset: 8,
            extentOffset: 9,
          ),
        ),
        // New value
        TextEditingValue(
          text: '+1 425-4',
          selection: TextSelection(
            baseOffset: 8,
            extentOffset: 8,
          ),
        ),
      );

      /// Expected formatted output
      expect(formatResult.text, '+1 425-4');

      /// Cursor is at the point where we deleted something
      expect(formatResult.selection.baseOffset, 8);
    });

    /// Replace part of the end of the string with a smaller string using a selection
    test(
        'should keep cursor at the same spot when shouldKeepCursorAtEndOfInput is false and we replace part of the end of the string with a smaller string using a selection',
        () {
      final formatter = LibPhonenumberTextFormatter(
        inputContainsCountryCode: true,
        shouldKeepCursorAtEndOfInput: false,
        country: CountryWithPhoneCode.us(),
      );

      final formatResult = formatter.formatEditUpdate(
        // Old value
        TextEditingValue(
          text: '+1 425-455',
          selection: TextSelection(
            baseOffset: 8,
            extentOffset: 10,
          ),
        ),
        // New value
        TextEditingValue(
          text: '+1 425-45',
          selection: TextSelection(
            baseOffset: 9,
            extentOffset: 9,
          ),
        ),
      );

      /// Expected formatted output
      expect(formatResult.text, '+1 425-45');

      /// Cursor is at the point where we deleted something
      expect(formatResult.selection.baseOffset, 9);
    });

    /// Replace part of the middle of the string with a smaller string using a selection
    test(
        'should keep cursor at the same spot when shouldKeepCursorAtEndOfInput is false and we replace part of the middle of the string with a smaller string using a selection',
        () {
      final formatter = LibPhonenumberTextFormatter(
        inputContainsCountryCode: true,
        shouldKeepCursorAtEndOfInput: false,
        country: CountryWithPhoneCode.us(),
      );

      final formatResult = formatter.formatEditUpdate(
        // Old value
        TextEditingValue(
          text: '+1 425-455',
          selection: TextSelection(
            baseOffset: 4,
            extentOffset: 6,
          ),
        ),
        // New value
        TextEditingValue(
          text: '+1 45-455',
          selection: TextSelection(
            baseOffset: 5,
            extentOffset: 5,
          ),
        ),
      );

      /// Expected formatted output
      expect(formatResult.text, '+1 454-55');

      /// Cursor is at the point where we deleted something
      expect(formatResult.selection.baseOffset, 5);
    });

    /// Replace one character of the middle of the string with another using a selection
    test(
        'should keep cursor at the same spot when shouldKeepCursorAtEndOfInput is false and we replace one character of the middle of the string with another, using a selection',
        () {
      final formatter = LibPhonenumberTextFormatter(
        inputContainsCountryCode: true,
        shouldKeepCursorAtEndOfInput: false,
        country: CountryWithPhoneCode.us(),
      );

      final formatResult = formatter.formatEditUpdate(
        // Old value
        TextEditingValue(
          text: '+1 454-55',
          selection: TextSelection(
            baseOffset: 5,
            extentOffset: 6,
          ),
        ),
        // New value
        TextEditingValue(
          text: '+1 457-55',
          selection: TextSelection(
            baseOffset: 6,
            extentOffset: 6,
          ),
        ),
      );

      /// Expected formatted output
      expect(formatResult.text, '+1 457-55');

      /// Cursor is at the point where we deleted something
      expect(formatResult.selection.baseOffset, 6);
    });

    // ------------ not tested yet ---------------

    /// Replace 2 characters of the middle of the string with another using a selection / paste
    test(
        'should keep cursor at the same spot when shouldKeepCursorAtEndOfInput is false and we replace 2 characters of the middle of the string with another, using a selection and pasting the new value',
        () {
      final formatter = LibPhonenumberTextFormatter(
        inputContainsCountryCode: true,
        shouldKeepCursorAtEndOfInput: false,
        country: CountryWithPhoneCode.us(),
      );

      final formatResult = formatter.formatEditUpdate(
        // Old value
        TextEditingValue(
          text: '+1 419-2',
          selection: TextSelection(
            baseOffset: 8,
            extentOffset: 8,
          ),
        ),
        // New value
        TextEditingValue(
          text: '+1 419-',
          selection: TextSelection(
            baseOffset: 7,
            extentOffset: 7,
          ),
        ),
      );

      /// Expected formatted output
      expect(formatResult.text, '+1 419');

      /// Cursor is at the point where we deleted something
      expect(formatResult.selection.baseOffset, 6);
      expect(true, false);
    });
  });
}
