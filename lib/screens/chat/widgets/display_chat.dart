import '/screens/chat/widgets/show_chat_image.dart';
import '/widgets/custom_video_player.dart';
import '/enums/media_type.dart';
import '/models/chat_message.dart';

import 'package:flutter/material.dart';

class DisplayChat extends StatelessWidget {
  const DisplayChat({
    Key? key,
    required this.chatMessage,
    required this.isCurrentUser,
  }) : super(key: key);
  final ChatMessage? chatMessage;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        isCurrentUser ? 64.0 : 16.0,
        4,
        isCurrentUser ? 16.0 : 64.0,
        4,
      ),
      child: Align(
          // align the child within the container
          alignment:
              isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
          child:
              // DecoratedBox(
              //   // chat bubble decoration
              //   decoration: BoxDecoration(
              //     color: isCurrentUser ? const Color(0xffF8EBFF) : Colors.grey[300],
              //     borderRadius: BorderRadius.circular(16),
              //   ),

              //child:

              ChatContent(
            chatMessage: chatMessage!,
            isCurrentUser: isCurrentUser,
          )

          //  ),

          ),
    );
  }
}

class ChatContent extends StatelessWidget {
  final ChatMessage chatMessage;
  final bool isCurrentUser;
  const ChatContent({
    Key? key,
    required this.chatMessage,
    this.isCurrentUser = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Chat messsgae -- ${chatMessage.message}');
    print('Chat messsgae Media Type -- ${chatMessage.mediaType}');
    switch (chatMessage.mediaType) {
      case MediaType.image:
        return chatMessage.message != null
            ? ShowChatImage(
                imageUrl: chatMessage.message!,
                isCurrentUser: isCurrentUser,
              )
            : const SizedBox.shrink();

      case MediaType.video:
        return DecoratedBox(
          decoration: BoxDecoration(
            color: isCurrentUser ? const Color(0xffF8EBFF) : Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(1.2),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: chatMessage.message != null
                  ? CustomVideoPlayer(
                      videoUrl: chatMessage.message!,
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        );

      default:
        return DecoratedBox(
          decoration: BoxDecoration(
            color: isCurrentUser ? const Color(0xffF8EBFF) : Colors.grey[300],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              chatMessage.message ?? '',
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: const Color(0xff7C7C7C),
                  ),
            ),
          ),
        );
    }
  }
}
