import 'package:astro_twins/models/connect.dart';

import '/config/paths.dart';
import '/models/astrologer.dart';
import '/models/failure.dart';
import '/repositories/astro/base_astro_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AstroRepository extends BaseAstroRepository {
  final FirebaseFirestore _firestore;

  AstroRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<Astrologer?>> getAstrologers() async {
    try {
      final astroSnaps = await _firestore.collection(Paths.astrologers).get();
      return astroSnaps.docs
          .map((doc) => Astrologer.fromMap(doc.data()))
          .toList();
    } catch (error) {
      print('Error in getting astrologers ${error.toString()}');
      throw const Failure(message: 'Error in getting astrologers');
    }
  }

  Future<Set<Connect>> getConnectedAstros({
    // Future<Set<String>> getConnectedUsers({
    required String? userId,
  }) async {
    try {
      if (userId == null) {
        return {};
      }

      final userSnaps = await _firestore
          .collection(Paths.connections)
          .doc(userId)
          .collection(Paths.astroConnections)
          .get();

      return userSnaps.docs.map((doc) => Connect.fromDocument(doc)).toSet();
      // return userSnaps.docs.map((doc) => doc.id).toSet();
    } catch (error) {
      print('Error getting connectedUsers ${error.toString()}');
      throw const Failure(message: 'Error getting connected users');
    }
  }

  Future<void> connectAstro({
    required String? userId,
    required Connect? astroConnect,
  }) async {
    try {
      if (userId == null || astroConnect == null) {
        return;
      }
      print('user id ----- $userId ');
      print('Connect other ----- $astroConnect');
      await _firestore
          .collection(Paths.connections)
          .doc(userId)
          .collection(Paths.astroConnections)
          .doc(astroConnect.userId)
          .set(astroConnect.toMap());

      // final notif = Notif(
      //   type: NotifType.connectReq,
      //   fromUser: AppUser(userId: userId),
      //   date: DateTime.now(),
      // );
      // _firestore
      //     .collection(Paths.notifications)
      //     .doc(otherUserId.userId)
      //     .collection(Paths.userNotifications)
      //     // .doc(userId)
      //     .add(notif.toDocument());
    } catch (error) {
      print('Error adding connection ${error.toString()}');
      throw const Failure(message: 'Error adding connection');
    }
  }
}
