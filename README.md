# flutter_libphonenumber

A wrapper around libphonenumber with added functionality merged from the following libs:
* https://github.com/nashfive/phone_number
* https://github.com/anoop4real/flutter_iso_countries
* https://github.com/caseyryan/flutter_multi_formatter

Uses the following native libraries:
| Platform | Library        | Version |
|----------|----------------|---------|
| Android  | libphonenumber | 8.12.5  |
| iOS      | PhoneNumberKit | 3.2.0   |

The main advantage to this lib is it lets you optionally format a phone number synchronously without making calls into libphonenumber with platform calls.

## Getting Started
First you need to call the `init` function. This will load all of the available regions available on the device from libphonenumber to build a formatting mask for each country using its example number from libphonenumber.

If you don't run the init function then none of the synchronous mask formatting functions will work.

We use the same approach from `flutter_multi_formatter` for masking but instead of statically defining all of our country masks, we pull them on the fly from libphonenubmer so that the masks will be automatically maintained over time.

You can either do this during your app init before calling `RunApp`, or with a `FutureBuilder` as the example app demonstrates.

```dart
await FlutterLibphonenumber().init();
```

## Formatting a number synchronously
Normally calls to libphonenumber's format function are asynchronous, and you might not want
your UI rebuilding every time you need to format a phone number.

To get around this, we load a mask of every supported phone region's example number from libphonenumber during the `init()` call. We can then use this mask to format an e164 phone number **synchronously** like this:
```dart
final rawNumber = '+14145556666';
final formattedNumber = FlutterLibphonenumber().formatPhone(rawNumber); // +1 (414) 555-6666
```

## CountryManager
When you call init, this lib will store a list of the countries and phone metadata with the following class:
```dart
class CountryWithPhoneCode {
  final String phoneCode;   // '1'
  final String phoneMask;   // '+0 (000) 000-0000
  final String name;        // United States
  final String countryCode; // US
}
```

To access this list of countries you can get at it like this:
```dart
final countries = CountryManager().countries; // List<CountryWithPhoneCode>
final defaultLocale = CountryManager().deviceLocaleCountryCode // US
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

### `Future<Map<String, String>> format(String phone, String region)`
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

### `String formatNumberSync(String phone)`
Format a number synchronously using masks to format it. Must have ran the `init()` function to pre-populate the mask data.

If you have not run init yet, this will just return the value passed in with no changes to it.

Example response:
```dart
"1 (414) 444-4444"
```

### `Future<FormatPhoneResult> formatParsePhonenumberAsync(String phoneNumber, CountryWithPhoneCode country)`
Asynchronously formats a phone number with libphonenumber. Will return the formatted number and if it's a valid/complete number, will return the e164 value as well in the `e164` field. Uses libphonenumber's parse function to verify if it's a valid number or not.

This is useful if you want to format a number and also check if it's valid, in one step.

```dart
class FormatPhoneResult {
  String formattedNumber; // 1 (414) 444-4444
  String e164; // +14144444444
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
