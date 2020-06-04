# flutter_libphonenumber

A wrapper around libphonenumber with added functionality merged from the following libs:
* https://github.com/nashfive/phone_number
* https://github.com/anoop4real/flutter_iso_countries
* https://github.com/caseyryan/flutter_multi_formatter

## Getting Started
First you need to call the `init` function. This will load all of the available regions available on the device, and then cross-reference them with libphonenumber to build a formatting mask for each region using an example number from libphonenumber.

This is an improvement on the approach in `flutter_multi_formatter` because we simply pull all of the phone pattern mask data from libphonenumber and don't need to manage it.

```dart
await FlutterLibphonenumber().init();
```

You can either do this during your app init before calling `RunApp`, or with a `FutureBuilder` as the example app demonstrates.

## Formatting as you type
To format in real-time as you type, you can add `LibPhonenumberTextFormatter()` to your `TextField`:
```dart
TextField(inputFormatters: [LibPhonenumberTextFormatter()])
```
This will automatically detect the country from the number and try to format it correctly. The number should include the country code at the start

## Formatting a number synchronously
Normally calls to libphonenumber's format function are asynchronous, and you might not want
your UI to have to wait every time you need to format a phone number.

To get around this, we loaded a mask of every supported phone region during the `init()` call. We can use this to format an e164 formatted number synchronously like this:
```dart
final formattedNumber = FlutterLibphonenumber().formatPhone(rawNumber);
```

# API Reference
Here is a reference of all of the supported libphonenumber functionality.
### `Future<Map<String, dynamic>> getAllSupportedRegions()`
Loads all of the available regions on the device and returns a map with each key as the region code, and the value as a map containing the `phoneMask` and `phoneCode`.

Example response:
```dart
{
    "US": {
        "phoneCode": "1",
        "phoneMask": "+0 (000) 000-0000"
    }
}
```

### `Future<Map<String, dynamic>> parse(String phone, {String region})`
Parses a number and if it is full and complete, returns some metadata associated with the number. The number must be a valid and compelte e164 formatted number to be considered valid.

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

### `Future<Map<String, dynamic>> format(String phone, String region)`
Format a number asynchronously by calling into libphonenumber on the device.

Example response:
```dart
{
    formatted: "1 (414) 444-4444",
}
```

### `String formatPhone(String phone)`
Format a number synchronously using the masks we loaded.

Example response:
```dart
"1 (414) 444-4444"
```