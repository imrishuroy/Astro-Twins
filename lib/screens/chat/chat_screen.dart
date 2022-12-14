import 'package:astro_twins/screens/call/agora_voice_call.dart';
import 'package:astro_twins/widgets/ask_to_action.dart';
import 'package:astro_twins/widgets/show_snakbar.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:uuid/uuid.dart';

import '/blocs/auth/auth_bloc.dart';
import '/models/app_user.dart';
import '/repositories/chat/chat_repository.dart';
import '/screens/chat/cubit/chat_cubit.dart';
import '/screens/chat/media_preview.dart';
import '/screens/chat/widgets/choose_media_icon.dart';
import '/screens/dashboard/widgets/twin_details.dart';
import '/widgets/display_image.dart';
import '/widgets/loading_indicator.dart';
import 'widgets/display_chat.dart';

class ChatScreenArgs {
  final AppUser? otherUser;

  ChatScreenArgs({
    required this.otherUser,
  });
}

class ChatScreen extends StatefulWidget {
  final AppUser? otherUser;

  static const String routeName = '/chats';
  const ChatScreen({
    Key? key,
    required this.otherUser,
  }) : super(key: key);

  static Route route({required ChatScreenArgs args}) {
    return MaterialPageRoute(
      builder: (_) => BlocProvider<ChatCubit>(
        create: (context) => ChatCubit(
          chatRepository: context.read<ChatRepository>(),
          authBloc: context.read<AuthBloc>(),
          otherUserID: args.otherUser?.userId,
        ),
        child: ChatScreen(
          otherUser: args.otherUser,
        ),
      ),
    );
  }

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late ScrollController scrollController;

  void _submitForm(BuildContext context, bool isSubmitting) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate() && !isSubmitting) {
      final chatCubit = context.read<ChatCubit>();
      print('Chat message -- ${_chatTextController.text}');
      if (chatCubit.state.message.isNotEmpty) {
        chatCubit.sendChat();
      }
      _chatTextController.clear();
      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  void _makePhoneCall() async {
    if (widget.otherUser?.mobileNumber != null &&
        widget.otherUser!.mobileNumber!.isNotEmpty) {
      final result = await AskToAction.deleteAction(
          context: context,
          title: 'Call',
          content: 'Do you want to call ${widget.otherUser?.name} ?');
      if (result) {
        if (widget.otherUser?.mobileNumber != null) {
          await FlutterPhoneDirectCaller.callNumber(
              widget.otherUser!.mobileNumber!);

          // if (await canLaunchUrl(url)) {
          //   launchUrl(url);
          // }
        }
      }
    } else {
      ShowSnackBar.showSnackBar(context, title: 'Mobile number not available');
    }
  }

  final _chatTextController = TextEditingController();

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  void chooseMediaModel(BuildContext context) async {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext _) {
        return Container(
          height: 200,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(height: 20.0),
                const Text(
                  'Choose Media Type',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.0,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 40.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ChooseMediaIcon(
                      onTap: () {
                        Navigator.of(context).pop();
                        context.read<ChatCubit>().pickImage(context);
                      },
                      label: 'Image',
                      icon: Icons.image,
                    ),
                    ChooseMediaIcon(
                      onTap: () {
                        Navigator.of(context).pop();
                        context.read<ChatCubit>().pickVideo();
                      },
                      label: 'Video',
                      icon: Icons.video_file,
                    )
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> sendNotificationToOtherUser(
      {required String channelName}) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('sendCallNotification');

      final resp = await callable.call(<String, dynamic>{
        'receiverId': widget.otherUser?.userId,
        'callerName': widget.otherUser?.name,
        'callerPhoto': widget.otherUser?.profileImg,
        'sessionId': const Uuid().v4(),
        'channelName': channelName,
      });
      print('result: ${resp.data}');
    } catch (error) {
      print('Error in sending notification: $error');
    }
  }

  final channelName = const Uuid().v4();

  @override
  Widget build(BuildContext context) {
    // final _canvas = MediaQuery.of(context).size;
    final authBloc = context.read<AuthBloc>();
    final chatCubit = context.read<ChatCubit>();
    return Container(
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
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: BlocConsumer<ChatCubit, ChatState>(
              listener: (context, state) async {
                print('State of chat scren ${state.status}');
                if (state.pickedFile != null &&
                    state.status == ChatStatus.filePicked) {
                  final result = await Navigator.of(context).pushNamed(
                    MediaPreview.routeName,
                    arguments: MediaPreviewArgs(
                      mediaFile: state.pickedFile!,
                      mediaType: state.mediaType,
                      otherUserId: widget.otherUser?.userId,
                    ),
                  );

                  if (result == true) {
                    chatCubit.sendChat();
                    scrollController.animateTo(0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut);
                  }
                }
                print('Picked File -- ${state.pickedFile}');
              },
              builder: (context, state) {
                if (state.status == ChatStatus.loading) {
                  return const LoadingIndicator();
                }
                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 10.0),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                          //SizedBox(width: _canvas.width * 0.24),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pushNamed(
                              TwinsDetailsScreen.routeName,
                              arguments: TwinsDetailsArgs(
                                twin: widget.otherUser,
                              ),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 20.0,
                                  child: ClipOval(
                                    child: DisplayImage(
                                      height: 38.0,
                                      width: 38.0,
                                      imageUrl: widget.otherUser?.profileImg,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                Text(
                                  widget.otherUser?.name ?? '',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            // onPressed: () async => _makePhoneCall(),
                            onPressed: () async {
                              await sendNotificationToOtherUser(
                                  channelName: channelName);

                              // ignore: use_build_context_synchronously
                              Navigator.of(context).pushNamed(
                                AgoraVoiceCall.routeName,
                                arguments: AgoraVoiceCallArgs(
                                  otherUser: widget.otherUser,
                                  channelName: channelName,
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.call,
                              size: 22.0,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                        ],
                      ),
                      const Divider(),
                      // const SizedBox(height: 15.0),
                      Expanded(
                        flex: 2,
                        child: ListView.builder(
                          controller: scrollController,
                          reverse: true,
                          itemCount: state.chats.length,
                          // shrinkWrap: true,
                          padding: const EdgeInsets.only(top: 10, bottom: 10),

                          /// physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final chat = state.chats[index];

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: DisplayChat(
                                chatMessage: chat,
                                isCurrentUser: chat?.authorId ==
                                    authBloc.state.user?.userId,
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        flex: 0,
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 10, bottom: 10, top: 10),
                          height: 60,
                          width: double.infinity,
                          color: Colors.white,
                          child: Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () => chooseMediaModel(
                                    context), //context.read<ChatCubit>().pickVideo(),
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: TextFormField(
                                  controller: _chatTextController,
                                  onChanged: (value) => context
                                      .read<ChatCubit>()
                                      .messageChanged(value),
                                  // controller: _chatTextController,
                                  decoration: const InputDecoration(
                                      hintText: 'Write your message...',
                                      hintStyle:
                                          TextStyle(color: Colors.black54),
                                      border: InputBorder.none),
                                ),
                              ),
                              const SizedBox(width: 15.0),
                              FloatingActionButton(
                                onPressed: () => _submitForm(context,
                                    state.status == ChatStatus.loading),
                                backgroundColor: state.isFormValid
                                    // ? primaryColor
                                    ? Colors.green
                                    : Colors.grey,
                                elevation: 0,
                                child: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
