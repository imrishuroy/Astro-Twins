import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/blocs/auth/auth_bloc.dart';
import '/cubits/connect/connect_cubit.dart';
import '/models/astrologer.dart';
import '/models/connect.dart';
import '/models/failure.dart';
import '/repositories/astro/astro_repository.dart';

part 'astrologers_state.dart';

class AstrologersCubit extends Cubit<AstrologersState> {
  final AstroRepository _astroRepository;
  final AuthBloc _authBloc;
  final ConnectCubit _connectCubit;

  AstrologersCubit({
    required AstroRepository astroRepository,
    required AuthBloc authBloc,
    required ConnectCubit connectCubit,
  })  : _astroRepository = astroRepository,
        _authBloc = authBloc,
        _connectCubit = connectCubit,
        super(AstrologersState.initial());

  void loadAstrolgers() async {
    try {
      emit(state.copyWith(status: AstrologersStatus.loading));

      _connectCubit.clearAllConnections();

      final astrologers = await _astroRepository.getAstrologers();

      final connectAstroIds = await _astroRepository.getConnectedAstros(
          userId: _authBloc.state.user?.userId);

      print('connectedUsrIds --- $connectAstroIds');

      _connectCubit.updatedConnectedAstros(astroIds: connectAstroIds);

      emit(state.copyWith(
          status: AstrologersStatus.succuss, astrologers: astrologers));
    } on Failure catch (failure) {
      emit(state.copyWith(failure: failure, status: AstrologersStatus.error));
    }
  }

  void connectAstro({required Connect? astroId}) async {
    try {
      emit(state.copyWith(status: AstrologersStatus.loading));
      await _astroRepository.connectAstro(
          userId: _authBloc.state.user?.userId, astroConnect: astroId);
    } on Failure catch (failure) {
      emit(state.copyWith(failure: failure, status: AstrologersStatus.error));
    }
  }
}
