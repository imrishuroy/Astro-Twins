import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/blocs/auth/auth_bloc.dart';
import '/models/app_user.dart';
import '/models/failure.dart';
import '/repositories/twins/twins_repository.dart';

part 'your_match_state.dart';

class YourMatchCubit extends Cubit<YourMatchState> {
  final AuthBloc _authBloc;
  final TwinsRepository _twinsRepository;
  YourMatchCubit({
    required AuthBloc authBloc,
    required TwinsRepository twinsRepository,
  })  : _authBloc = authBloc,
        _twinsRepository = twinsRepository,
        super(YourMatchState.initial());

  void loadMatchingUsers() async {
    try {
      emit(state.copyWith(status: YourMatchStatus.loading));
      final users =
          await _twinsRepository.searchTwins(user: _authBloc.state.user);
      emit(state.copyWith(users: users, status: YourMatchStatus.succuss));
    } on Failure catch (failure) {
      emit(state.copyWith(failure: failure, status: YourMatchStatus.error));
    }
  }
}
