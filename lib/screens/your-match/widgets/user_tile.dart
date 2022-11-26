import 'dart:ui';
import '/screens/login/login_screen.dart';
import '/blocs/auth/auth_bloc.dart';
import '/constants/constants.dart';
import '/cubits/connect/connect_cubit.dart';
import '/enums/connect_status.dart';

import '/models/app_user.dart';
import '/models/connect.dart';
import '/screens/chat/chat_screen.dart';
import '/widgets/display_image.dart';
import '/widgets/request_sent_dialog.dart';
import '/widgets/show_snakbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserTile extends StatelessWidget {
  const UserTile({Key? key, required this.user, required this.connectStatus})
      : super(key: key);

  final AppUser? user;
  final ConnectStatus? connectStatus;

  String _connectionStatus(ConnectStatus? status) {
    switch (status) {
      case ConnectStatus.connected:
        return 'Connected';

      case ConnectStatus.pending:
        return 'Pending';

      case ConnectStatus.sent:
        return 'Sent';

      // case ConnectStatus.unknown:
      //   return 'Unknown';
      default:
        return 'Connect';
    }
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        if (authBloc.state.user == null) {
          ShowSnackBar.showSnackBar(
            context,
            title: 'Please login to see details',
            backgroundColor: Colors.deepOrangeAccent,
            onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
              LoginScreen.routeName,
              (route) => false,
            ),
          );
        } else if (connectStatus == ConnectStatus.connected) {
          Navigator.of(context).pushNamed(
            ChatScreen.routeName,
            arguments: ChatScreenArgs(
              otherUser: user,
            ),
          );
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 6.0,
            vertical: 10.0,
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 22.0,
                child: ClipOval(
                  child: Stack(
                    children: [
                      DisplayImage(
                        imageUrl: user?.profileImg,
                        height: 50.0,
                        width: 50.0,
                      ),
                      if (authBloc.state.user == null)
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: CircleAvatar(
                            radius: 22.0,
                            backgroundColor: Colors.white.withOpacity(0.0),
                          ),
                        )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: size.width * 0.4,
                    child: Text(
                      user?.name ?? '',
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      //SizedBox(width: 0.6),
                      const Icon(
                        Icons.calendar_month,
                        size: 13.0,
                        color: Contants.primaryColor,
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        user?.birthDate ?? 'N/A',
                        // '01/11/2000',
                        style: const TextStyle(
                          fontSize: 11.0,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    children: [
                      const Icon(
                        Icons.mail,
                        color: Contants.primaryColor,
                        size: 13.0,
                      ),
                      const SizedBox(width: 8.0),
                      SizedBox(
                        width: size.width * 0.4,
                        child: Text(
                          user?.email ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 10.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  )
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  if (authBloc.state.user != null &&
                      connectStatus != ConnectStatus.connected) {
                    print('lnalannal');
                    context.read<ConnectCubit>().connectUser(
                        userConnect: Connect(
                            status: ConnectStatus.pending,
                            userId: user?.userId));

                    showDialog(
                      context: context,
                      builder: (_) => RequestSentDialog(
                        name: user?.name,
                      ),
                    );
                  }
                },
                child: Container(
                  height: 30.0,
                  // width: 65.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: const Color(0xffDC402B),
                      width: 1.2,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Center(
                      child: Text(
                        _connectionStatus(connectStatus),
                        style: const TextStyle(
                          fontSize: 10.0,
                          color: Color(0xffDC402B),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
