import 'package:flutter/services.dart';
import 'package:flutter_libphonenumber_platform_interface/flutter_libphonenumber_platform_interface.dart';

const _channel = MethodChannel('com.bottlepay/flutter_libphonenumber');

/// An implementation of [FlutterLibphonenumberPlatform] that uses method channels.
class MethodChannelFlutterLibphonenumber extends FlutterLibphonenumberPlatform {
  MethodChannelFlutterLibphonenumber();

  @override
  Future<Map<String, String>> format(
    final String phone,
    final String region,
  ) async {
    return await _channel.invokeMapMethod<String, String>('format', {
          'phone': phone,
          'region': region,
        }) ??
        <String, String>{};
  }

  @override
  Future<Map<String, CountryWithPhoneCode>> getAllSupportedRegions() async {
    final result = await _channel
            .invokeMapMethod<String, dynamic>('get_all_supported_regions') ??
        {};

    final returnMap = <String, CountryWithPhoneCode>{};
    result.forEach(
      (final k, final v) => returnMap[k] = CountryWithPhoneCode(
        countryName: v['countryName'] ?? '',
        phoneCode: v['phoneCode'] ?? '',
        countryCode: k,
        exampleNumberMobileNational: v['exampleNumberMobileNational'] ?? '',
        exampleNumberFixedLineNational:
            v['exampleNumberFixedLineNational'] ?? '',
        phoneMaskMobileNational: v['phoneMaskMobileNational'] ?? '',
        phoneMaskFixedLineNational: v['phoneMaskFixedLineNational'] ?? '',
        exampleNumberMobileInternational:
            v['exampleNumberMobileInternational'] ?? '',
        exampleNumberFixedLineInternational:
            v['exampleNumberFixedLineInternational'] ?? '',
        phoneMaskMobileInternational: v['phoneMaskMobileInternational'] ?? '',
        phoneMaskFixedLineInternational:
            v['phoneMaskFixedLineInternational'] ?? '',
      ),
    );
    return returnMap;
  }

  @override
  Future<Map<String, dynamic>> parse(
    final String phone, {
    final String? region,
  }) async {
    return await _channel.invokeMapMethod<String, dynamic>('parse', {
          'phone': phone,
          'region': region,
        }) ??
        <String, dynamic>{};
  }

  @override
  Future<void> init({
    final Map<String, CountryWithPhoneCode> overrides = const {},
  }) async {
    return CountryManager().loadCountries(
      phoneCodesMap: await getAllSupportedRegions(),
      overrides: overrides,
    );
  }
}
