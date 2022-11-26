part of 'notifications_cubit.dart';

enum NotificationStatus { initial, loading, succuss, error }

class NotificationsState extends Equatable {
  final List<Notif?> notifications;
  final Failure failure;
  final NotificationStatus status;

  const NotificationsState({
    required this.notifications,
    required this.failure,
    required this.status,
  });

  factory NotificationsState.initial() => const NotificationsState(
        notifications: [],
        failure: Failure(),
        status: NotificationStatus.initial,
      );

  NotificationsState copyWith({
    List<Notif?>? notifications,
    Failure? failure,
    NotificationStatus? status,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      failure: failure ?? this.failure,
      status: status ?? this.status,
    );
  }

  @override
  String toString() =>
      'NotificationsState(notifications: $notifications, failure: $failure, status: $status)';

  @override
  List<Object> get props => [notifications, failure, status];
}
