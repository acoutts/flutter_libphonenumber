class PhoneMask {
  PhoneMask(this.mask);
  final String mask;
  final RegExp _digitRegex = RegExp(r'[0-9]+');

  /// Apply the given phone mask to the input string.
  String apply(
    String inputString, {

    /// Optionally remove the country code from the input
    bool removeCountryCode = false,
  }) {
    /// If mask is empty, return input string
    if (mask.isEmpty) {
      return inputString;
    }

    var chars = inputString.replaceAll(RegExp(r'\D+'), '').split('');
    var result = <String>[];
    var index = 0;
    for (var i = 0; i < mask.length; i++) {
      if (index >= chars.length) {
        break;
      }
      var curChar = chars[index];
      if (mask[i] == '0') {
        /// If it's a digit in the mask, add the digit to the output
        if (_isDigit(curChar)) {
          result.add(curChar);
          index++;
        } else {
          break;
        }
      } else {
        /// Add the non-digit value from the mask to the output
        result.add(mask[i]);
      }
    }
    return result.join();
  }

  bool _isDigit(String character) {
    if (character.isEmpty || character.length > 1) {
      return false;
    }
    return _digitRegex.stringMatch(character) != null;
  }

  @override
  String toString() => '[PhoneMask mask: $mask]';
}
