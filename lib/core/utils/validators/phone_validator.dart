/// UAE mobile numbers, as typed: "050 123 4567", "50 123 4567", "+971501234567".
class PhoneValidator {
  const PhoneValidator._();

  /// E.164 form ("+971501234567") for the API.
  static String normalize(String phone) {
    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.startsWith('971')) return '+$digits';
    if (digits.startsWith('0')) return '+971${digits.substring(1)}';
    return '+971$digits';
  }

  static bool isValid(String phone) => RegExp(r'^\+9715\d{8}$').hasMatch(normalize(phone));
}
