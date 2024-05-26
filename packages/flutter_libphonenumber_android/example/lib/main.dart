// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_libphonenumber_platform_interface/flutter_libphonenumber_platform_interface.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final _future = FlutterLibphonenumberPlatform.instance.init();
  final phoneController = TextEditingController();
  final countryController = TextEditingController(text: 'United States');
  final manualFormatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    updatePlaceholderHint();
  }

  /// Result when we call the parse method.
  String? parsedData;

  /// Used to format numbers as mobile or land line
  var _globalPhoneType = PhoneNumberType.mobile;

  /// Use international or national phone format
  var _globalPhoneFormat = PhoneNumberFormat.international;

  /// Current selected country
  var _currentSelectedCountry = const CountryWithPhoneCode.us();

  var _placeholderHint = '';

  var _inputContainsCountryCode = true;

  /// Keep cursor on the end
  var _shouldKeepCursorAtEndOfInput = true;

  void updatePlaceholderHint() {
    late String newPlaceholder;

    if (_globalPhoneType == PhoneNumberType.mobile) {
      if (_globalPhoneFormat == PhoneNumberFormat.international) {
        newPlaceholder = _currentSelectedCountry.exampleNumberMobileInternational;
      } else {
        newPlaceholder = _currentSelectedCountry.exampleNumberMobileNational;
      }
    } else {
      if (_globalPhoneFormat == PhoneNumberFormat.international) {
        newPlaceholder = _currentSelectedCountry.exampleNumberFixedLineInternational;
      } else {
        newPlaceholder = _currentSelectedCountry.exampleNumberFixedLineNational;
      }
    }

    /// Strip country code from hint
    if (!_inputContainsCountryCode) {
      newPlaceholder = newPlaceholder.substring(_currentSelectedCountry.phoneCode.length + 2);
    }

    setState(() => _placeholderHint = newPlaceholder);
  }

  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<void>(
        future: _future,
        builder: (final context, final snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                title: const Text('flutter_libphonenumber'),
              ),
              body: Center(
                child: Text('error: ${snapshot.error}'),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                appBar: AppBar(
                  title: const Text('flutter_libphonenumber'),
                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: max(
                        0,
                        24 - MediaQuery.of(context).padding.bottom,
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),

                        /// Get all region codes
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  /// Print region data
                                  ElevatedButton(
                                    child: const Text('Print all region data'),
                                    onPressed: () async {
                                      // await FlutterLibphonenumber().init();

                                      final res = await FlutterLibphonenumberPlatform.instance.getAllSupportedRegions();
                                      print(res['IT']);
                                      print(res['US']);
                                      print(res['BR']);
                                    },
                                  ),

                                  /// Spacer
                                  const SizedBox(height: 12),

                                  /// Country code input
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                    ),
                                    child: TextField(
                                      controller: countryController,
                                      keyboardType: TextInputType.phone,
                                      onChanged: (final v) {
                                        setState(() {});
                                      },
                                      textAlign: TextAlign.center,
                                      onTap: () async {
                                        final sortedCountries = CountryManager().countries
                                          ..sort(
                                            (final a, final b) => (a.countryName ?? '').compareTo(
                                              b.countryName ?? '',
                                            ),
                                          );
                                        final res = await showModalBottomSheet<CountryWithPhoneCode>(
                                          context: context,
                                          isScrollControlled: false,
                                          builder: (final context) {
                                            return ListView.builder(
                                              padding: const EdgeInsets.symmetric(
                                                vertical: 16,
                                              ),
                                              itemBuilder: (final context, final index) {
                                                final item = sortedCountries[index];
                                                return GestureDetector(
                                                  behavior: HitTestBehavior.opaque,
                                                  onTap: () {
                                                    Navigator.of(context).pop(item);
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 24,
                                                      vertical: 16,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        /// Phone code
                                                        Expanded(
                                                          child: Text(
                                                            '+${item.phoneCode}',
                                                            textAlign: TextAlign.right,
                                                          ),
                                                        ),

                                                        /// Spacer
                                                        const SizedBox(
                                                          width: 16,
                                                        ),

                                                        /// Name
                                                        Expanded(
                                                          flex: 8,
                                                          child: Text(
                                                            item.countryName ?? '',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                              itemCount: sortedCountries.length,
                                            );
                                          },
                                        );

                                        print('New country selection: $res');

                                        if (res != null) {
                                          setState(() {
                                            _currentSelectedCountry = res;
                                          });

                                          updatePlaceholderHint();

                                          countryController.text = res.countryName ?? '+ ${res.phoneCode}';
                                        }
                                      },
                                      readOnly: true,
                                      inputFormatters: const [],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// Spacer
                            const SizedBox(width: 20),

                            Expanded(
                              child: Column(
                                children: [
                                  /// Mobile or land line toggle
                                  Row(
                                    children: [
                                      Switch(
                                        value: _globalPhoneType == PhoneNumberType.mobile ? true : false,
                                        onChanged: (final val) {
                                          setState(
                                            () => _globalPhoneType = val == false ? PhoneNumberType.fixedLine : PhoneNumberType.mobile,
                                          );
                                          updatePlaceholderHint();
                                        },
                                      ),

                                      /// Spacer
                                      const SizedBox(width: 5),

                                      Flexible(
                                        child: _globalPhoneType == PhoneNumberType.mobile ? const Text('Format as Mobile') : const Text('Format as FixedLine'),
                                      ),
                                    ],
                                  ),

                                  /// National or international line toggle
                                  Row(
                                    children: [
                                      Switch(
                                        value: _globalPhoneFormat == PhoneNumberFormat.national ? true : false,
                                        onChanged: (final val) {
                                          setState(
                                            () => _globalPhoneFormat = val == false ? PhoneNumberFormat.international : PhoneNumberFormat.national,
                                          );
                                          updatePlaceholderHint();
                                        },
                                      ),

                                      /// Spacer
                                      const SizedBox(width: 5),

                                      Flexible(
                                        child: _globalPhoneFormat == PhoneNumberFormat.national ? const Text('National') : const Text('International'),
                                      ),
                                    ],
                                  ),

                                  /// Format assuming country code present or absent
                                  Row(
                                    children: [
                                      Switch(
                                        value: _inputContainsCountryCode,
                                        onChanged: (final val) {
                                          setState(
                                            () => _inputContainsCountryCode = !_inputContainsCountryCode,
                                          );
                                          updatePlaceholderHint();
                                        },
                                      ),

                                      /// Spacer
                                      const SizedBox(width: 5),

                                      Flexible(
                                        child: _inputContainsCountryCode ? const Text('With country code') : const Text('No country code'),
                                      ),
                                    ],
                                  ),

                                  /// Toggle keeping the cursor in the same spot as it was when inputting, allowing
                                  /// user to edit the middle of the input.
                                  Row(
                                    children: [
                                      Switch(
                                        value: _shouldKeepCursorAtEndOfInput,
                                        onChanged: (final val) {
                                          setState(
                                            () => _shouldKeepCursorAtEndOfInput = !_shouldKeepCursorAtEndOfInput,
                                          );
                                          updatePlaceholderHint();
                                        },
                                      ),

                                      /// Spacer
                                      const SizedBox(width: 5),

                                      const Flexible(
                                        child: Text('Force cursor to end'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        /// Spacer
                        const SizedBox(height: 10),
                        const Divider(),
                        const SizedBox(height: 10),

                        /// Format as you type
                        const Text(
                          'Format as you type (synchronous using masks)',
                        ),

                        /// Phone input
                        SizedBox(
                          width: 160,
                          child: TextField(
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.phone,
                            controller: phoneController,
                            decoration: InputDecoration(
                              hintText: _placeholderHint,
                            ),
                            inputFormatters: [
                              LibPhonenumberTextFormatter(
                                phoneNumberType: _globalPhoneType,
                                phoneNumberFormat: _globalPhoneFormat,
                                country: _currentSelectedCountry,
                                inputContainsCountryCode: _inputContainsCountryCode,
                                shouldKeepCursorAtEndOfInput: _shouldKeepCursorAtEndOfInput,
                              ),
                            ],
                          ),
                        ),

                        /// Spacer
                        const SizedBox(height: 10),

                        const Text(
                          'If country code is not empty, phone number will format expecting no country code.',
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),

                        /// Spacer
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 20),

                        const Text(
                          'Manually format / parse the phone number.\nAsync uses FlutterLibphonenumber().format().\nSync uses FlutterLibphonenumber().formatPhone.',
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),

                        /// Manual Phone input
                        SizedBox(
                          width: 180,
                          child: TextField(
                            keyboardType: TextInputType.phone,
                            textAlign: TextAlign.center,
                            controller: manualFormatController,
                            decoration: InputDecoration(
                              hintText: _placeholderHint,
                            ),
                          ),
                        ),

                        /// Spacer
                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /// Manually format the phone input
                            Flexible(
                              child: ElevatedButton(
                                child: const Text(
                                  'Format (Async)',
                                  textAlign: TextAlign.center,
                                ),
                                onPressed: () async {
                                  // Asynchronous formatting with native call into libphonenumber
                                  final res = await FlutterLibphonenumberPlatform.instance.format(
                                    manualFormatController.text,
                                    _currentSelectedCountry.countryCode,
                                  );
                                  setState(
                                    () => manualFormatController.text = res['formatted'] ?? '',
                                  );
                                },
                              ),
                            ),

                            /// Spacer
                            const SizedBox(width: 10),

                            Flexible(
                              child: ElevatedButton(
                                child: const Text(
                                  'Format (Sync)',
                                  textAlign: TextAlign.center,
                                ),
                                onPressed: () async {
                                  if (CountryManager().countries.isEmpty) {
                                    print(
                                      "Warning: countries list is empty which means init hs not be run yet. Can't format synchronously until init has been executed.",
                                    );
                                  }
                                  // Synchronous formatting with no native call into libphonenumber, just a dart call to mask the input
                                  manualFormatController.text = FlutterLibphonenumberPlatform.instance.formatNumberSync(
                                    manualFormatController.text,
                                    country: _currentSelectedCountry,
                                    phoneNumberType: _globalPhoneType,
                                    phoneNumberFormat: _globalPhoneFormat,
                                    inputContainsCountryCode: _inputContainsCountryCode,
                                  );
                                },
                              ),
                            ),

                            /// Spacer
                            const SizedBox(width: 10),

                            /// Manually format the phone input
                            Flexible(
                              child: ElevatedButton(
                                child: const Text(
                                  'Parse',
                                  textAlign: TextAlign.center,
                                ),
                                onPressed: () async {
                                  try {
                                    final res = await FlutterLibphonenumberPlatform.instance.parse(
                                      manualFormatController.text,
                                      region: _currentSelectedCountry.countryCode,
                                    );

                                    const JsonEncoder encoder = JsonEncoder.withIndent('  ');

                                    setState(
                                      () => parsedData = encoder.convert(res),
                                    );
                                  } catch (e) {
                                    print(e);
                                    setState(() => parsedData = null);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),

                        /// Spacer
                        const SizedBox(height: 10),

                        Text(parsedData ?? 'Number invalid'),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                title: const Text('flutter_libphonenumber'),
              ),
              body: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
