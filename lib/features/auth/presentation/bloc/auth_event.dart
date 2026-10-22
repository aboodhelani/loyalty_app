abstract class AuthEvent {
  const AuthEvent();
}

class AuthPhoneSubmitted extends AuthEvent {
  final String phone;
  const AuthPhoneSubmitted(this.phone);
}

class AuthCodeSubmitted extends AuthEvent {
  final String code;
  const AuthCodeSubmitted(this.code);
}

class AuthResendRequested extends AuthEvent {
  const AuthResendRequested();
}

class AuthChangeNumberRequested extends AuthEvent {
  const AuthChangeNumberRequested();
}

class AuthProfileSubmitted extends AuthEvent {
  final String name;
  final DateTime? birthday;
  const AuthProfileSubmitted(this.name, this.birthday);
}

class AuthResendTicked extends AuthEvent {
  const AuthResendTicked();
}
