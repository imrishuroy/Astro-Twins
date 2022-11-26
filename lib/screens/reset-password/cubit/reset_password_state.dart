part of 'reset_password_cubit.dart';

enum ResetPasswordStatus {
  initial,
  loading,
  succuss,
  error,
}

class ResetPasswordState extends Equatable {
  final String email;
  final ResetPasswordStatus status;
  final Failure failure;

  const ResetPasswordState({
    required this.email,
    required this.status,
    required this.failure,
  });

  factory ResetPasswordState.initial() => const ResetPasswordState(
        email: '',
        status: ResetPasswordStatus.initial,
        failure: Failure(),
      );

  @override
  List<Object> get props => [email, status, failure];

  ResetPasswordState copyWith({
    String? email,
    ResetPasswordStatus? status,
    Failure? failure,
  }) {
    return ResetPasswordState(
      email: email ?? this.email,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  bool get isFormValid => email.isNotEmpty;

  @override
  String toString() =>
      'ResetPasswordState(email: $email, status: $status, failure: $failure)';
}
