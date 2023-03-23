#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_libphonenumber.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name = "flutter_libphonenumber_ios"
  s.version = "1.0.0"
  s.summary = "Leverages libphonenumber to allow for asynchronous and synchronous formatting of phone numbers in Flutter apps. Includes a TextInputFormatter to allow real-time AsYouType formatting."
  s.description = <<-DESC
  Leverages libphonenumber to allow for asynchronous and synchronous formatting of phone numbers in Flutter apps. Includes a TextInputFormatter to allow real-time AsYouType formatting.
                       DESC
  s.homepage = "https://github.com/bottlepay/flutter_libphonenumber"
  s.license = { :file => "../LICENSE" }
  s.author = { "Andrew Coutts" => "andrew.coutts@bottlepay.com" }
  s.source = { :path => "." }
  s.source_files = "Classes/**/*"
  s.dependency "Flutter"
  s.dependency "PhoneNumberKit/PhoneNumberKitCore", "3.3.4"
  s.platform = :ios, "9.0"

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { "DEFINES_MODULE" => "YES", "VALID_ARCHS[sdk=iphonesimulator*]" => "x86_64" }
  s.swift_version = "5.0"
end
