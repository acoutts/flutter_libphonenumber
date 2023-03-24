// BSD 3-Clause License

// Copyright (c) 2022, Julian Steenbakker
// All rights reserved.

// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:

// 1. Redistributions of source code must retain the above copyright notice, this
//    list of conditions and the following disclaimer.

// 2. Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation
//    and/or other materials provided with the distribution.

// 3. Neither the name of the copyright holder nor the names of its
//    contributors may be used to endorse or promote products derived from
//    this software without specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import 'dart:async';
import 'dart:html' as html;
import 'dart:js' show context, JsObject;

import 'package:flutter_libphonenumber_web/src/base.dart';

Future<void> loadScript(final JsLibrary library) async {
  dynamic amd;
  dynamic define;
  // ignore: avoid_dynamic_calls
  if (library.usesRequireJs && context['define']?['amd'] != null) {
    // In dev, requireJs is loaded in. Disable it here.
    // see https://github.com/dart-lang/sdk/issues/33979
    define = JsObject.fromBrowserObject(context['define'] as Object);
    // ignore: avoid_dynamic_calls
    amd = define['amd'];
    // ignore: avoid_dynamic_calls
    define['amd'] = false;
  }
  try {
    await loadScriptUsingScriptTag(library.url);
  } finally {
    if (amd != null) {
      // Re-enable requireJs
      // ignore: avoid_dynamic_calls
      define['amd'] = amd;
    }
  }
}

Future<void> loadScriptUsingScriptTag(final String url) {
  final script = html.ScriptElement()
    ..async = true
    ..defer = false
    ..crossOrigin = 'anonymous'
    ..type = 'text/javascript'
    // ignore: unsafe_html
    ..src = url;

  html.document.head!.append(script);

  return script.onLoad.first;
}

/// Injects JS [libraries]
///
/// Returns a [Future] that resolves when all of the `script` tags `onLoad` events trigger.
Future<void> injectJSLibraries(final List<JsLibrary> libraries) {
  final List<Future<void>> loading = [];

  for (final library in libraries) {
    final future = loadScript(library);
    loading.add(future);
  }

  return Future.wait(loading);
}
