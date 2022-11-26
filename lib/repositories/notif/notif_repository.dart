import '/enums/connect_status.dart';
import '/models/connect.dart';
import '/models/failure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/config/paths.dart';
import '/models/notif.dart';
import 'base_notif.dart';

class NotificationRepository extends BaseNotifRepo {
  final FirebaseFirestore _firestore;

  NotificationRepository({FirebaseFirestore? firebaseFirestore})
      : _firestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<List<Future<Notif?>>> getUserNotifications(
      {required String? userId}) async {
    print('notification user id -- $userId');
    final notifSnaps = await _firestore
        .collection(Paths.notifications)
        .doc(userId)
        .collection(Paths.userNotifications)
        .orderBy('date', descending: true)
        .get();

    return notifSnaps.docs.map((doc) => Notif.fromDocument(doc)).toList();
  }

  Future<void> acceptReq({
    required String? userId,
    required String? otherUserId,
    required String? notifId,
  }) async {
    try {
      if (userId == null || otherUserId == null || notifId == null) {
        return;
      }

      // updating other user about accepted status
      await _firestore
          .collection(Paths.connections)
          .doc(otherUserId)
          .collection(Paths.userConnections)
          .doc(userId)
          .update(
            Connect(status: ConnectStatus.connected, userId: userId).toMap(),
          );

      // add other user to own connection

      await _firestore
          .collection(Paths.connections)
          .doc(userId)
          .collection(Paths.userConnections)
          .doc(otherUserId)
          .set(Connect(
            status: ConnectStatus.connected,
            userId: otherUserId,
          ).toMap());

      await _firestore
          .collection(Paths.notifications)
          .doc(userId)
          .collection(Paths.userNotifications)
          .doc(notifId)
          .delete();
    } catch (error) {
      print('Error accepting req');
      throw const Failure(message: 'Error accepting connection request');
    }
  }

  Future<void> rejectReq({
    required String? userId,
    required String? otherUserId,
    required String? notifId,
  }) async {
    try {
      if (userId == null || otherUserId == null) {
        return;
      }
      await _firestore
          .collection(Paths.connections)
          .doc(otherUserId)
          .collection(Paths.userConnections)
          .doc(userId)
          .delete();

      await _firestore
          .collection(Paths.notifications)
          .doc(userId)
          .collection(Paths.userNotifications)
          .doc(notifId)
          .delete();
      //.update({'status': 'connected'});
    } catch (error) {
      print('Error accepting req');
      throw const Failure(message: 'Error rejecting connection request');
    }
  }

  //@override
  // Stream<List<Future<Notif?>>> getUserNotifications({required String? userId}) {
  //   print('notification user id -- $userId');
  //   return _firestore
  //       .collection(Paths.notifications)
  //       .doc(userId)
  //       .collection(Paths.userNotifications)
  //       .orderBy('date', descending: true)
  //       .snapshots()
  //       .map(
  //           (snap) => snap.docs.map((doc) => Notif.fromDocument(doc)).toList());
  // }
}
