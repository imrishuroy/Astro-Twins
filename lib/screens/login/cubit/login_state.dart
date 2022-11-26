part of 'login_cubit.dart';

enum LoginStatus { initial, submitting, succuss, error }

class LoginState extends Equatable {
  final String email;
  final String password;
  final bool showPassword;
  final Failure failure;
  final LoginStatus status;

  const LoginState({
    required this.email,
    required this.password,
    required this.showPassword,
    required this.failure,
    required this.status,
  });

  bool get isFormValid => email.isNotEmpty && password.isNotEmpty;

  factory LoginState.initial() => const LoginState(
        email: '',
        password: '',
        showPassword: false,
        failure: Failure(),
        status: LoginStatus.initial,
      );

  @override
  List<Object> get props => [email, password, showPassword, failure, status];

  LoginState copyWith({
    String? email,
    String? password,
    bool? showPassword,
    LoginStatus? status,
    Failure? failure,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      showPassword: showPassword ?? this.showPassword,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  @override
  String toString() {
    return 'LoginState(email: $email, password: $password, showPassword: $showPassword, status: $status, failure: $failure)';
  }
}
