
import PhoneNumberKit

#if os(iOS)
  import UIKit
  import Flutter
#elseif os(macOS)
  import AppKit
  import FlutterMacOS
#endif
// Ported from https://github.com/emostar/flutter-libphonenumber


public class FlutterLibphonenumberPlugin: NSObject, FlutterPlugin {
    let dispQueue = DispatchQueue(label: "com.couttsconsulting.flutter_libphonenumber")
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        #if os(iOS)
          let messenger = registrar.messenger()
        #else
          let messenger = registrar.messenger
        #endif
        let channel = FlutterMethodChannel(name: "com.couttsconsulting/flutter_libphonenumber_darwin", binaryMessenger: messenger)
        let instance = FlutterLibphonenumberPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch(call.method) {
        case "parse": parse(call, result: result)
        case "format": format(call, result: result)
        case "get_all_supported_regions": getAllSupportedRegions(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private let kit = PhoneNumberUtility()
    
    // Get all regions and assemble their phone mask data.
    private func getAllSupportedRegions(result: @escaping FlutterResult) {
        // Runs on a separate thread to prevent locking up the UI in flutter.
        dispQueue.async {
            var regionsMap: [String: [String: String]] = [:]
            self.kit.allCountries().forEach { (regionCode) in
                var itemMap: [String: String] = [:]
                
                if let phoneCode = self.kit.countryCode(for: regionCode) {
                    itemMap["phoneCode"] = String(phoneCode)
                    
                    if let formattedExampleNumberMobileNational = self.kit.getFormattedExampleNumber(forCountry: regionCode, ofType: .mobile, withFormat: .national) {
                        itemMap["phoneMaskMobileNational"] = self.maskNumber(phoneNumber: formattedExampleNumberMobileNational, phoneCode: phoneCode)
                        itemMap["exampleNumberMobileNational"] = formattedExampleNumberMobileNational
                    }
                    
                    if let formattedExampleNumberMobileInternational = self.kit.getFormattedExampleNumber(forCountry: regionCode, ofType: .mobile, withFormat: .international) {
                        itemMap["phoneMaskMobileInternational"] = self.maskNumber(phoneNumber: formattedExampleNumberMobileInternational, phoneCode: phoneCode)
                        itemMap["exampleNumberMobileInternational"] = formattedExampleNumberMobileInternational
                    }
                    
                    if let formattedExampleNumberFixedLineNational = self.kit.getFormattedExampleNumber(forCountry: regionCode, ofType: .fixedLine, withFormat: .national) {
                        itemMap["phoneMaskFixedLineNational"] = self.maskNumber(phoneNumber: formattedExampleNumberFixedLineNational, phoneCode: phoneCode)
                        itemMap["exampleNumberFixedLineNational"] = formattedExampleNumberFixedLineNational
                    }
                    
                    if let formattedExampleNumberFixedLineInternational = self.kit.getFormattedExampleNumber(forCountry: regionCode, ofType: .fixedLine, withFormat: .international) {
                        itemMap["phoneMaskFixedLineInternational"] = self.maskNumber(phoneNumber: formattedExampleNumberFixedLineInternational, phoneCode: phoneCode)
                        itemMap["exampleNumberFixedLineInternational"] = formattedExampleNumberFixedLineInternational
                    }
                }
                if let countryName = self.countryName(from: regionCode) {
                    itemMap["countryName"] = countryName
                }
                
                regionsMap[regionCode] = itemMap
            }
            
            DispatchQueue.main.async {
                result(regionsMap)
            }
        }
    }
    
    private func maskNumber(phoneNumber: String, phoneCode: UInt64) -> String {
        return phoneNumber.replacingOccurrences(of: "[\\d]", with: "0", options: .regularExpression)
    }
    
    private func format(_ call: FlutterMethodCall, result: FlutterResult) {
        guard
            let arguments = call.arguments as? [String : Any],
            let number = arguments["phone"] as? String,
            let region = arguments["region"] as? String
            else {
                result(FlutterError(code: "InvalidArgument",
                                    message: "The 'phone' argument is missing.",
                                    details: nil))
                return
        }
        
        let formatted = PartialFormatter(defaultRegion: region).formatPartial(number)
        let res:[String: String] = [
            "formatted": formatted
        ]
        
        result(res)
    }
    
    private func parse(phone: String, region: String?) -> [String: String]? {
        do {
            var phoneNumber: PhoneNumber
            
            if let region = region {
                phoneNumber = try kit.parse(phone, withRegion: region)
            }
            else {
                phoneNumber = try kit.parse(phone)
            }
            
            // Try to parse the string to a phone number for a given region.
            
            // If the parsing is successful, we return a dictionary containing :
            // - the number in the E164 format
            // - the number in the international format
            // - the number formatted as a national number and without the international prefix
            // - the number type (might not be 100% auccurate)
            
            return [
                "type": phoneNumber.type.toString(),
                "e164": kit.format(phoneNumber, toType: .e164),
                "international": kit.format(phoneNumber, toType: .international, withPrefix: true),
                "national": kit.format(phoneNumber, toType: .national),
                "country_code": String(phoneNumber.countryCode),
                "region_code": String(kit.getRegionCode(of: phoneNumber) ?? ""),
                "national_number": String(phoneNumber.nationalNumber)
            ]
        } catch {
            return nil;
        }
    }
    
    private func parse(_ call: FlutterMethodCall, result: FlutterResult) {
        guard
            let arguments = call.arguments as? [String : Any],
            let phone = arguments["phone"] as? String
            else {
                result(FlutterError(code: "InvalidArgument",
                                    message: "The 'string' argument is missing.",
                                    details: nil))
                return
        }
        
        let region = arguments["region"] as? String
        
        if let res = parse(phone: phone, region: region) {
            result(res)
        } else {
            result(FlutterError(code: "InvalidNumber",
                                message:"Failed to parse phone number string '\(phone)'.",
                details: nil))
        }
    }
    
    private func parseList(_ call: FlutterMethodCall, result: FlutterResult) {
        guard
            let arguments = call.arguments as? [String : Any],
            let strings = arguments["strings"] as? [String]
            else {
                result(FlutterError(code: "InvalidArgument",
                                    message: "The 'strings' argument is missing.",
                                    details: nil))
                return
        }
        
        let region = arguments["region"] as? String
        
        var res = [String: [String: String]]()
        
        strings.forEach {
            res[$0] = parse(phone: $0, region: region)
        }
        
        result(res)
    }
    
    // Returns country name from a given country code like 'US' or 'GB'
    private func countryName(from countryCode: String) -> String? {
        if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode) {
            // Country name was found
            return name
        } else {
            // Country name cannot be found
            return nil
        }
    }
}

extension PhoneNumberType {
    func toString() -> String {
        switch self {
        case .fixedLine: return "fixedLine"
        case .mobile: return "mobile"
        case .fixedOrMobile: return "fixedOrMobile"
        case .notParsed: return "notParsed"
        case .pager: return "pager"
        case .personalNumber: return "personalNumber"
        case .premiumRate: return "premiumRate"
        case .sharedCost: return "sharedCost"
        case .tollFree: return "tollFree"
        case .uan: return "uan"
        case .unknown: return "unknown"
        case .voicemail: return "voicemail"
        case .voip: return "voip"
        }
    }
}

extension NSRegularExpression {
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}
