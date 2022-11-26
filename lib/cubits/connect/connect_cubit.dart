import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/blocs/auth/auth_bloc.dart';
import '/models/connect.dart';
import '/repositories/astro/astro_repository.dart';
import '/repositories/twins/twins_repository.dart';

part 'connect_state.dart';

class ConnectCubit extends Cubit<ConnectState> {
  final AuthBloc _authBloc;
  final TwinsRepository _twinsRepository;
  final AstroRepository _astroRepository;
  ConnectCubit({
    required AuthBloc authBloc,
    required TwinsRepository twinsRepository,
    required AstroRepository astroRepository,
  })  : _authBloc = authBloc,
        _twinsRepository = twinsRepository,
        _astroRepository = astroRepository,
        super(ConnectState.initial());

  void updatedConnectedUsers({required Set<Connect> userIds}) {
    emit(
      state.copyWith(
        connectedUserIds: Set<Connect>.from(state.connectedUserIds)
          ..addAll(userIds),
      ),
    );
  }

  void updatedConnectedAstros({required Set<Connect> astroIds}) {
    emit(
      state.copyWith(
        connectedAstroIds: Set<Connect>.from(state.connectedAstroIds)
          ..addAll(astroIds),
      ),
    );
  }

  void connectUser({required Connect? userConnect}) async {
    if (userConnect != null && userConnect.userId != null) {
      await _twinsRepository.connectUser(
          userId: _authBloc.state.user?.userId, userConnect: userConnect);

      emit(
        state.copyWith(
          connectedUserIds: Set<Connect>.from(state.connectedUserIds)
            ..add(userConnect),
        ),
      );
    }
  }

  void connectAstro({required Connect? astroConnect}) async {
    print('Astro connect -- $astroConnect');
    if (astroConnect != null && astroConnect.userId != null) {
      print('this rns 12');
      await _astroRepository.connectAstro(
          userId: _authBloc.state.user?.userId, astroConnect: astroConnect);

      emit(
        state.copyWith(
          connectedAstroIds: Set<Connect>.from(state.connectedAstroIds)
            ..add(astroConnect),
        ),
      );
    }
  }

  void disConnectUser({required String? otherUserId}) {
    // _postRepository.deleteLike(
    //   postId: post.id!,
    //   userId: _authBloc.state.user!.uid,
    // );

    // emit(
    //   state.copyWith(
    //     likedPostIds: Set<String>.from(state.likedPostIds)..remove(post.id),
    //     recentlyLikedPostIds: Set<String>.from(state.recentlyLikedPostIds)
    //       ..remove(post.id),
    //   ),
    // );
  }

  void clearAllConnections() {
    emit(ConnectState.initial());
  }
}
