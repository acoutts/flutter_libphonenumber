import 'package:flutter/services.dart';
import 'package:flutter_libphonenumber_platform_interface/src/types/country_with_phone_code.dart';
import 'package:flutter_libphonenumber_platform_interface/src/types/input_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LibPhonenumberTextFormatter', () {
    group('shouldKeepCursorAtEndOfInput=true', () {
      group('adding character(s)', () {
        group('with collapsed selection', () {
          group('single character', () {
            group('at end of string', () {
              test('no separator', () {
                /// This does not modify the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: true,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 41',
                    selection: TextSelection(
                      baseOffset: 5,
                      extentOffset: 5,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 419',
                    selection: TextSelection(
                      baseOffset: 6,
                      extentOffset: 6,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 419');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 6);
              });

              test('with separator', () {
                /// This modifies the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: true,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 419',
                    selection: TextSelection(
                      baseOffset: 6,
                      extentOffset: 6,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 4199',
                    selection: TextSelection(
                      baseOffset: 7,
                      extentOffset: 7,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 419-9');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 8);
              });
            });

            group('in middle of string', () {
              test('no separator', () {
                /// This does not modify the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: true,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 46',
                    selection: TextSelection(
                      baseOffset: 4,
                      extentOffset: 4,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 436',
                    selection: TextSelection(
                      baseOffset: 5,
                      extentOffset: 5,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 436');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 6);
              });

              test('with separator', () {
                /// This modifies the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: true,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 436',
                    selection: TextSelection(
                      baseOffset: 4,
                      extentOffset: 4,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 4636',
                    selection: TextSelection(
                      baseOffset: 5,
                      extentOffset: 5,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 463-6');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 8);
              });
            });
          });

          group('multiple characters', () {
            group('at end of string', () {
              test('no separator', () {
                /// This does not modify the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: true,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 463-6',
                    selection: TextSelection(
                      baseOffset: 8,
                      extentOffset: 8,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 463-646',
                    selection: TextSelection(
                      baseOffset: 10,
                      extentOffset: 10,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 463-646');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 10);
              });

              test('with separator', () {
                /// This modifies the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: true,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 463-64',
                    selection: TextSelection(
                      baseOffset: 9,
                      extentOffset: 9,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 463-6446',
                    selection: TextSelection(
                      baseOffset: 11,
                      extentOffset: 11,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 463-644-6');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 12);
              });
            });

            group('in middle of string', () {
              test('no separator', () {
                /// This does not modify the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: true,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 463-6',
                    selection: TextSelection(
                      baseOffset: 4,
                      extentOffset: 4,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 44663-6',
                    selection: TextSelection(
                      baseOffset: 6,
                      extentOffset: 6,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 446-636');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 10);
              });

              test('with separator', () {
                /// This modifies the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: true,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 446-636',
                    selection: TextSelection(
                      baseOffset: 4,
                      extentOffset: 4,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 44646-636',
                    selection: TextSelection(
                      baseOffset: 6,
                      extentOffset: 6,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 446-466-36');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 13);
              });
            });
          });
        });

        group('with expanded selection', () {
          group('single character', () {
            group('at end of string', () {
              test('no separator', () {
                /// This does not modify the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: true,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 446-466-39',
                    selection: TextSelection(
                      baseOffset: 12,
                      extentOffset: 13,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 446-466-346',
                    selection: TextSelection(
                      baseOffset: 14,
                      extentOffset: 14,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 446-466-346');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 14);
              });

              test('with separator', () {
                /// This modifies the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: true,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 446-466',
                    selection: TextSelection(
                      baseOffset: 9,
                      extentOffset: 10,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 446-4646',
                    selection: TextSelection(
                      baseOffset: 11,
                      extentOffset: 11,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 446-464-6');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 12);
              });
            });

            group('in middle of string', () {
              test('no separator', () {
                /// This does not modify the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: true,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 446-464-6',
                    selection: TextSelection(
                      baseOffset: 7,
                      extentOffset: 8,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 446-4664-6',
                    selection: TextSelection(
                      baseOffset: 9,
                      extentOffset: 9,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 446-466-46');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 13);
              });

              test('with separator', () {
                /// This modifies the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: true,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 446-466',
                    selection: TextSelection(
                      baseOffset: 7,
                      extentOffset: 8,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 446-4666',
                    selection: TextSelection(
                      baseOffset: 9,
                      extentOffset: 9,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 446-466-6');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 12);
              });
            });
          });

          group('multiple characters', () {
            group('at end of string', () {
              test('no separator', () {
                /// This does not modify the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: true,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 499-5',
                    selection: TextSelection(
                      baseOffset: 7,
                      extentOffset: 8,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 499-499',
                    selection: TextSelection(
                      baseOffset: 10,
                      extentOffset: 10,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 499-499');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 10);
              });

              test('with separator', () {
                /// This modifies the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: true,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 499',
                    selection: TextSelection(
                      baseOffset: 5,
                      extentOffset: 6,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 49499',
                    selection: TextSelection(
                      baseOffset: 8,
                      extentOffset: 8,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 494-99');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 9);
              });
            });

            group('in middle of string', () {
              test('no separator', () {
                /// This does not modify the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: true,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 996-6',
                    selection: TextSelection(
                      baseOffset: 3,
                      extentOffset: 4,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 9996-6',
                    selection: TextSelection(
                      baseOffset: 5,
                      extentOffset: 5,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 999-66');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 9);
              });

              test('with separator', () {
                /// This modifies the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: true,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 999-6',
                    selection: TextSelection(
                      baseOffset: 5,
                      extentOffset: 6,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 9999-66',
                    selection: TextSelection(
                      baseOffset: 7,
                      extentOffset: 7,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 999-966');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 10);
              });
            });
          });
        });
      });

      group('removing character(s)', () {
        group('with collapsed selection', () {
          group('single character', () {
            group('at end of string', () {
              test('no separator', () {
                /// This does not modify the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: true,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 999-966',
                    selection: TextSelection(
                      baseOffset: 10,
                      extentOffset: 10,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 999-96',
                    selection: TextSelection(
                      baseOffset: 9,
                      extentOffset: 9,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 999-96');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 9);
              });

              test('with separator', () {
                /// This modifies the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: true,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 999-9',
                    selection: TextSelection(
                      baseOffset: 8,
                      extentOffset: 8,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 999-',
                    selection: TextSelection(
                      baseOffset: 7,
                      extentOffset: 7,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 999');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 6);
              });
            });

            group('in middle of string', () {
              test('no separator', () {
                /// This does not modify the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: true,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 419',
                    selection: TextSelection(
                      baseOffset: 5,
                      extentOffset: 5,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 49',
                    selection: TextSelection(
                      baseOffset: 4,
                      extentOffset: 4,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 49');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 5);
              });

              test('with separator', () {
                /// This modifies the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: true,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 496-655-5',
                    selection: TextSelection(
                      baseOffset: 8,
                      extentOffset: 8,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 496-55-5',
                    selection: TextSelection(
                      baseOffset: 7,
                      extentOffset: 7,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 496-555');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 10);
              });
            });
          });
        });

        group('with expanded selection', () {
          group('single character', () {
            group('at end of string', () {
              test('no separator', () {
                /// This does not modify the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: true,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 496-555',
                    selection: TextSelection(
                      baseOffset: 9,
                      extentOffset: 10,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 496-55',
                    selection: TextSelection(
                      baseOffset: 9,
                      extentOffset: 9,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 496-55');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 9);
              });

              test('with separator', () {
                /// This modifies the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: true,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 496-5',
                    selection: TextSelection(
                      baseOffset: 7,
                      extentOffset: 8,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 496-',
                    selection: TextSelection(
                      baseOffset: 7,
                      extentOffset: 7,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 496');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 6);
              });
            });

            group('in middle of string', () {
              test('no separator', () {
                /// This does not modify the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: true,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 496',
                    selection: TextSelection(
                      baseOffset: 4,
                      extentOffset: 5,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 46',
                    selection: TextSelection(
                      baseOffset: 4,
                      extentOffset: 4,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 46');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 5);
              });

              test('with separator', () {
                /// This modifies the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: true,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 465-555-9',
                    selection: TextSelection(
                      baseOffset: 7,
                      extentOffset: 8,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 465-55-9',
                    selection: TextSelection(
                      baseOffset: 7,
                      extentOffset: 7,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 465-559');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 10);
              });
            });
          });

          group('multiple characters', () {
            group('at end of string', () {
              test('no separator', () {
                /// This does not modify the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: true,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 465-559',
                    selection: TextSelection(
                      baseOffset: 8,
                      extentOffset: 10,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 465-5',
                    selection: TextSelection(
                      baseOffset: 8,
                      extentOffset: 8,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 465-5');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 8);
              });

              test('with separator', () {
                /// This modifies the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: true,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 465-56',
                    selection: TextSelection(
                      baseOffset: 7,
                      extentOffset: 9,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 465-',
                    selection: TextSelection(
                      baseOffset: 7,
                      extentOffset: 7,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 465');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 6);
              });
            });

            group('in middle of string', () {
              test('no separator', () {
                /// This does not modify the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: true,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 465',
                    selection: TextSelection(
                      baseOffset: 3,
                      extentOffset: 5,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 5',
                    selection: TextSelection(
                      baseOffset: 3,
                      extentOffset: 3,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 5');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 4);
              });

              test('with separator', () {
                /// This modifies the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: true,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 566-6',
                    selection: TextSelection(
                      baseOffset: 5,
                      extentOffset: 8,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 56',
                    selection: TextSelection(
                      baseOffset: 5,
                      extentOffset: 5,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 56');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 5);
              });
            });
          });
        });
      });

      group('replacing character(s)', () {
        group('with expanded selection', () {
          group('single character', () {
            group('at end of string', () {
              test('no separator', () {
                /// This does not modify the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: true,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 533',
                    selection: TextSelection(
                      baseOffset: 5,
                      extentOffset: 6,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 536',
                    selection: TextSelection(
                      baseOffset: 6,
                      extentOffset: 6,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 536');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 6);
              });
            });

            group('in middle of string', () {
              test('no separator', () {
                /// This does not modify the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: true,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 536-6',
                    selection: TextSelection(
                      baseOffset: 4,
                      extentOffset: 5,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 566-6',
                    selection: TextSelection(
                      baseOffset: 5,
                      extentOffset: 5,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 566-6');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 8);
              });
            });
          });

          group('multiple characters', () {
            group('at end of string', () {
              test('no separator', () {
                /// This does not modify the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: true,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 566-669',
                    selection: TextSelection(
                      baseOffset: 8,
                      extentOffset: 10,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 566-656',
                    selection: TextSelection(
                      baseOffset: 10,
                      extentOffset: 10,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 566-656');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 10);
              });
            });

            group('in middle of string', () {
              test('no separator', () {
                /// This does not modify the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: true,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 999-9',
                    selection: TextSelection(
                      baseOffset: 3,
                      extentOffset: 5,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 569-9',
                    selection: TextSelection(
                      baseOffset: 5,
                      extentOffset: 5,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 569-9');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 8);
              });
            });
          });
        });
      });
    });

    group('shouldKeepCursorAtEndOfInput=false', () {
      group('adding character(s)', () {
        group('with collapsed selection', () {
          group('single character', () {
            group('at end of string', () {
              test('no separator', () {
                /// This does not modify the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: false,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 569-9',
                    selection: TextSelection(
                      baseOffset: 8,
                      extentOffset: 8,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 569-98',
                    selection: TextSelection(
                      baseOffset: 9,
                      extentOffset: 9,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 569-98');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 9);
              });

              test('with separator', () {
                /// This modifies the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: false,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 566',
                    selection: TextSelection(
                      baseOffset: 6,
                      extentOffset: 6,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 5663',
                    selection: TextSelection(
                      baseOffset: 7,
                      extentOffset: 7,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 566-3');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 8);
              });
            });

            group('in middle of string', () {
              test('no separator', () {
                /// This does not modify the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: false,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 56',
                    selection: TextSelection(
                      baseOffset: 4,
                      extentOffset: 4,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 586',
                    selection: TextSelection(
                      baseOffset: 5,
                      extentOffset: 5,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 586');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 5);
              });

              test('with separator', () {
                /// This modifies the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: false,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 586',
                    selection: TextSelection(
                      baseOffset: 5,
                      extentOffset: 5,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 5896',
                    selection: TextSelection(
                      baseOffset: 6,
                      extentOffset: 6,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 589-6');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 7);
              });
            });
          });

          group('multiple characters', () {
            group('at end of string', () {
              test('no separator', () {
                /// This does not modify the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: false,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 589-6',
                    selection: TextSelection(
                      baseOffset: 8,
                      extentOffset: 8,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 589-689',
                    selection: TextSelection(
                      baseOffset: 10,
                      extentOffset: 10,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 589-689');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 10);
              });

              test('with separator', () {
                /// This modifies the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: false,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 589',
                    selection: TextSelection(
                      baseOffset: 6,
                      extentOffset: 6,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 58989',
                    selection: TextSelection(
                      baseOffset: 8,
                      extentOffset: 8,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 589-89');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 9);
              });
            });

            group('in middle of string', () {
              test('no separator', () {
                /// This does not modify the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: false,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 5',
                    selection: TextSelection(
                      baseOffset: 3,
                      extentOffset: 3,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 585',
                    selection: TextSelection(
                      baseOffset: 5,
                      extentOffset: 5,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 585');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 5);
              });

              test('with separator', () {
                /// This modifies the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: false,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 585',
                    selection: TextSelection(
                      baseOffset: 5,
                      extentOffset: 5,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 58585',
                    selection: TextSelection(
                      baseOffset: 7,
                      extentOffset: 7,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 585-85');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 8);
              });
            });
          });
        });

        group('with expanded selection', () {
          group('single character', () {
            group('at end of string', () {
              test('no separator', () {
                /// This does not modify the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: false,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 585-85',
                    selection: TextSelection(
                      baseOffset: 8,
                      extentOffset: 9,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 585-885',
                    selection: TextSelection(
                      baseOffset: 10,
                      extentOffset: 10,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 585-885');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 10);
              });

              test('with separator', () {
                /// This modifies the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: false,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 585-885',
                    selection: TextSelection(
                      baseOffset: 9,
                      extentOffset: 10,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 585-8885',
                    selection: TextSelection(
                      baseOffset: 11,
                      extentOffset: 11,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 585-888-5');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 12);
              });
            });

            group('in middle of string', () {
              test('no separator', () {
                /// This does not modify the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: false,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 585-888-5',
                    selection: TextSelection(
                      baseOffset: 7,
                      extentOffset: 8,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 585-8588-5',
                    selection: TextSelection(
                      baseOffset: 9,
                      extentOffset: 9,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 585-858-85');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 9);
              });

              test('with separator', () {
                /// This modifies the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: false,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 585-855',
                    selection: TextSelection(
                      baseOffset: 7,
                      extentOffset: 8,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 585-8555',
                    selection: TextSelection(
                      baseOffset: 9,
                      extentOffset: 9,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 585-855-5');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 10);
              });
            });
          });

          group('multiple characters', () {
            group('at end of string', () {
              test('no separator', () {
                /// This does not modify the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: false,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 585-855-5',
                    selection: TextSelection(
                      baseOffset: 11,
                      extentOffset: 12,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 585-855-855',
                    selection: TextSelection(
                      baseOffset: 14,
                      extentOffset: 14,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 585-855-855');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 14);
              });

              test('with separator', () {
                /// This modifies the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: false,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 585-85',
                    selection: TextSelection(
                      baseOffset: 8,
                      extentOffset: 9,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 585-8855',
                    selection: TextSelection(
                      baseOffset: 11,
                      extentOffset: 11,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 585-885-5');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 12);
              });
            });

            group('in middle of string', () {
              test('no separator', () {
                /// This does not modify the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: false,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 585-855-5',
                    selection: TextSelection(
                      baseOffset: 7,
                      extentOffset: 8,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 585-85585-5',
                    selection: TextSelection(
                      baseOffset: 10,
                      extentOffset: 10,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 585-855-855');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 10);
              });

              test('with separator', () {
                /// This modifies the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: false,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 585-855',
                    selection: TextSelection(
                      baseOffset: 7,
                      extentOffset: 8,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 585-85555',
                    selection: TextSelection(
                      baseOffset: 10,
                      extentOffset: 10,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 585-855-55');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 11);
              });
            });
          });
        });
      });

      group('removing character(s)', () {
        group('with collapsed selection', () {
          group('single character', () {
            group('at end of string', () {
              test('no separator', () {
                /// This does not modify the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: false,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 463-25',
                    selection: TextSelection(
                      baseOffset: 9,
                      extentOffset: 9,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 463-2',
                    selection: TextSelection(
                      baseOffset: 8,
                      extentOffset: 8,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 463-2');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 8);
              });

              test('with separator', () {
                /// This modifies the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: false,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 463-2',
                    selection: TextSelection(
                      baseOffset: 8,
                      extentOffset: 8,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 463-',
                    selection: TextSelection(
                      baseOffset: 7,
                      extentOffset: 7,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 463');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 6);
              });
            });

            group('in middle of string', () {
              test('no separator', () {
                /// This does not modify the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: false,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 463',
                    selection: TextSelection(
                      baseOffset: 5,
                      extentOffset: 5,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 43',
                    selection: TextSelection(
                      baseOffset: 4,
                      extentOffset: 4,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 43');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 4);
              });

              test('with separator', () {
                /// This modifies the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: false,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 466-3',
                    selection: TextSelection(
                      baseOffset: 5,
                      extentOffset: 5,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 46-3',
                    selection: TextSelection(
                      baseOffset: 4,
                      extentOffset: 4,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 463');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 4);
              });
            });
          });
        });

        group('with expanded selection', () {
          group('single character', () {
            group('at end of string', () {
              test('no separator', () {
                /// This does not modify the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: false,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 463',
                    selection: TextSelection(
                      baseOffset: 5,
                      extentOffset: 6,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 46',
                    selection: TextSelection(
                      baseOffset: 5,
                      extentOffset: 5,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 46');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 5);
              });

              test('with separator', () {
                /// This modifies the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: false,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 466-6',
                    selection: TextSelection(
                      baseOffset: 7,
                      extentOffset: 8,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 466-',
                    selection: TextSelection(
                      baseOffset: 7,
                      extentOffset: 7,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 466');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 6);
              });
            });

            group('in middle of string', () {
              test('no separator', () {
                /// This does not modify the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: false,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 466',
                    selection: TextSelection(
                      baseOffset: 4,
                      extentOffset: 5,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 46',
                    selection: TextSelection(
                      baseOffset: 4,
                      extentOffset: 4,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 46');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 4);
              });

              test('with separator', () {
                /// This modifies the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: false,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 499-6',
                    selection: TextSelection(
                      baseOffset: 5,
                      extentOffset: 6,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 49-6',
                    selection: TextSelection(
                      baseOffset: 5,
                      extentOffset: 5,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 496');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 5);
              });
            });
          });

          group('multiple characters', () {
            group('at end of string', () {
              test('no separator', () {
                /// This does not modify the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: false,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 496',
                    selection: TextSelection(
                      baseOffset: 4,
                      extentOffset: 6,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 4',
                    selection: TextSelection(
                      baseOffset: 4,
                      extentOffset: 4,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 4');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 4);
              });

              test('with separator', () {
                /// This modifies the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: false,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 488-8',
                    selection: TextSelection(
                      baseOffset: 6,
                      extentOffset: 8,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 488',
                    selection: TextSelection(
                      baseOffset: 6,
                      extentOffset: 6,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 488');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 6);
              });
            });

            group('in middle of string', () {
              test('no separator', () {
                /// This does not modify the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: false,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 488',
                    selection: TextSelection(
                      baseOffset: 3,
                      extentOffset: 5,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 8',
                    selection: TextSelection(
                      baseOffset: 3,
                      extentOffset: 3,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 8');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 3);
              });

              test('with separator', () {
                /// This modifies the separators in the string
                /// (space, dash, plus, etc)

                final formatter = LibPhonenumberTextFormatter(
                  inputContainsCountryCode: true,
                  shouldKeepCursorAtEndOfInput: false,
                  country: const CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  const TextEditingValue(
                    text: '+1 965-8',
                    selection: TextSelection(
                      baseOffset: 4,
                      extentOffset: 6,
                    ),
                  ),
                  // New value
                  const TextEditingValue(
                    text: '+1 9-8',
                    selection: TextSelection(
                      baseOffset: 4,
                      extentOffset: 4,
                    ),
                  ),
                );

                /// Expected formatted output
                expect(formatResult.text, '+1 98');

                /// Cursor is at the point where we deleted something
                expect(formatResult.selection.baseOffset, 4);
              });
            });
          });
        });
      });

      group('replacing character(s)', () {
        group('with expanded selection', () {
          group('single character', () {
            test('at end of string', () {
              final formatter = LibPhonenumberTextFormatter(
                inputContainsCountryCode: true,
                shouldKeepCursorAtEndOfInput: false,
                country: const CountryWithPhoneCode.us(),
              );

              final formatResult = formatter.formatEditUpdate(
                // Old value
                const TextEditingValue(
                  text: '+1 98',
                  selection: TextSelection(
                    baseOffset: 4,
                    extentOffset: 5,
                  ),
                ),
                // New value
                const TextEditingValue(
                  text: '+1 99',
                  selection: TextSelection(
                    baseOffset: 5,
                    extentOffset: 5,
                  ),
                ),
              );

              /// Expected formatted output
              expect(formatResult.text, '+1 99');

              /// Cursor is at the point where we deleted something
              expect(formatResult.selection.baseOffset, 5);
            });

            test('in middle of string', () {
              final formatter = LibPhonenumberTextFormatter(
                inputContainsCountryCode: true,
                shouldKeepCursorAtEndOfInput: false,
                country: const CountryWithPhoneCode.us(),
              );

              final formatResult = formatter.formatEditUpdate(
                // Old value
                const TextEditingValue(
                  text: '+1 666',
                  selection: TextSelection(
                    baseOffset: 4,
                    extentOffset: 5,
                  ),
                ),
                // New value
                const TextEditingValue(
                  text: '+1 696',
                  selection: TextSelection(
                    baseOffset: 5,
                    extentOffset: 5,
                  ),
                ),
              );

              /// Expected formatted output
              expect(formatResult.text, '+1 696');

              /// Cursor is at the point where we deleted something
              expect(formatResult.selection.baseOffset, 5);
            });
          });

          group('multiple characters', () {
            test('at end of string', () {
              /// This does not modify the separators in the string
              /// (space, dash, plus, etc)

              final formatter = LibPhonenumberTextFormatter(
                inputContainsCountryCode: true,
                shouldKeepCursorAtEndOfInput: false,
                country: const CountryWithPhoneCode.us(),
              );

              final formatResult = formatter.formatEditUpdate(
                // Old value
                const TextEditingValue(
                  text: '+1 693-33',
                  selection: TextSelection(
                    baseOffset: 7,
                    extentOffset: 9,
                  ),
                ),
                // New value
                const TextEditingValue(
                  text: '+1 693-96',
                  selection: TextSelection(
                    baseOffset: 9,
                    extentOffset: 9,
                  ),
                ),
              );

              /// Expected formatted output
              expect(formatResult.text, '+1 693-96');

              /// Cursor is at the point where we deleted something
              expect(formatResult.selection.baseOffset, 9);
            });

            test('in middle of string', () {
              /// This does not modify the separators in the string
              /// (space, dash, plus, etc)

              final formatter = LibPhonenumberTextFormatter(
                inputContainsCountryCode: true,
                shouldKeepCursorAtEndOfInput: false,
                country: const CountryWithPhoneCode.us(),
              );

              final formatResult = formatter.formatEditUpdate(
                // Old value
                const TextEditingValue(
                  text: '+1 693-96',
                  selection: TextSelection(
                    baseOffset: 3,
                    extentOffset: 5,
                  ),
                ),
                // New value
                const TextEditingValue(
                  text: '+1 963-96',
                  selection: TextSelection(
                    baseOffset: 5,
                    extentOffset: 5,
                  ),
                ),
              );

              /// Expected formatted output
              expect(formatResult.text, '+1 963-96');

              /// Cursor is at the point where we deleted something
              expect(formatResult.selection.baseOffset, 5);
            });
          });
        });
      });
    });
  });
}
