# flutter_libphonenumber

A wrapper around libphonenumber with added functionality merged from the following libs:
* https://github.com/nashfive/phone_number
* https://github.com/anoop4real/flutter_iso_countries
* https://github.com/caseyryan/flutter_multi_formatter

## Getting Started
First you need to call the `init` function. This will load all of the available regions available on the device, and then cross-reference them with libphonenumber to build a formatting mask for each region using an example number from libphonenumber.

This is an improvement on the approach in `flutter_multi_formatter` because we simply pull all of the phone pattern mask data from libphonenumber and don't need to manage it manually.

```dart
await FlutterLibphonenumber().init();
```

You can either do this during your app init before calling `RunApp`, or with a `FutureBuilder` as the example app demonstrates.

## Formatting a number synchronously
Normally calls to libphonenumber's format function are asynchronous, and you might not want
your UI to have to rebuild every time you need to format a phone number. The effect here might be you need loading indicators or the UI will change after a second when the async format call returns.

To get around this, we loaded a mask of every supported phone region during the `init()` call. We can use this to format an e164 phone number **synchronously** like this:
```dart
final rawNumber = '+14145556666';
final formattedNumber = FlutterLibphonenumber().formatPhone(rawNumber); // +1 (414) 555-6666
```

# API Reference
Here is a reference of all of the available functions.

### `Future<void> init()`
Must be called before we can format anything. This loads all available countries on the device and calls `getAllSupportedRegions()` to then cross-reference and combine everything and save a `List<CountryWithPhoneCode>` of every available country with its phone code / mask.

### `Future<Map<String, dynamic>> getAllSupportedRegions()`
Returns all of the available regions on the device in a map with each key as the region code, and the value as a map containing the `phoneMask` and `phoneCode`.

Example response:
```dart
{
    "US": {
        "phoneCode": "1",
        "phoneMask": "+0 (000) 000-0000"
    }
}
```

### `Future<Map<String, dynamic>> format(String phone, String region)`
Formats a number using libphonenumber. Will return the parsed / formatted number like this:

```dart
{
    formatted: "1 (414) 444-4444",
}
```

### `Future<Map<String, dynamic>> parse(String phone, {String region})`
Parses a number and if it is full and complete, returns some metadata associated with the number. The number must be a valid and compelte e164 formatted number to be considered valid.  Will throw an error if the number isn't valid.

Example response:
```dart
{
    country_code: 49,
    e164: '+4930123123123',
    national: '030 123 123 123',
    type: 'mobile',
    international: '+49 30 123 123 123',
    national_number: '030123123123',
}
```

### `Future<Map<String, dynamic>> formatNumberSync(String phone, String region)`
Format a number synchronously using masks to format it.

Example response:
```dart
"1 (414) 444-4444"
```

### `Future<FormatPhoneResult> formatParsePhonenumberAsync(String phoneNumber, CountryWithPhoneCode country)`
Asynchronously formats a phone number with libphonenumber. Will return the formatted number and if it's a valid/complete number, will return the e164 value as well in the `e164` field. Uses libphonenumber's parse function to verify if it's a valid number or not.

This is useful if you want to format a number and also check if it's valid, in one step.

Example response:
```dart
{
    formatted: "1 (414) 444-4444",
}
```

### `TextInputFormatter LibPhonenumberTextFormatter(...)`
The text formatter takes 3 optional arguments:
* `ValueChanged<CountryWithPhoneCode> onCountrySelected` is a callback that will be called when the formatter has automatically determined the country/region from the phone number. Could be useful if you want to parse a phone number input in realtime and save the detected country from it once available.
* `String overrideSkipCountryCode`  When this is supplied then we will format the number using the supplied country code and mask with the country code removed. This is useful if you have the country code being selected in another text box and just need to format the number without its country code in it.
* `FutureOr Function(String val) onFormatFinished` Optionally get a notification at this callback of the final formatted value once all formatting is completed. This is useful if you want to do something else that is triggered after formatting is done.

You should specify `overrideSkipCountryCode` when you have a country picker somewhere else and just want your text field to format the number without the country code in it. This is useful if you have a dropdown to select the country code and a text field next to it to enter the number.

To use it, simply add `LibPhonenumberTextFormatter()` to your `TextField`'s `inputFormatters` list:
```dart
TextField(inputFormatters: [LibPhonenumberTextFormatter(
    onCountrySelected: (country) => print('onCountrySelected: $country'),
    onFormatFinished: (formattedVal) => print('onCountrySelected: $formattedVal')
    // overrideSkipCountryCode: 'GB' // Optionally override to GB and return the number w/o +44
)])
```
