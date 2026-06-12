## [2.1.0] - 2026.06.12

- Ready for Flutter's Built-in Kotlin cutover: the Kotlin Gradle Plugin is now applied conditionally — only on AGP <9, where the host's Flutter does not manage Kotlin itself — following the official Flutter migration guide for plugin authors. Flutter versions older than 3.44 remain supported.
- Note: Flutter 3.44 may still print "Your app uses the following plugins that apply Kotlin Gradle Plugin (KGP): flutter_libphonenumber_android". This is a false positive: Flutter's detection is a textual scan that cannot see the AGP version conditional. The plugin no longer applies KGP on hosts where Built-in Kotlin is available, so it will keep building after Flutter's cutover.
- Example app: migrate off the Kotlin Gradle Plugin and bump Java/Kotlin compatibility to 17 (building the example now requires Flutter 3.44+; the plugin itself is unaffected).

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
