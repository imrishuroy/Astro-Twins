part of 'auth_bloc.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class AuthState extends Equatable {
  final AppUser? user;
  final AuthStatus status;

  const AuthState({
    this.user,
    this.status = AuthStatus.unknown,
  });

  factory AuthState.unknown() => const AuthState();

  factory AuthState.authenticated({required AppUser? promoter}) =>
      AuthState(user: promoter, status: AuthStatus.authenticated);

  factory AuthState.unAuthenticated() =>
      const AuthState(status: AuthStatus.unauthenticated);

  @override
  List<Object?> get props => [user, status];

  @override
  bool? get stringify => true;

  AuthState copyWith({
    AppUser? user,
    AuthStatus? status,
  }) {
    return AuthState(
      user: user ?? this.user,
      status: status ?? this.status,
    );
  }
}
