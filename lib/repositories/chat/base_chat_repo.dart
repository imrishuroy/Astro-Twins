import '/models/chat_message.dart';

abstract class BaseChatRepository {
  Future<void> addChat({
    required String? currentUserId,
    required String? otherUserId,
    required ChatMessage chat,
  });

  Stream<List<ChatMessage?>> streamChat({
    required String? currentUserId,
    required String? otherUserId,
  });
}
