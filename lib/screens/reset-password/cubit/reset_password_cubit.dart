import 'package:astro_twins/blocs/auth/auth_bloc.dart';
import 'package:astro_twins/models/failure.dart';
import 'package:astro_twins/repositories/auth/auth_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final AuthRepository _authRepository;
  final AuthBloc _authBloc;
  ResetPasswordCubit({
    required AuthBloc authBloc,
    required AuthRepository authRepository,
  })  : _authBloc = authBloc,
        _authRepository = authRepository,
        super(ResetPasswordState.initial());

  void load() {
    emit(state.copyWith(email: _authBloc.state.user?.email));
  }

  void emailChanged(String email) {
    emit(state.copyWith(email: email, status: ResetPasswordStatus.initial));
  }

  void resetPassword() async {
    try {
      emit(state.copyWith(status: ResetPasswordStatus.loading));
      await _authRepository.resetPassword(state.email);
      emit(state.copyWith(status: ResetPasswordStatus.succuss));
    } on Failure catch (failure) {
      emit(state.copyWith(failure: failure, status: ResetPasswordStatus.error));
    }
  }
}
