import 'dart:convert';

import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('getAllSupportedRegions returns sane data', (final tester) async {
    final stopwatch = Stopwatch()..start();
    final res = await getAllSupportedRegions();
    stopwatch.stop();

    expect(res.length, greaterThan(200));

    final us = res['US']!;
    expect(us.phoneCode, '1');
    expect(us.exampleNumberMobileNational, isNotEmpty);
    expect(us.phoneMaskMobileNational, contains('0'));
    expect(us.phoneMaskMobileNational, isNot(matches(RegExp('[1-9]'))));

    // Dump a stable serialization of every region for cross-branch diffing.
    final sortedKeys = res.keys.toList()..sort();
    final dump = StringBuffer();
    for (final key in sortedKeys) {
      final c = res[key]!;
      dump.writeln(
        jsonEncode({
          'region': key,
          'phoneCode': c.phoneCode,
          'countryName': c.countryName,
          'exampleNumberMobileNational': c.exampleNumberMobileNational,
          'exampleNumberFixedLineNational': c.exampleNumberFixedLineNational,
          'phoneMaskMobileNational': c.phoneMaskMobileNational,
          'phoneMaskFixedLineNational': c.phoneMaskFixedLineNational,
          'exampleNumberMobileInternational': c.exampleNumberMobileInternational,
          'exampleNumberFixedLineInternational': c.exampleNumberFixedLineInternational,
          'phoneMaskMobileInternational': c.phoneMaskMobileInternational,
          'phoneMaskFixedLineInternational': c.phoneMaskFixedLineInternational,
        }),
      );
    }
    // FNV-1a 64-bit hash of the dump: a stable one-line digest so two
    // branches can be compared even if log streaming is cut off.
    var hash = 0xcbf29ce484222325;
    for (final unit in dump.toString().codeUnits) {
      hash ^= unit;
      hash = (hash * 0x100000001b3) & 0xFFFFFFFFFFFFFFFF;
    }
    // ignore: avoid_print
    print(
      'REGION_DIGEST regions=${res.length} '
      'fnv1a=${hash.toRadixString(16)} '
      'elapsedMs=${stopwatch.elapsedMilliseconds}',
    );
    // ignore: avoid_print
    print('REGION_DUMP_START');
    for (final line in dump.toString().split('\n')) {
      // ignore: avoid_print
      print(line);
    }
    // ignore: avoid_print
    print('REGION_DUMP_END');
  });
}
