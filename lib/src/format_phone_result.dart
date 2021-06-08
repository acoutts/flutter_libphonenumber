class FormatPhoneResult {
  FormatPhoneResult({
    required this.e164,
    required this.formattedNumber,
  });
  String formattedNumber;
  String e164;

  @override
  String toString() {
    return 'FormatPhoneResult[formattedNumber: $formattedNumber, e164: $e164]';
  }
}
