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
