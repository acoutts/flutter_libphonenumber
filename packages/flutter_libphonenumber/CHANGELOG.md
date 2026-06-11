## [2.8.0] - 2026.06.11

- Bump flutter_libphonenumber_darwin to 2.2.0: adds Swift Package Manager support while retaining CocoaPods compatibility (#98). Building with Swift Package Manager enabled requires Flutter 3.41+, and the iOS deployment target is now 13.0.

## [2.7.0] - 2025.12.06

- Migrate example app to declarative gradle plugins
- Bump flutter_libphonenumber_darwin to 2.1.0
- BREAKING: Removed flutter_libphonenumber_ios since it's now part of flutter_libphonenumber_darwin
- Remove melos in favor of dart workspace
- Updated flutter_libphonenumber/example android to latest gradle configs

## [2.6.0] - 2025.12.06

- macOS Support.

## [2.5.1] - 2025.02.13

- Bump flutter_libphonenumber_android to 1.4.1: This fixes unresolved Registrar issue occurring after upgrading Flutter to 3.29.0 (#93 @amitkhairnar44)

## [2.5.0] - 2024.09.19

- Bump flutter_libphonenumber_platform_interface to 2.1.0
- Bump flutter_libphonenumber_android to v1.4.0.
- Bump flutter_libphonenumber_ios to v1.4.0.
- Bump flutter_libphonenumber_web to v1.3.0.

## [2.4.0] - 2024.09.18

- Bump flutter_libphonenumber_platform_interface to 2.0.0
- Bump flutter_libphonenumber_android to v1.3.0.
- Bump flutter_libphonenumber_ios to v1.3.0.
- Bump flutter_libphonenumber_web to v1.2.0.

## [2.3.3] - 2024.08.19

- Bump flutter_libphonenumber_android to v1.2.0.

## [2.3.2] - 2024.08.19

- Bump flutter_libphonenumber_ios to v1.2.2.

## [2.3.1] - 2024.08.19

- Bump flutter_libphonenumber_android to v1.1.0.

## [2.2.3] - 2024.04.16

- Bump flutter_libphonenumber_web to v1.0.1.

## [2.2.2] - 2024.04.16

- Bump flutter_libphonenumber_ios to v1.2.1.

## [2.2.1] - 2023.12.07

- Fix init method overrides, from @nikolaychernov.

## [2.2.0] - 2023.12.07

- Bump flutter_libphonenumber_ios to v1.2.0.
- _BREAKING_ Raises minimum iOS deployment to 12.0.

## [2.1.5] - 2023.07.19

- Bump flutter_libphonenumber_ios to v1.1.4.

## [2.1.4] - 2023.06.08

- Bump flutter_libphonenumber_ios to v1.1.3.

## [2.1.3] - 2023.05.17

- Fix pod issue with PhoneNumberKit by bumping flutter_libphonenumber_ios version to latest.

## [2.1.2] - 2023.05.01

- Fix compatibility with AGP 8.0 (#43).

## [2.1.1] - 2023.05.01

- Fix pod configuration for PhoneNumberKit.

## [2.1.0] - 2023.05.01

- BREAKING: Bumped flutter_libphonenumber_ios to 1.1.0 which includes the latest PhoneNumberKit version. You must include the entry in your Podfile now. See updated README for details.

## [2.0.0] - 2023.03.24

- Migrated to new federated plugin configuration.
- Added web implementation from laynor.

## [1.4.0] - 2023.03.10

- Fixed `onFormatFinished` callback not being called when `shouldKeepCursorAtEndOfInput=true`.

## [1.3.0] - 2022.12.05

- Adds a new field (region_code) to the result of the parse method.
- Upgrades the dependencies:
  - libphonenumber to 8.12.52
  - PhoneNumberKit to 3.3.4
- Fixes some lint issues.
- Upgrade gradle/kotlin versions in android project.

## [1.2.4] - 2022.03.10

- Fixed some edge cases with cursor position when `shouldKeepCursorAtEndOfInput` is set to `false`

## [1.2.3] - 2022.03.08

- New optional setting `shouldKeepCursorAtEndOfInput` on `LibPhonenumberTextFormatter` which will either keep the cursor at the end of the input if the middle of the input is changed, or the cursor will remain at the same position as where it was edited.

## [1.2.2] - 2022.01.13

- Replaced jcenter with maven central (JeremyLWright).

## [1.2.1] - 2021.09.11

- Fixed bug where region was not passed to `parse` call in `getFormattedParseResult`.

## [1.2.0] - 2021.08.26

- BREAKING: renamed `hideCountryCode` to `inputContainsCountryCode` in `LibPhonenumberTextFormatter`.
- BREAKING: renamed `removeCountryCode` to `removeCountryCodeFromResult` and added new parameter `inputContainsCountryCode` in `formatNumberSync()`. Use this to accurately describe if the input number contains a country code and whether or not the result should strip that country code out.

## [1.1.0] - 2021.07.01

- Improvements to how masking is performed.
- Now allows for additional digits to be added on the end of the input mask for countries with varying number patterns.

## [1.0.4] - 2021.06.08

- Fix number parsing issue by not attaching a leading '+' anymore. This fixes the problem parsing GB numbers starting with 07 which didn't have the 44 country code at the start.
- Bumped libphonenumber version on android.

## [1.0.3] - 2021.02.10

- Nullsafety for main version.
- UK numbers will correctly remove leading 0 now on international numbers.

## [1.0.2-nullsafety] - 2021.02.03

- Bumped underlying native lib versions. PhoneNumberKit -> 3.3.3, libphonenumber -> 8.12.17.

## [1.0.1-nullsafety] - 2020.11.22

- Add constraint for flutter v1.10.0.

## [1.0.0-nullsafety] - 2020.11.22

- Migrate to null safety.

## [0.3.11] - 2020.11.02

- Update iOS minimum deployment to 9.0.

## [0.3.10] - 2020.10.27

- Bumped PhoneNumberKit to 3.3 (iOS) and libphonenumber to 8.12.11 (Android).
- Fixed overflows in example app on smaller devices.

## [0.3.9] - 2020.10.19

- Bump android compileSdkVersion to 29.

## [0.3.8] - 2020.09.29

- Downgrade Android minSdkVersion version from 21 to 18 and bump libphonenumber version from 8.12.5 to 8.12.10 via [#3](https://github.com/acoutts/flutter_libphonenumber/pull/3).

## [0.3.7] - 2020.07.15

- Fixed bug where device locale was not correctly detected on iOS.

## [0.3.6] - 2020.07.09

- Hide debug printing.

## [0.3.5] - 2020.06.25

- Added ability to override country mask/phone data. Added fix for UK international numbers when someone pastes in a national format.

## [0.3.4] - 2020.06.16

- Fixed bug when formatting the very first number where it wouldn't move the text selection to the very end.

## [0.3.3] - 2020.06.12

- Fixed bug where realtime formatter didn't ignore leading country code if present when overrideSkipCountryCode was provided.

## [0.3.2] - 2020.06.12

- Fixed formatParsePhonenumberAsync to return the correct phone number international/national format based on what was requested.

## [0.3.1] - 2020.06.10

- Fixes to documentation.

## [0.3.0] - 2020.06.10

- Can now format based on the national or international format of a country's phone number.

## [0.2.0] - 2020.06.05

- Added ability to format numbers as either mobile or fixed line, while defaulting to mobile.

## [0.1.5] - 2020.06.05

- Cleanup

## [0.1.4] - 2020.06.05

- Fixed bugs in the way masking is applied which caused numbers to be formatted incorrectly to their mask.

## [0.1.3] - 2020.06.05

- Removed print statements
- Countries list in CountryManager is now read-only outside of the lib

## [0.1.2] - 2020.06.05

- Added example gifs

## [0.1.1] - 2020.06.05

- Package metadata fixes

## [0.1.0] - 2020.06.05

- Initial release
