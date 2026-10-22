import 'package:flutter_test/flutter_test.dart';
import 'package:loyalty_app/core/utils/validators/phone_validator.dart';

void main() {
  test('normalizes UAE mobile numbers as typed', () {
    expect(PhoneValidator.normalize('050 000 9991'), '+971500009991');
    expect(PhoneValidator.normalize('50 000 9991'), '+971500009991');
    expect(PhoneValidator.normalize('+971 50 000 9991'), '+971500009991');
  });

  test('accepts mobiles and rejects landlines or short numbers', () {
    expect(PhoneValidator.isValid('0500009991'), isTrue);
    expect(PhoneValidator.isValid('041234567'), isFalse);
    expect(PhoneValidator.isValid('05000'), isFalse);
  });
}
