## [1.2.4] - 2022.03.09
- Fixed some edge cases with cursor position when `shouldKeepCursorAtEndOfInput` is set to `false`

## [1.2.3] - 2022.03.08
- New optional setting `shouldKeepCursorAtEndOfInput` on `LibPhonenumberTextFormatter` which will either keep the cursor at the end of the input if the middle of the input is changed, or the cursor will remain at the same position as where it was edited.

## [1.2.2] - 2022.01.12
- Replaced jcenter with maven central (JeremyLWright).

## [1.2.1] - 2021.09.11
- Fixed bug where region was not passed to `parse` call in `getFormattedParseResult`.

# 1.2.0
- BREAKING: renamed `hideCountryCode` to `inputContainsCountryCode` in `LibPhonenumberTextFormatter`.
- BREAKING: renamed `removeCountryCode` to `removeCountryCodeFromResult` and added new parameter `inputContainsCountryCode` in `formatNumberSync()`. Use this to accurately describe if the input number contains a country code and whether or not the result should strip that country code out.

# 1.1.0
- Improvements to how masking is performed.
- Now allows for additional digits to be added on the end of the input mask for countries with varying number patterns.

# 1.0.4
- Fix number parsing issue by not attaching a leading '+' anymore. This fixes the problem parsing GB numbers starting with 07 which didn't have the 44 country code at the start.
- Bumped libphonenumber version on android.

# 1.0.3
- Nullsafety for main version.
- UK numbers will correctly remove leading 0 now on international numbers.

# 1.0.2-nullsafety
- Bumped underlying native lib versions. PhoneNumberKit -> 3.3.3, libphonenumber -> 8.12.17.

# 1.0.1-nullsafety
- Add constraint for flutter v1.10.0.

# 1.0.0-nullsafety
- Migrate to null safety.

# 0.3.11
- Update iOS minimum deployment to 9.0.

# 0.3.10
- Bumped PhoneNumberKit to 3.3 (iOS) and libphonenumber to 8.12.11 (Android).
- Fixed overflows in example app on smaller devices.

# 0.3.9
- Bump android compileSdkVersion to 29.

# 0.3.8
- Downgrade Android minSdkVersion version from 21 to 18 and bump libphonenumber version from 8.12.5 to 8.12.10 via [#3](https://github.com/bottlepay/flutter_libphonenumber/pull/3).

# 0.3.7
- Fixed bug where device locale was not correctly detected on iOS.

# 0.3.6
- Hide debug printing.

## 0.3.5
- Added ability to override country mask/phone data. Added fix for UK international numbers when someone pastes in a national format.

## 0.3.4
- Fixed bug when formatting the very first number where it wouldn't move the text selection to the very end.

## 0.3.3
- Fixed bug where realtime formatter didn't ignore leading country code if present when overrideSkipCountryCode was provided.

## 0.3.2
- Fixed formatParsePhonenumberAsync to return the correct phone number international/national format based on what was requested.

## 0.3.1
- Fixes to documentation.

## 0.3.0
- Can now format based on the national or international format of a country's phone number.

## 0.2.0
- Added ability to format numbers as either mobile or fixed line, while defaulting to mobile.

## 0.1.5
- Cleanup

## 0.1.4
- Fixed bugs in the way masking is applied which caused numbers to be formatted incorrectly to their mask.

## 0.1.3
- Removed print statements
- Countries list in CountryManager is now read-only outside of the lib

## 0.1.2
- Added example gifs

## 0.1.1
- Package metadata fixes

## 0.1.0
- Initial release
