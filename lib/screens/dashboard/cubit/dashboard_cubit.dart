import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/blocs/auth/auth_bloc.dart';
import '/cubits/connect/connect_cubit.dart';
import '/models/app_user.dart';
import '/models/connect.dart';
import '/models/failure.dart';
import '/repositories/twins/twins_repository.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final TwinsRepository _twinsRepository;
  final AuthBloc _authBloc;
  final ConnectCubit _connectCubit;
  DashboardCubit({
    required TwinsRepository twinsRepository,
    required AuthBloc authBloc,
    required ConnectCubit connectCubit,
  })  : _twinsRepository = twinsRepository,
        _connectCubit = connectCubit,
        _authBloc = authBloc,
        super(DashboardState.initial());

  void loadTwins() async {
    try {
      emit(state.copyWith(status: DashBoardStatus.loading));

      _connectCubit.clearAllConnections();

      final twins =
          await _twinsRepository.searchTwins(user: _authBloc.state.user);

      final connectUsersId = await _twinsRepository.getConnectedUsers(
          userId: _authBloc.state.user?.userId);

      print('connectedUsrIds --- $connectUsersId');

      _connectCubit.updatedConnectedUsers(userIds: connectUsersId);

      emit(state.copyWith(status: DashBoardStatus.succuss, twins: twins));
    } on Failure catch (failure) {
      emit(state.copyWith(failure: failure, status: DashBoardStatus.error));
    }
  }

  void connectUser({required Connect? otherUserId}) async {
    try {
      emit(state.copyWith(status: DashBoardStatus.loading));
      await _twinsRepository.connectUser(
          userId: _authBloc.state.user?.userId, userConnect: otherUserId);
    } on Failure catch (failure) {
      emit(state.copyWith(failure: failure, status: DashBoardStatus.error));
    }
  }
}
