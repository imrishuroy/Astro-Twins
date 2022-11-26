part of 'chat_cubit.dart';

enum ChatStatus { initial, loading, succuss, error, filePicked }

class ChatState extends Equatable {
  final String message;
  final MediaType mediaType;
  final ChatStatus status;
  final List<ChatMessage?> chats;
  final Failure failure;
  final File? pickedFile;

  const ChatState({
    required this.message,
    required this.mediaType,
    required this.failure,
    required this.status,
    required this.chats,
    required this.pickedFile,
  });

  bool get isFormValid => message.isNotEmpty;
  // && password.isNotEmpty;

  factory ChatState.initial() => const ChatState(
        mediaType: MediaType.none,
        failure: Failure(),
        status: ChatStatus.initial,
        message: '',
        chats: [],
        pickedFile: null,
      );
  @override
  List<Object?> get props => [
        message,
        mediaType,
        failure,
        status,
        chats,
        pickedFile,
      ];

  ChatState copyWith({
    String? message,
    MediaType? mediaType,
    ChatStatus? status,
    List<ChatMessage?>? chats,
    File? pickedFile,
    Failure? failure,
  }) {
    return ChatState(
      message: message ?? this.message,
      mediaType: mediaType ?? this.mediaType,
      status: status ?? this.status,
      chats: chats ?? this.chats,
      pickedFile: pickedFile ?? this.pickedFile,
      failure: failure ?? this.failure,
    );
  }
}
