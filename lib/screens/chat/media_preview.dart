import 'dart:io';

import 'package:astro_twins/widgets/custom_video_player.dart';

import '/enums/enums.dart';

import '/blocs/auth/auth_bloc.dart';
import '/repositories/chat/chat_repository.dart';
import '/screens/chat/cubit/chat_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MediaPreviewArgs {
  final File mediaFile;
  final MediaType mediaType;
  final String? otherUserId;

  MediaPreviewArgs({
    required this.mediaFile,
    required this.mediaType,
    required this.otherUserId,
  });
}

class MediaPreview extends StatelessWidget {
  static const String routeName = '/mediaPreview';

  final File mediaFile;
  final MediaType mediaType;

  const MediaPreview(
      {Key? key, required this.mediaFile, required this.mediaType})
      : super(key: key);

  static Route route({required MediaPreviewArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider(
        create: (context) => ChatCubit(
          chatRepository: context.read<ChatRepository>(),
          authBloc: context.read<AuthBloc>(),
          otherUserID: args.otherUserId,
        ),
        child: MediaPreview(
          mediaFile: args.mediaFile,
          mediaType: args.mediaType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<ChatCubit>().deleteMedia();
        Navigator.of(context).pop();
        return true;
      },
      child: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            // stops: [0.1, 0.5, 0.7, 0.9],
            stops: [0.08, 0.2],
            colors: [
              Color(0xffF28931),
              Color(0xffED462F),
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            context.read<ChatCubit>().deleteMedia();
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'Preview',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.9,
                          ),
                        ),
                        const IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.clear,
                            color: Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Expanded(
                    child: mediaType == MediaType.video
                        ? CustomVideoPlayer(videoFile: mediaFile, isFile: true)
                        : Image.file(mediaFile),
                  ),
                  const SizedBox(height: 20.0),
                  SizedBox(
                    width: 120.0,
                    height: 40.0,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text(
                        'Send',
                        style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
