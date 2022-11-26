import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/blocs/auth/auth_bloc.dart';
import '/models/failure.dart';
import '/repositories/auth/auth_repo.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;
  final AuthBloc _authBloc;
  LoginCubit({
    required AuthRepository authRepository,
    required AuthBloc authBloc,
  })  : _authRepository = authRepository,
        _authBloc = authBloc,
        super(LoginState.initial());

  void emailChanged(String email) {
    emit(state.copyWith(email: email, status: LoginStatus.initial));
  }

  void passwordChanged(String password) {
    emit(state.copyWith(password: password, status: LoginStatus.initial));
  }

  void showPassword(bool showPassword) {
    emit(state.copyWith(
        showPassword: !showPassword, status: LoginStatus.initial));
  }

  void loginEmail() async {
    try {
      emit(state.copyWith(status: LoginStatus.submitting));

      final user = await _authRepository.loginInWithEmailAndPassword(
          email: state.email, password: state.password);

      _authBloc.add(AuthUserChanged(user: user));

      emit(state.copyWith(status: LoginStatus.succuss));
    } on Failure catch (failure) {
      emit(state.copyWith(failure: failure, status: LoginStatus.error));
    }
  }
}
