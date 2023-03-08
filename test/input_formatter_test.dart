import 'package:flutter/services.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
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
                  country: CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  TextEditingValue(
                    text: '+1 41',
                    selection: TextSelection(
                      baseOffset: 5,
                      extentOffset: 5,
                    ),
                  ),
                  // New value
                  TextEditingValue(
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
                  country: CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  TextEditingValue(
                    text: '+1 419',
                    selection: TextSelection(
                      baseOffset: 6,
                      extentOffset: 6,
                    ),
                  ),
                  // New value
                  TextEditingValue(
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
                  country: CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  TextEditingValue(
                    text: '+1 46',
                    selection: TextSelection(
                      baseOffset: 4,
                      extentOffset: 4,
                    ),
                  ),
                  // New value
                  TextEditingValue(
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
                  country: CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  TextEditingValue(
                    text: '+1 436',
                    selection: TextSelection(
                      baseOffset: 4,
                      extentOffset: 4,
                    ),
                  ),
                  // New value
                  TextEditingValue(
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
                  country: CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  TextEditingValue(
                    text: '+1 463-6',
                    selection: TextSelection(
                      baseOffset: 8,
                      extentOffset: 8,
                    ),
                  ),
                  // New value
                  TextEditingValue(
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
                  country: CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  TextEditingValue(
                    text: '+1 463-64',
                    selection: TextSelection(
                      baseOffset: 9,
                      extentOffset: 9,
                    ),
                  ),
                  // New value
                  TextEditingValue(
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
                  country: CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  TextEditingValue(
                    text: '+1 463-6',
                    selection: TextSelection(
                      baseOffset: 4,
                      extentOffset: 4,
                    ),
                  ),
                  // New value
                  TextEditingValue(
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
                  country: CountryWithPhoneCode.us(),
                );

                final formatResult = formatter.formatEditUpdate(
                  // Old value
                  TextEditingValue(
                    text: '+1 446-636',
                    selection: TextSelection(
                      baseOffset: 4,
                      extentOffset: 4,
                    ),
                  ),
                  // New value
                  TextEditingValue(
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
            group('at end of string', () {});

            group('in middle of string', () {});
          });

          group('multiple characters', () {
            group('at end of string', () {});

            group('in middle of string', () {});
          });
        });
      });

      group('removing character(s)', () {
        group('with collapsed selection', () {
          group('single character', () {
            group('at end of string', () {});

            group('in middle of string', () {});
          });

          group('multiple characters', () {
            group('at end of string', () {});

            group('in middle of string', () {});
          });
        });

        group('with expanded selection', () {
          group('single character', () {
            group('at end of string', () {});

            group('in middle of string', () {});
          });

          group('multiple characters', () {
            group('at end of string', () {});

            group('in middle of string', () {});
          });
        });
      });

      group('replacing character(s)', () {
        group('with collapsed selection', () {
          group('single character', () {
            group('at end of string', () {});

            group('in middle of string', () {});
          });

          group('multiple characters', () {
            group('at end of string', () {});

            group('in middle of string', () {});
          });
        });

        group('with expanded selection', () {
          group('single character', () {
            group('at end of string', () {});

            group('in middle of string', () {});
          });

          group('multiple characters', () {
            group('at end of string', () {});

            group('in middle of string', () {});
          });
        });
      });
    });
  });
}
