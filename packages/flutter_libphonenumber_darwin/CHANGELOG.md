## [2.2.0] - 2026.06.11

- Add Swift Package Manager support while retaining CocoaPods compatibility. Requires Flutter 3.41+ when building with Swift Package Manager enabled.
- Raise iOS deployment target to 13.0, matching the current Flutter plugin template
- Remove obsolete `VALID_ARCHS` setting from the podspec which broke arm64 simulator builds when linting

## [2.1.0] - 2025.12.06

- Bump PhoneNumberKit to 4.2.1

## [2.0.0] - 2025.12.06

- Initial release after migration to darwin plugin.

## [1.4.0] - 2024.09.19

- Bump flutter_libphonenumber_platform_interface to 2.1.0

## [1.3.0] - 2024.09.18

- Bump flutter_libphonenumber_platform_interface to 2.0.0

## [1.2.2] - 2024.08.19

- Bump PhoneNumberKit to 3.8.0

## [1.2.1] - 2024.04.16

- Bump PhoneNumberKit to 3.7.9
- Added a Privacy Manifest to the iOS Project

## [1.2.0] - 2023.12.07

- Bump PhoneNumberKit to 3.7.6.
- _BREAKING_ Raises minimum iOS deployment to 12.0.

## [1.1.4] - 2023.07.19

- Bump PhoneNumberKit to 3.6.6.

## [1.1.3] - 2023.06.08

- Bump PhoneNumberKit to 3.6.0.

## [1.1.2] - 2023.05.17

- Bump PhoneNumberKit to 3.5.10.

## [1.1.1] - 2023.05.01

- Fix pod configuration for PhoneNumberKit.

## [1.1.0] - 2023.05.01

- Breaking: PhoneNumberKit pod must now be added to your Podfile because it is no longer published on cocoapods and must be downloaded from git.

## [1.0.0] - 2023.03.24

- Initial release after migration to federated plugin.
