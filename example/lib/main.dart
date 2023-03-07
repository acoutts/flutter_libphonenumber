import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final initFuture = FlutterLibphonenumber().init();
  final phoneController = TextEditingController();
  final countryController = TextEditingController(text: 'United States');
  final manualFormatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    updatePlaceholderHint();
  }

  String? parsedData;

  /// Used to format numbers as mobile or land line
  var globalPhoneType = PhoneNumberType.mobile;

  /// Use international or national phone format
  var globalPhoneFormat = PhoneNumberFormat.international;

  /// Current selected country
  var currentSelectedCountry = CountryWithPhoneCode.us();

  var placeholderHint = '';

  var inputContainsCountryCode = true;

  /// Keep cursor on the end
  var shouldKeepCursorAtEndOfInput = true;

  void updatePlaceholderHint() {
    late String newPlaceholder;

    if (globalPhoneType == PhoneNumberType.mobile) {
      if (globalPhoneFormat == PhoneNumberFormat.international) {
        newPlaceholder =
            currentSelectedCountry.exampleNumberMobileInternational;
      } else {
        newPlaceholder = currentSelectedCountry.exampleNumberMobileNational;
      }
    } else {
      if (globalPhoneFormat == PhoneNumberFormat.international) {
        newPlaceholder =
            currentSelectedCountry.exampleNumberFixedLineInternational;
      } else {
        newPlaceholder = currentSelectedCountry.exampleNumberFixedLineNational;
      }
    }

    /// Strip country code from hint
    if (!inputContainsCountryCode) {
      newPlaceholder =
          newPlaceholder.substring(currentSelectedCountry.phoneCode.length + 2);
    }

    setState(() => placeholderHint = newPlaceholder);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder<void>(
        future: initFuture,
        builder: (context, snapshot) {
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
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      bottom: max(
                        0,
                        24 - MediaQuery.of(context).padding.bottom,
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 10),

                        /// Get all region codes
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  /// Print region data
                                  ElevatedButton(
                                    child: Text('Print all region data'),
                                    onPressed: () async {
                                      // await FlutterLibphonenumber().init();

                                      final res = await FlutterLibphonenumber()
                                          .getAllSupportedRegions();
                                      print(res['IT']);
                                      print(res['US']);
                                      print(res['BR']);
                                    },
                                  ),

                                  /// Spacer
                                  SizedBox(height: 12),

                                  /// Country code input
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 24),
                                    child: TextField(
                                      controller: countryController,
                                      keyboardType: TextInputType.phone,
                                      onChanged: (v) {
                                        setState(() {});
                                      },
                                      textAlign: TextAlign.center,
                                      onTap: () async {
                                        final sortedCountries = CountryManager()
                                            .countries
                                          ..sort((a, b) => (a.countryName ?? '')
                                              .compareTo(b.countryName ?? ''));
                                        final res = await showModalBottomSheet<
                                            CountryWithPhoneCode>(
                                          context: context,
                                          isScrollControlled: false,
                                          builder: (context) {
                                            return ListView.builder(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 16),
                                              itemBuilder: (context, index) {
                                                final item =
                                                    sortedCountries[index];
                                                return GestureDetector(
                                                  behavior:
                                                      HitTestBehavior.opaque,
                                                  onTap: () {
                                                    Navigator.of(context)
                                                        .pop(item);
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 24,
                                                            vertical: 16),
                                                    child: Row(
                                                      children: [
                                                        /// Phone code
                                                        Expanded(
                                                          child: Text(
                                                            '+' +
                                                                item.phoneCode,
                                                            textAlign:
                                                                TextAlign.right,
                                                          ),
                                                        ),

                                                        /// Spacer
                                                        SizedBox(width: 16),

                                                        /// Name
                                                        Expanded(
                                                          flex: 8,
                                                          child: Text(
                                                              item.countryName ??
                                                                  ''),
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
                                            currentSelectedCountry = res;
                                          });

                                          updatePlaceholderHint();

                                          countryController.text =
                                              res.countryName ??
                                                  '+ ${res.phoneCode}';
                                        }
                                      },
                                      readOnly: true,
                                      inputFormatters: [],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// Spacer
                            SizedBox(width: 20),

                            Expanded(
                              child: Column(
                                children: [
                                  /// Mobile or land line toggle
                                  Row(
                                    children: [
                                      Switch(
                                        value: globalPhoneType ==
                                                PhoneNumberType.mobile
                                            ? true
                                            : false,
                                        onChanged: (val) {
                                          setState(
                                            () => globalPhoneType =
                                                (val == false
                                                    ? PhoneNumberType.fixedLine
                                                    : PhoneNumberType.mobile),
                                          );
                                          updatePlaceholderHint();
                                        },
                                      ),

                                      /// Spacer
                                      SizedBox(width: 5),

                                      Flexible(
                                        child: globalPhoneType ==
                                                PhoneNumberType.mobile
                                            ? Text('Format as Mobile')
                                            : Text('Format as FixedLine'),
                                      ),
                                    ],
                                  ),

                                  /// National or international line toggle
                                  Row(
                                    children: [
                                      Switch(
                                        value: globalPhoneFormat ==
                                                PhoneNumberFormat.national
                                            ? true
                                            : false,
                                        onChanged: (val) {
                                          setState(
                                            () => globalPhoneFormat = (val ==
                                                    false
                                                ? PhoneNumberFormat
                                                    .international
                                                : PhoneNumberFormat.national),
                                          );
                                          updatePlaceholderHint();
                                        },
                                      ),

                                      /// Spacer
                                      SizedBox(width: 5),

                                      Flexible(
                                        child: globalPhoneFormat ==
                                                PhoneNumberFormat.national
                                            ? Text('National')
                                            : Text('International'),
                                      ),
                                    ],
                                  ),

                                  /// Format assuming country code present or absent
                                  Row(
                                    children: [
                                      Switch(
                                        value: inputContainsCountryCode,
                                        onChanged: (val) {
                                          setState(
                                            () => inputContainsCountryCode =
                                                !inputContainsCountryCode,
                                          );
                                          updatePlaceholderHint();
                                        },
                                      ),

                                      /// Spacer
                                      SizedBox(width: 5),

                                      Flexible(
                                        child: inputContainsCountryCode
                                            ? Text('With country code')
                                            : Text('No country code'),
                                      ),
                                    ],
                                  ),

                                  /// Toggle keeping the cursor in the same spot as it was when inputting, allowing
                                  /// user to edit the middle of the input.
                                  Row(
                                    children: [
                                      Switch(
                                        value: shouldKeepCursorAtEndOfInput,
                                        onChanged: (val) {
                                          setState(
                                            () => shouldKeepCursorAtEndOfInput =
                                                !shouldKeepCursorAtEndOfInput,
                                          );
                                          updatePlaceholderHint();
                                        },
                                      ),

                                      /// Spacer
                                      SizedBox(width: 5),

                                      Flexible(
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
                        SizedBox(height: 10),
                        Divider(),
                        SizedBox(height: 10),

                        /// Format as you type
                        Text('Format as you type (synchronous using masks)'),

                        /// Phone input
                        Container(
                          width: 160,
                          child: TextField(
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.phone,
                            controller: phoneController,
                            decoration: InputDecoration(
                              hintText: placeholderHint,
                            ),
                            inputFormatters: [
                              LibPhonenumberTextFormatter(
                                phoneNumberType: globalPhoneType,
                                phoneNumberFormat: globalPhoneFormat,
                                country: currentSelectedCountry,
                                inputContainsCountryCode:
                                    inputContainsCountryCode,
                                shouldKeepCursorAtEndOfInput:
                                    shouldKeepCursorAtEndOfInput,
                              ),
                            ],
                          ),
                        ),

                        /// Spacer
                        SizedBox(height: 10),

                        Text(
                          'If country code is not empty, phone number will format expecting no country code.',
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),

                        /// Spacer
                        SizedBox(height: 20),
                        Divider(),
                        SizedBox(height: 20),

                        Text(
                          'Manually format / parse the phone number.\nAsync uses FlutterLibphonenumber().format().\nSync uses FlutterLibphonenumber().formatPhone.',
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.center,
                        ),

                        /// Manual Phone input
                        Container(
                          width: 180,
                          child: TextField(
                            keyboardType: TextInputType.phone,
                            textAlign: TextAlign.center,
                            controller: manualFormatController,
                            decoration: InputDecoration(
                              hintText: placeholderHint,
                            ),
                          ),
                        ),

                        /// Spacer
                        SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /// Manually format the phone input
                            Flexible(
                              child: ElevatedButton(
                                child: Text(
                                  'Format (Async)',
                                  textAlign: TextAlign.center,
                                ),
                                onPressed: () async {
                                  // Asynchronous formatting with native call into libphonenumber
                                  final res =
                                      await FlutterLibphonenumber().format(
                                    manualFormatController.text,
                                    currentSelectedCountry.countryCode,
                                  );
                                  setState(
                                    () => manualFormatController.text =
                                        res['formatted'] ?? '',
                                  );
                                },
                              ),
                            ),

                            /// Spacer
                            SizedBox(width: 10),

                            Flexible(
                              child: ElevatedButton(
                                child: Text(
                                  'Format (Sync)',
                                  textAlign: TextAlign.center,
                                ),
                                onPressed: () async {
                                  if (CountryManager().countries.isEmpty) {
                                    print(
                                        'Warning: countries list is empty which means init hs not be run yet. Can\'t format synchronously until init has been executed.');
                                  }
                                  // Synchronous formatting with no native call into libphonenumber, just a dart call to mask the input
                                  manualFormatController.text =
                                      FlutterLibphonenumber().formatNumberSync(
                                    manualFormatController.text,
                                    country: currentSelectedCountry,
                                    phoneNumberType: globalPhoneType,
                                    phoneNumberFormat: globalPhoneFormat,
                                    inputContainsCountryCode:
                                        inputContainsCountryCode,
                                  );
                                },
                              ),
                            ),

                            /// Spacer
                            SizedBox(width: 10),

                            /// Manually format the phone input
                            Flexible(
                              child: ElevatedButton(
                                child: Text(
                                  'Parse',
                                  textAlign: TextAlign.center,
                                ),
                                onPressed: () async {
                                  try {
                                    final res =
                                        await FlutterLibphonenumber().parse(
                                      manualFormatController.text,
                                      region:
                                          currentSelectedCountry.countryCode,
                                    );

                                    JsonEncoder encoder =
                                        JsonEncoder.withIndent('  ');

                                    setState(() =>
                                        parsedData = encoder.convert(res));
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
                        SizedBox(height: 10),

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
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
