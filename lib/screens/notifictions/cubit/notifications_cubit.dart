import '/blocs/auth/auth_bloc.dart';
import '/models/notif.dart';
import '/repositories/notif/notif_repository.dart';
import '/models/failure.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationRepository _notificationRepository;
  final AuthBloc _authBloc;
  NotificationsCubit({
    required NotificationRepository notificationRepository,
    required AuthBloc authBloc,
  })  : _notificationRepository = notificationRepository,
        _authBloc = authBloc,
        super(NotificationsState.initial());

  void loadUserNotifications() async {
    try {
      emit(state.copyWith(status: NotificationStatus.loading));
      final futureNotifs = await _notificationRepository.getUserNotifications(
          userId: _authBloc.state.user?.userId);
      final notifications = await Future.wait(futureNotifs);
      emit(
        state.copyWith(
          notifications: notifications,
          status: NotificationStatus.succuss,
        ),
      );
    } on Failure catch (failure) {
      emit(state.copyWith(failure: failure, status: NotificationStatus.error));
    }
  }

  void acceptReq({
    required String? otherUserId,
    required String? notifId,
  }) async {
    try {
      print('User id -- ${_authBloc.state.user?.userId}');
      print('Other user id -- $otherUserId');
      print('Notif id -- $notifId');
      await _notificationRepository.acceptReq(
        userId: _authBloc.state.user?.userId,
        otherUserId: otherUserId,
        notifId: notifId,
      );
      loadUserNotifications();
    } on Failure catch (failure) {
      emit(state.copyWith(failure: failure, status: NotificationStatus.error));
    }
  }

  void rejectReq({
    required String? otherUserId,
    required String? notifId,
  }) async {
    try {
      await _notificationRepository.acceptReq(
        userId: _authBloc.state.user?.userId,
        otherUserId: otherUserId,
        notifId: notifId,
      );
      loadUserNotifications();
    } on Failure catch (failure) {
      emit(state.copyWith(failure: failure, status: NotificationStatus.error));
    }
  }
}
