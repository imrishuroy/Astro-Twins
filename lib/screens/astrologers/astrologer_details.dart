import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '/constants/constants.dart';
import '/cubits/connect/connect_cubit.dart';
import '/enums/connect_status.dart';
import '/models/astrologer.dart';
import '/models/connect.dart';
import '/screens/chat/astro_chat_screen.dart';
import '/widgets/display_image.dart';

class AstrologerArgs {
  final Astrologer? astrologer;

  AstrologerArgs({
    required this.astrologer,
  });
}

class AstrologerDetails extends StatelessWidget {
  static const String routeName = '/astrologerDetails';

  final Astrologer? astrologer;

  const AstrologerDetails({
    Key? key,
    required this.astrologer,
  }) : super(key: key);

  static Route route({required AstrologerArgs? args}) {
    return MaterialPageRoute(
      builder: (_) => AstrologerDetails(
        astrologer: args?.astrologer,
      ),
    );
  }

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

    final connectedState = context.watch<ConnectCubit>().state;

    final Connect connect = connectedState.connectedAstroIds.firstWhere(
      (element) => element.userId == astrologer?.astroId,
      orElse: () {
        return const Connect(
          status: ConnectStatus.unknown,
          userId: null,
        );
      },
    );
    print('COnnect ----- $connect');

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 250.0,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.circular(40.0),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomCenter,
                    stops: [0.1, 0.3],
                    colors: [
                      Color(0xffF28931),
                      Color(0xffED462F),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 30.0,
            left: 10.0,
            right: 10.0,
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_sharp,
                    color: Colors.white,
                  ),
                ),
                Text(
                  astrologer?.name ?? 'N/A',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 140.0,
            left: 10.0,
            right: 10.0,
            child: Card(
              child: Container(
                decoration: BoxDecoration(
                  // color: Colors.amber,
                  borderRadius: BorderRadius.circular(14.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    height: size.height * 0.74,
                    child: ListView(
                      children: [
                        const SizedBox(height: 100.0),
                        Center(
                          child: Text(
                            astrologer?.name ?? '',
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Center(
                          child: Text(
                            astrologer?.email ?? '',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        Text(
                          'About',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Text(astrologer?.about ?? 'N/A'),
                        const SizedBox(height: 20.0),
                        Text(
                          'Address',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Text(astrologer?.address ?? 'N/A'),
                        const SizedBox(height: 70.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (astrologer?.mobileNumber != null) {
                                  launchUrlString(
                                      'tel://${astrologer?.mobileNumber}');
                                }
                              },
                              child: Container(
                                height: 42.0,
                                width: size.width * 0.4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32.0),
                                  border: Border.all(
                                    color: Contants.primaryColor,
                                    width: 1.5,
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Call',
                                    style: TextStyle(
                                      color: Contants.primaryColor,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 42.0,
                              width: size.width * 0.4,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Contants.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                                onPressed: () {
                                  if (connect.status !=
                                      ConnectStatus.connected) {
                                    print('this runs 11');
                                    print('Astro -- $astrologer');
                                    context.read<ConnectCubit>().connectAstro(
                                          astroConnect: Connect(
                                            status: ConnectStatus.connected,
                                            userId: astrologer?.astroId,
                                          ),
                                        );
                                  } else if (connect.status ==
                                      ConnectStatus.connected) {
                                    Navigator.of(context).pushNamed(
                                      AstoChatScreen.routeName,
                                      arguments: AstroChatScreenArgs(
                                        astrologer: astrologer,
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  connect.status == ConnectStatus.connected
                                      ? 'Chat'
                                      : connectionStatus(connect.status),
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        // if (connectStatus == ConnectStatus.connected)
                        //   SizedBox(
                        //     height: 42.0,
                        //     width: 200.0,
                        //     child: ElevatedButton(
                        //       style: ElevatedButton.styleFrom(
                        //         primary: Contants.primaryColor,
                        //         shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(30.0),
                        //         ),
                        //       ),
                        //       onPressed: () {},
                        //       child: const Text('Chat'),
                        //     ),
                        //   )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 90.0,
            left: 20.0,
            right: 20.0,
            child: CircleAvatar(
              radius: 74.5,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                backgroundColor: Contants.primaryColor,
                radius: 72.0,
                child: ClipOval(
                  child: DisplayImage(
                    imageUrl: astrologer?.profileImg,
                    width: 200.0,
                    height: 200.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
