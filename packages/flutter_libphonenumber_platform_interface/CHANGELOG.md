## [2.1.0] - 2024.09.19

- Fix `LibPhonenumberTextFormatter` formatting behavior for national vs international US numbers.

## [2.0.0] - 2024.09.18

- Breaking: PhoneMask.apply now needs the country object to correclty filter out the country phone code from results. Fixes bugginess when using `PhoneNumberFormat.national` with `formatNumberSync()`.

## 1.0.0

- Initial release after migration to federated plugin.
