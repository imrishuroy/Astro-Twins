import '/config/shared_prefs.dart';
import '/models/connect.dart';
import '/models/notif.dart';
import '/config/paths.dart';
import '/models/app_user.dart';

import '/models/failure.dart';
import '/repositories/twins/base_twins_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TwinsRepository extends BaseTwinsRepository {
  final FirebaseFirestore _firestore;

  TwinsRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> addUserBirthDetails({required AppUser? user}) async {
    try {
      if (user == null || user.birthDate == null) {
        return;
      }
      await _firestore.collection(Paths.users).doc(user.userId).update(
        {
          'birthDate': user.birthDate,
          // user.birthDate != null
          //     ? Timestamp.fromDate(user.birthDate!)
          //     : null,
          'birthPlace': user.birthPlace,
          'birthTime': user.birthTime != null
              ? '${user.birthTime?.hour}:${user.birthTime?.minute}'
              : null,
          //  'birthDetails': user.birthDetails!.toMap(),
        },
      );
    } catch (error) {
      print('Error in adding birth details ${error.toString()}');
      throw const Failure(message: 'Error in adding birth details');
    }
  }

  Future<List<AppUser?>> searchTwins({required AppUser? user}) async {
    try {
      if (user == null) {
        //return [];

        final sharedPrefs = SharedPrefs();
        if (sharedPrefs.birthDetails?.birthDate == null) {
          return [];
        }

        final twinsSnaps = await _firestore
            .collection(Paths.users)
            .where('birthDate', isEqualTo: sharedPrefs.birthDetails?.birthDate)
            .get();

        return twinsSnaps.docs.map((doc) => AppUser.fromDocument(doc)).toList();
      }

      //print('user ')

      //  print('Birht details map ${user.birthDetails!.toMap()}');
      //  final dateFormat = DateFormat('dd MMMM yyyy');

      final twinsSnaps = await _firestore
          .collection(Paths.users)
          // .where('birthDetails', isEqualTo: user.birthDetails?.toMap())
          .where('birthDate', isEqualTo: user.birthDate)

          // isEqualTo: user.birthDate != null
          //     ? dateFormat.format(user.birthDate!)
          //     : null)

          // Timestamp.fromDate(user.birthDate!)
          // : null)
          .get();

      if (user.birthDate == null) {
        return [];
      }
      //print('Search twins ${twinsSnaps.docs.length}');

      return twinsSnaps.docs.map((doc) => AppUser.fromDocument(doc)).toList()
        ..removeWhere((element) => element?.userId == user.userId);
    } catch (error) {
      print('Error getting twins ${error.toString()}');
      throw const Failure(message: 'Error getting twins');
    }
  }

  Future<Set<Connect>> getConnectedUsers({
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
          .collection(Paths.userConnections)
          .get();

      return userSnaps.docs.map((doc) => Connect.fromDocument(doc)).toSet();
      // return userSnaps.docs.map((doc) => doc.id).toSet();
    } catch (error) {
      print('Error getting connectedUsers ${error.toString()}');
      throw const Failure(message: 'Error getting connected users');
    }
  }

  Future<void> connectUser({
    required String? userId,
    required Connect? userConnect,
  }) async {
    try {
      if (userId == null || userConnect == null) {
        return;
      }
      print('user id ----- $userId ');
      print('Connect other ----- $userConnect');
      await _firestore
          .collection(Paths.connections)
          .doc(userId)
          .collection(Paths.userConnections)
          .doc(userConnect.userId)
          .set(userConnect.toMap());

      final notif = Notif(
        type: NotifType.connectReq,
        fromUser: AppUser(userId: userId),
        date: DateTime.now(),
      );
      _firestore
          .collection(Paths.notifications)
          .doc(userConnect.userId)
          .collection(Paths.userNotifications)
          // .doc(userId)
          .add(notif.toDocument());
    } catch (error) {
      print('Error adding connection ${error.toString()}');
      throw const Failure(message: 'Error adding connection');
    }
  }
}
