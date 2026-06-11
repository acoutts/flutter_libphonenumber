#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_libphonenumber.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name = "flutter_libphonenumber_darwin"
  s.version = "1.0.0"
  s.summary = "Leverages libphonenumber to allow for asynchronous and synchronous formatting of phone numbers in Flutter apps. Includes a TextInputFormatter to allow real-time AsYouType formatting."
  s.description = <<-DESC
  Leverages libphonenumber to allow for asynchronous and synchronous formatting of phone numbers in Flutter apps. Includes a TextInputFormatter to allow real-time AsYouType formatting.
                       DESC
  s.homepage = "https://github.com/acoutts/flutter_libphonenumber"
  s.license = { :file => "../LICENSE" }
  s.author = { "Andrew Coutts" => "andrew@coutts-consulting.com" }
  s.source = { :path => "." }
  s.source_files = "flutter_libphonenumber_darwin/Sources/flutter_libphonenumber_darwin/**/*.swift"

  # Set the deployment targets for both iOS and macOS.
  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '10.15'

  # Define the platform-specific dependencies.
  s.ios.dependency 'Flutter'
  s.osx.dependency 'FlutterMacOS'
  s.dependency "PhoneNumberKit/PhoneNumberKitCore", "4.2.1"

  # Flutter.framework does not contain a i386 slice, which is specific to iOS.
  s.ios.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.osx.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }

  s.swift_version = "5.0"
  s.resource_bundles = {'flutter_libphonenumber_darwin_privacy' => ['flutter_libphonenumber_darwin/Sources/flutter_libphonenumber_darwin/PrivacyInfo.xcprivacy']}
end
