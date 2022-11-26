import 'dart:ui';
import '/blocs/auth/auth_bloc.dart';
import '/widgets/show_snakbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/enums/connect_status.dart';
import '/screens/astrologers/astrologer_details.dart';

import '/widgets/display_image.dart';
import '/models/astrologer.dart';
import 'package:flutter/material.dart';

class AstrologerTile extends StatelessWidget {
  final Astrologer? astrologer;
  final ConnectStatus? connectStatus;
  final VoidCallback onTap;

  const AstrologerTile({
    Key? key,
    required this.astrologer,
    required this.connectStatus,
    required this.onTap,
  }) : super(key: key);

  String connectionStatus(ConnectStatus? status) {
    switch (status) {
      case ConnectStatus.connected:
        return 'Connected';

      case ConnectStatus.pending:
        return 'Request Pending';

      case ConnectStatus.sent:
        return 'Sent';

      // case ConnectStatus.unknown:
      //   return 'Connect';
      default:
        return 'Connect';
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authBloc = context.read<AuthBloc>();

    return GestureDetector(
      onTap: () {
        if (authBloc.state.user != null) {
          Navigator.of(context).pushNamed(
            AstrologerDetails.routeName,
            arguments: AstrologerArgs(
              astrologer: astrologer,
            ),
          );
        } else {
          ShowSnackBar.showSnackBar(context,
              title: 'Please login to see details',
              backgroundColor: Colors.deepOrangeAccent);
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 10.0,
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                //  backgroundColor: Contants.primaryColor,
                radius: 22.0,
                child: ClipOval(
                  child: Stack(
                    children: [
                      DisplayImage(
                        imageUrl: astrologer?.profileImg,
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
              SizedBox(
                width: size.width * 0.45,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      astrologer?.name ?? '',
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 7.0),
                    Text(
                      astrologer?.email ?? '',
                      style: const TextStyle(
                        fontSize: 11.0,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  // height: 30.0,
                  // width: 100.0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 8.0,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: const Color(0xffDC402B),
                      width: 1.2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      connectionStatus(connectStatus),
                      style: const TextStyle(
                        fontSize: 11.0,
                        color: Color(0xffDC402B),
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
