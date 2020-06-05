import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  final phoneController = TextEditingController();
  final countryController = TextEditingController(text: '+44');
  final manualFormatController = TextEditingController();
  String parsedData;

  // final initFuture = FlutterLibphonenumber().init();
  final initFuture = Future.delayed(Duration(milliseconds: 100), () {});

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
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      /// Get all region codes
                      RaisedButton(
                        child: Text('Print all region codes'),
                        onPressed: () async {
                          await FlutterLibphonenumber().init();

                          final res = await FlutterLibphonenumber()
                              .getAllSupportedRegions();
                          print(res);
                        },
                      ),

                      /// Spacer
                      SizedBox(height: 30),

                      /// Format as you type
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// Country code input
                          Container(
                            width: 50,
                            child: TextField(
                              controller: countryController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: '+44',
                              ),
                              onChanged: (v) {
                                setState(() {});
                              },
                              inputFormatters: [],
                            ),
                          ),

                          /// Spacer
                          SizedBox(width: 30),

                          /// Phone input
                          Container(
                            width: 160,
                            child: TextField(
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.phone,
                              controller: phoneController,
                              decoration: InputDecoration(
                                hintText: '7777-777777',
                              ),
                              inputFormatters: [
                                LibPhonenumberTextFormatter(
                                  overrideSkipCountryCode:
                                      countryController.text.isNotEmpty
                                          ? CountryManager()
                                              .countries
                                              .firstWhere(
                                                  (element) =>
                                                      element.phoneCode ==
                                                      countryController.text
                                                          .replaceAll(
                                                              RegExp(r'[^\d]+'),
                                                              ''),
                                                  orElse: () => null)
                                              ?.countryCode
                                          : null,
                                  onCountrySelected: (val) {
                                    print('Detected country: ${val?.name}');
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      /// Spacer
                      SizedBox(height: 50),

                      /// Manual Phone input
                      Container(
                        width: 160,
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: manualFormatController,
                          decoration: InputDecoration(
                            hintText: '7777-777777',
                          ),
                        ),
                      ),

                      /// Manually format the phone input
                      RaisedButton(
                        child: Text('Manually format'),
                        onPressed: () async {
                          // Asynchronous formatting with native call into libphonenumber
                          final res = await FlutterLibphonenumber().format(
                            manualFormatController.text,
                            'US',
                          );
                          print(res);
                          setState(() =>
                              manualFormatController.text = res['formatted']);

                          /// Uncomment below to do the formatting synchronously with masking
                          // setState(() => manualFormatController.text =
                          //     FlutterLibphonenumber()
                          //         .formatPhone(manualFormatController.text));
                        },
                      ),

                      /// Spacer
                      SizedBox(height: 10),

                      /// Manually format the phone input
                      RaisedButton(
                        child: Text('Parse number'),
                        onPressed: () async {
                          try {
                            final res = await FlutterLibphonenumber()
                                .parse(manualFormatController.text);

                            print(res);
                            JsonEncoder encoder = JsonEncoder.withIndent('  ');

                            setState(() => parsedData = encoder.convert(res));
                          } catch (e) {
                            print(e);
                            setState(() => parsedData = null);
                          }
                        },
                      ),

                      /// Spacer
                      SizedBox(height: 10),

                      Text(parsedData == null ? 'Number invalid' : parsedData),
                    ],
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
