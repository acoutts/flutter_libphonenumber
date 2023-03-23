#import "FlutterLibphonenumberPlugin.h"
#if __has_include(<flutter_libphonenumber_ios/flutter_libphonenumber_ios-Swift.h>)
#import <flutter_libphonenumber_ios/flutter_libphonenumber_ios-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_libphonenumber_ios-Swift.h"
#endif

@implementation FlutterLibphonenumberPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterLibphonenumberPlugin registerWithRegistrar:registrar];
}
@end
