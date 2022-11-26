import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import '/config/paths.dart';

import '/models/app_user.dart';

enum NotifType {
  // like,
  // comment,
  // follow,

  connectReq,

  /*
  following
  added to story
  viewed your image/profile
  tagged you
   */

}

class Notif extends Equatable {
  final String? id;
  final NotifType type;
  final AppUser? fromUser;
  final DateTime date;

  const Notif({
    this.id,
    required this.type,
    required this.fromUser,
    required this.date,
  });

  @override
  List<Object?> get props => [id, type, fromUser, date];

  Map<String, dynamic> toDocument() {
    final notifType = EnumToString.convertToString(type);
    return {
      'type': notifType,
      'fromUser': FirebaseFirestore.instance
          .collection(Paths.users)
          .doc(fromUser?.userId),
      'date': Timestamp.fromDate(date),
    };
  }

  static Future<Notif?> fromDocument(DocumentSnapshot? doc) async {
    print('Notification doc ---- $doc');
    if (doc == null) return null;

    final data = doc.data() as Map?;
    print('Notification data -- $data');
    final notifType = EnumToString.fromString(NotifType.values, data?['type']);

    // From User
    final fromUserRef = data?['fromUser'] as DocumentReference?;
    if (fromUserRef != null) {
      final fromUserDoc = await fromUserRef.get();
      print('User data --- ${fromUserDoc.data()}');

      // Post
      // final postRef = data?['story'] as DocumentReference?;
      // if (postRef != null) {
      //   final postDoc = await postRef.get();

      //   print('Story doc --- ${postDoc.data()}');

      return Notif(
        id: doc.id,
        type: notifType!,
        fromUser: AppUser.fromDocument(fromUserDoc),
        // story: await Story.fromDocument(postDoc),
        date: (data?['date'] as Timestamp).toDate(),
      );

      // if (postDoc.exists) {
      //   print('this exists-----');
      //   return Notif(
      //     id: doc.id,
      //     type: notifType!,
      //     fromUser: AppUser.fromDocument(fromUserDoc),
      //     story: await Story.fromDocument(postDoc),
      //     date: (data?['date'] as Timestamp).toDate(),
      //   );
    }
    return null;
    // } else {
    //   return Notif(
    //     id: doc.id,
    //     type: notifType!,
    //     fromUser: AppUser.fromDocument(fromUserDoc),
    //    // story: null,
    //     date: (data?['date'] as Timestamp).toDate(),
    //   );
    // }
  }
  //return null;
  //}

  Notif copyWith({
    String? id,
    NotifType? type,
    AppUser? fromUser,
    // Story? story,
    DateTime? date,
  }) {
    return Notif(
      id: id ?? this.id,
      type: type ?? this.type,
      fromUser: fromUser ?? this.fromUser,
      //story: story ?? this.story,
      date: date ?? this.date,
    );
  }
}
