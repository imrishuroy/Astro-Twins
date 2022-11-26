import 'package:astro_twins/blocs/auth/auth_bloc.dart';
import 'package:astro_twins/repositories/profile/profile_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '/enums/enums.dart';
part 'nav_event.dart';
part 'nav_state.dart';

// class NavBloc extends Bloc<NavEvent, NavItem> {
//   NavBloc() : super(NavItem.dashboard) {
//     on<NavEvent>((event, emit) {
//       if (event is UpdateNavItem) {
//         emit(event.item);
//       }
//     });
//   }
// }

class NavBloc extends Bloc<NavEvent, NavState> {
  final AuthBloc _authBloc;
  final ProfileRepository _profileRepository;

  NavBloc({
    required AuthBloc authBloc,
    required ProfileRepository profileRepository,
  })  : _authBloc = authBloc,
        _profileRepository = profileRepository,
        super(NavState.initial()) {
    on<NavEvent>((event, emit) {
      if (event is UpdateNavItem) {
        emit(state.copyWith(item: event.item));
      }
    });
    on<UpDateAuthUser>((event, emit) async {
      emit(state.copyWith(status: NavStatus.loading));
      final user = await _profileRepository.getUserProfile(
          userId: _authBloc.state.user?.userId);

      _authBloc.add(AuthUserChanged(user: user));
      //  _authBloc.add(UpdateAuthUser(user: user));
      emit(state.copyWith(status: NavStatus.succuss));
    });
  }
}
