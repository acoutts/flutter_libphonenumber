import 'package:flutter_libphonenumber_platform_interface/src/types/country_with_phone_code.dart';

/// Manages countries by code and name
class CountryManager {
  factory CountryManager() => _instance;
  CountryManager._internal();
  static final CountryManager _instance = CountryManager._internal();

  var _countries = <CountryWithPhoneCode>[];
  var _initialized = false;

  /// List of all supported countries on the device with phone code metadata
  List<CountryWithPhoneCode> get countries => _countries;

  Future<void> loadCountries({
    required final Map<String, CountryWithPhoneCode> phoneCodesMap,
    final Map<String, CountryWithPhoneCode> overrides = const {},
  }) async {
    if (_initialized) {
      return;
    }

    try {
      /// Apply any overrides to masks / country data
      overrides.forEach((final key, final value) {
        phoneCodesMap[key] = value;
        // print('Applied override for $key');
      });

      /// Save list of the countries
      _countries = phoneCodesMap.values.toList();

      _initialized = true;
    } catch (err) {
      _countries = overrides.values.toList();
      // log('[CountryManager] Error loading countries: $err');
    }
  }
}
