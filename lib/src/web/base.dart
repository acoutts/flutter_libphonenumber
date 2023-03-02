import 'package:js/js.dart';

class JsLibrary {
  /// The name of global variable where library is stored.
  /// Used to properly import the library if [usesRequireJs] flag is true
  final String contextName;
  final String url;

  /// If js code checks for 'define' variable.
  /// E.g. if at the beginning you see code like
  /// if (typeof define === "function" && define.amd)
  final bool usesRequireJs;

  const JsLibrary({
    required this.contextName,
    required this.url,
    required this.usesRequireJs,
  });
}

@JS('Promise')
@staticInterop
class Promise<T> {}

@JS('Map')
@staticInterop
class JsMap {
  external factory JsMap();
}

extension JsMapExt on JsMap {
  external void set(dynamic key, dynamic value);
  external dynamic get(dynamic key);
}
