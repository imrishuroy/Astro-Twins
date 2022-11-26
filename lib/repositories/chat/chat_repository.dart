import '/models/chat_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/models/failure.dart';
import '/config/paths.dart';
import '/repositories/chat/base_chat_repo.dart';

class ChatRepository extends BaseChatRepository {
  final FirebaseFirestore _firestore;

  ChatRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> addChat({
    required String? currentUserId,
    required String? otherUserId,
    required ChatMessage chat,
  }) async {
    try {
      if (currentUserId == null || otherUserId == null) {
        return;
      }

      String groupChatId;

      if (currentUserId.hashCode <= otherUserId.hashCode) {
        groupChatId = '$currentUserId-$otherUserId';
      } else {
        groupChatId = '$otherUserId-$currentUserId';
      }

      await _firestore
          .collection(Paths.chats)
          .doc(groupChatId)
          .collection(Paths.messages)
          .add(chat.toMap());

      // await _firestore
      //     .collection(Paths.chats)
      //     .doc(currentUserId)
      //     .collection(
      //         userType == UserType.user ? Paths.userChats : Paths.astroChats)
      //     .add(chat.toMap());

      // await _firestore
      //     .collection(Paths.chats)
      //     .doc(otherUserId)
      //     .collection(
      //         userType == UserType.user ? Paths.userChats : Paths.astroChats)
      //     .add(chat.toMap());
    } catch (error) {
      print('Error in adding chat ${error.toString()}');
    }
  }

  @override
  Stream<List<ChatMessage?>> streamChat({
    required String? currentUserId,
    required String? otherUserId,
  }) {
    try {
      if (currentUserId != null && otherUserId != null) {}
      String groupChatId;

      if (currentUserId.hashCode <= otherUserId.hashCode) {
        groupChatId = '$currentUserId-$otherUserId';
      } else {
        groupChatId = '$otherUserId-$currentUserId';
      }

      final chatSnaps = _firestore
          .collection(Paths.chats)
          .doc(groupChatId)
          .collection(Paths.messages)
          .orderBy('createdAt', descending: true)
          .snapshots();

      return chatSnaps.map((event) {
        return event.docs
            .map((doc) => ChatMessage.fromMap(doc.data()))
            .toList();
      });
    } catch (error) {
      print('Error in stream chat ${error.toString()}');
      throw const Failure(message: 'Error in gettings chats');
    }
  }
}
