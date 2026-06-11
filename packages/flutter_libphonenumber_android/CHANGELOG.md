## [2.0.1] - 2026.06.11

- Reduce repeated work in getAllSupportedRegions: cache the digit regex used for masking, reuse a single PhoneNumberUtil instance, and format each example number once (#100 @higorlapacw)

## [2.0.0] - 2025.12.06

- Bump gradle configs for latest flutter stable 3.38.4

## [1.4.1] - 2025.02.13

- This fixes unresolved Registrar issue occurring after upgrading Flutter to 3.29.0 (#93 @amitkhairnar44)

## [1.4.0] - 2024.09.19

- Bump flutter_libphonenumber_platform_interface to 2.1.0

## [1.3.0] - 2024.09.18

- Bump flutter_libphonenumber_platform_interface to 2.0.0

## [1.2.0] - 2024.08.19

- Bump libphonenumber to 8.13.43.

## [1.1.0] - 2024.08.19

- Bump android compileSdk to 34
- Fix android JVM version incompatibility build errors.

## [1.0.1] - 2023.05.01

- Fix compatibility with AGP 8.0 (#43).

## [1.0.0] - 2023.03.24

- Initial release after migration to federated plugin.
