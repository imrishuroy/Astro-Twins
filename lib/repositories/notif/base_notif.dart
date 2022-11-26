import '/models/notif.dart';

abstract class BaseNotifRepo {
  Future<List<Future<Notif?>>> getUserNotifications({required String? userId});
  // Stream<List<Future<Notif?>>> getUserNotifications({required String? userId});
}
