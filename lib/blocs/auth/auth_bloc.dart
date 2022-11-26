import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/models/app_user.dart';
import '/repositories/auth/auth_repo.dart';
import '/repositories/profile/profile_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  late StreamSubscription<AppUser?> _userSubscription;

  AuthBloc({
    required AuthRepository authRepository,
    required ProfileRepository profileRepository,
  })  : _authRepository = authRepository,
        super(AuthState.unknown()) {
    _userSubscription = _authRepository.onAuthChanges.listen(
      (user) async {
        add(
          AuthUserChanged(user: user

              // user: user?.copyWith(
              // name: currentUser?.name,
              // profileImg: currentUser?.profileImg,
              // birthDate: currentUser?.birthDate,
              // birthPlace: currentUser?.birthPlace,
              // birthTime: currentUser?.birthTime,
              // // birthDetails: currentUser?.birthDetails,
              // sex: currentUser?.sex,
              // about: currentUser?.about,
              // mobileNumber: currentUser?.mobileNumber,
              //),
              ),
        );

        // print('User --- $user');
        // final currentUser = await _profileRepository
        //     .getUserProfile(userId: user?.userId)
        //     .then((value) => null);
        // print('Current user -- $currentUser');

        // //  check over that

        // add(
        //   AuthUserChanged(
        //     user: user?.copyWith(
        //       name: currentUser?.name,
        //       profileImg: currentUser?.profileImg,
        //       birthDate: currentUser?.birthDate,
        //       birthPlace: currentUser?.birthPlace,
        //       birthTime: currentUser?.birthTime,
        //       // birthDetails: currentUser?.birthDetails,
        //       sex: currentUser?.sex,
        //       about: currentUser?.about,
        //       mobileNumber: currentUser?.mobileNumber,
        //     ),
        //   ),
        // );
      },
    );
    on<AuthEvent>((event, emit) async {
      if (event is AuthUserChanged) {
        emit(
          event.user != null
              ? AuthState.authenticated(promoter: event.user)
              : AuthState.unAuthenticated(),
        );
      } else if (event is AuthLogoutRequested) {
        await _authRepository.signOut();
      } else if (event is UserProfileImageChanged) {
        emit(state.copyWith(
            user: state.user?.copyWith(profileImg: event.imgUrl)));
      }
    });
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
