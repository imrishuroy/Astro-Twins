import 'dart:async';
import 'dart:io';

import '/utils/media_util.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import '/enums/enums.dart';
import '/blocs/auth/auth_bloc.dart';
import '/models/chat_message.dart';
import '/repositories/chat/chat_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '/models/failure.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _chatRepository;

  final String? _otherUserId;
  final AuthBloc _authBloc;

  late StreamSubscription<List<ChatMessage?>> _chatsSubscription;

  ChatCubit({
    required ChatRepository chatRepository,
    required String? otherUserID,
    required AuthBloc authBloc,
  })  : _otherUserId = otherUserID,
        _chatRepository = chatRepository,
        _authBloc = authBloc,
        super(ChatState.initial()) {
    streamChats();
  }

  void streamChats() {
    try {
      emit(state.copyWith(status: ChatStatus.loading));
      _chatsSubscription = _chatRepository
          .streamChat(
              currentUserId: _authBloc.state.user?.userId,
              otherUserId: _otherUserId)
          .listen((chats) {
        emit(state.copyWith(chats: chats));
      });

      emit(state.copyWith(status: ChatStatus.succuss));
    } on Failure catch (error) {
      print('Error in stream chats  ${error.message}');
      emit(state.copyWith(
          status: ChatStatus.error, failure: Failure(message: error.message)));
    }
  }

  @override
  Future<void> close() {
    _chatsSubscription.cancel();
    return super.close();
  }

  void messageChanged(String value) {
    emit(state.copyWith(message: value, status: ChatStatus.initial));
  }

  void sendChat() async {
    try {
      emit(state.copyWith(status: ChatStatus.initial));
      String message = '';

      if ((state.mediaType == MediaType.image ||
              state.mediaType == MediaType.video) &&
          state.pickedFile != null) {
        final mediaUrl = await MediaUtil.uploadAdMedia(
            childName: 'chatMedia', file: state.pickedFile!);

        message = mediaUrl;
      } else {
        message = state.message;
      }

      await _chatRepository.addChat(
        currentUserId: _authBloc.state.user?.userId,
        otherUserId: _otherUserId,
        chat: ChatMessage(
          message: message,
          authorId: _authBloc.state.user?.userId,
          receiverId: _otherUserId,
          createdAt: DateTime.now(),
          mediaType: state.mediaType,
        ),
      );
      deleteMedia();
    } on Failure catch (failure) {
      emit(state.copyWith(failure: failure, status: ChatStatus.error));
      print('Error in send chat cubit  ${failure.message}');
    }
  }

  void pickImage(BuildContext context) async {
    try {
      final pickedFile = await MediaUtil.pickImageFromGallery(
        cropStyle: CropStyle.rectangle,
        context: context,
        title: 'Select Image',
        imageQuality: 40,
      );
      if (pickedFile != null) {
        print('Picked image lenght -- ${await pickedFile.length()}');
        emit(
          state.copyWith(
            pickedFile: pickedFile,
            mediaType: MediaType.image,
            status: ChatStatus.filePicked,
          ),
        );
      }
    } on Failure catch (failure) {
      emit(state.copyWith(failure: failure, status: ChatStatus.error));
    }
  }

  void deleteMedia() {
    emit(state.copyWith(pickedFile: null, status: ChatStatus.initial));
  }

  void pickVideo() async {
    try {
      final pickedVideo = await MediaUtil.pickVideo(title: 'Select Video');
      if (pickedVideo != null) {
        print('Picked image lenght -- ${await pickedVideo.length()}');

        final compressedVideo = await MediaUtil.compressVideo(pickedVideo);

        emit(state.copyWith(
          pickedFile: compressedVideo,
          mediaType: MediaType.video,
          status: ChatStatus.filePicked,
        ));
      }
    } on Failure catch (failure) {
      emit(state.copyWith(failure: failure, status: ChatStatus.error));
    }
  }
}
