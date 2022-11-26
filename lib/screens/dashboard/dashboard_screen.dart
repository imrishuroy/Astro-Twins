import 'dart:convert';
import 'dart:ui';

import 'package:astro_twins/config/paths.dart';
import 'package:astro_twins/models/app_user.dart';
import 'package:astro_twins/screens/call/agora_voice_call.dart';
import 'package:astro_twins/services/local_notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:connectycube_flutter_call_kit/connectycube_flutter_call_kit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:timezone/data/latest.dart';
import 'package:uuid/uuid.dart';

import '/blocs/auth/auth_bloc.dart';
import '/config/shared_prefs.dart';
import '/cubits/connect/connect_cubit.dart';
import '/enums/connect_status.dart';
import '/models/connect.dart';
import '/screens/chat/chat_screen.dart';
import '/screens/dashboard/cubit/dashboard_cubit.dart';
import '/screens/login/login_screen.dart';
import '/screens/notifictions/cubit/notifications_cubit.dart';
import '/screens/notifictions/notifications_screen.dart';
import '/widgets/app_drawer.dart';
import '/widgets/display_image.dart';
import '/widgets/loading_indicator.dart';
import '/widgets/notification_icon.dart';
import '/widgets/request_sent_dialog.dart';
import '/widgets/show_snakbar.dart';

export 'package:timeago/timeago.dart';
export 'package:timezone/data/latest_all.dart';
export 'package:timezone/timezone.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  late PageController _pageController;
  //final bool _isLoading = false;
  final localNotifcationHelper = LocalNotificationService();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    ConnectycubeFlutterCallKit.instance.init(
      onCallAccepted: (event) async {
        final name = event.userInfo?['name'];
        final userId = event.userInfo?['userId'];
        final profilePic = event.userInfo?['profilePic'];
        final user = AppUser(
          name: name,
          userId: userId,
          profileImg: profilePic,
        );
        print('onCallAccepted');
        print('name onCallAccepted: $name');

        Navigator.of(context).pushNamed(AgoraVoiceCall.routeName,
            arguments: AgoraVoiceCallArgs(otherUser: user));
      },
      onCallRejected: (_) async {
        print('onCallRejected');
      },
    );

    // ConnectycubeFlutterCallKit.showCallNotification(
    //   const CallEvent(
    //     sessionId: 'sessionId22',
    //     callType: 1,
    //     callerId: 123,
    //     callerName: 'Rishu',
    //     opponentsIds: {123},
    //   ),
    // );
    _pageController = PageController();
    context.read<NotificationsCubit>().loadUserNotifications();
    initializeTimeZones();
    localNotifcationHelper.initialiseSettings(onClickNotification);
    _notificationSetup();

    super.initState();
  }

  Future<void> _notificationSetup() async {
    try {
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        String? token = await messaging.getToken();
        if (token != null) {
          saveTokenToDatabase(token);
        }

        FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
          final data = message.data;
          print('onMessage: $data');
          //final sessionId = data['sessionId'];
          final name = data['callerName'];
          //  final userId = data['callerId'];
          final profilePic = data['callerPhoto'];

          //  print('onMessage profilePic: $profilePic');

          ConnectycubeFlutterCallKit.showCallNotification(
            CallEvent(
              sessionId: const Uuid().v4(),
              callType: 1,
              callerId: 123,
              callerName: name,
              opponentsIds: const {123},
              userInfo: {
                'name': name,
                //'userId': userId,
                'profilePic': profilePic,
              },
            ),
          );

          // the call received somewhere

          print('Got a message whilst in the foreground!');
          print('Message data: ${message.data}');
          print('Message data: ${message.toString()}');

          // if (message.notification != null) {
          //   await localNotifcationHelper.showNotificationMediaStyle(
          //     message: message,
          //   );

          print(
              'Message also contained a notification: ${message.notification}');
          //}
        });

        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          print('A new onMessageOpenedApp event was published!');

          final data = message.data;
          print('onMessage: $data');
          //final sessionId = data['sessionId'];
          final name = data['callerName'];
          //  final userId = data['callerId'];
          final profilePic = data['callerPhoto'];

          //  print('onMessage profilePic: $profilePic');

          ConnectycubeFlutterCallKit.showCallNotification(
            CallEvent(
              sessionId: const Uuid().v4(),
              callType: 1,
              callerId: 123,
              callerName: name,
              opponentsIds: const {123},
              userInfo: {
                'name': name,
                //'userId': userId,
                'profilePic': profilePic,
              },
            ),
          );
          // Navigator.of(context).pushNamed(AppRouterPath.notificationsScreen);
          print(
              'Message also contained a notification: ${message.notification}');
        });
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        print('User granted provisional permission');
      } else {
        print('User declined or has not accepted permission');
      }
    } catch (error) {
      print('Error in notification setup ${error.toString()}');
    }
  }

  Future<void> saveTokenToDatabase(String token) async {
    try {
      // Assume user is logged in for this example
      print('server notification runs');

      final authBloc = context.read<AuthBloc>();

      await FirebaseFirestore.instance
          .collection(Paths.users)
          .doc(authBloc.state.user?.userId)
          .update({
        'tokens': FieldValue.arrayUnion([token]),
      });
    } catch (error) {
      print('Error adding token to the server ${error.toString()}');
    }
  }

  void onClickNotification(NotificationResponse response) {
    try {
      if (response.payload != null) {
        final payload = jsonDecode(response.payload!) as Map?;

        if (payload != null) {
          final postId = payload['data']['postId'] as String?;

          print('Post id $postId');
        }
      }
    } catch (error) {
      print('Error in open notifications ${error.toString()}');
    }
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

  void sendNotification() async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('sendCallNotification');

      final resp = await callable.call(<String, dynamic>{
        'receiverId': 'OuJjCR2CxHWg2sEsy8amjg6OXnZ2',
        'name': 'Rishu',
        'sessionId': const Uuid().v4(),
      });
      print('result: ${resp.data}');
    } catch (error) {
      print('Error in send notification ${error.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authBloc = context.read<AuthBloc>();
    final dashboardCubit = context.read<DashboardCubit>();
    // FirebaseAuth.instance.signOut();

    print('Birht Detils ${SharedPrefs().birthDetails}');
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
      child: Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     sendNotification();
        //   },
        // ),
        drawer: const AppDrawer(),
        backgroundColor: Colors.transparent,
        body: BlocConsumer<DashboardCubit, DashboardState>(
          listener: (context, state) {
            if (state.status == DashBoardStatus.error) {
              ShowSnackBar.showSnackBar(context,
                  title: state.failure.message, backgroundColor: Colors.red);
            }
          },
          builder: (context, state) {
            if (state.status == DashBoardStatus.loading) {
              return const LoadingIndicator(color: Colors.white);
            }
            return SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 12.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Scaffold.of(context).openDrawer(),
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/svgs/twins.svg',
                            height: 27.0,
                            width: 27.0,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 10.0),
                          const Text(
                            'AstroTwins',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      NotificationIcon(onTap: () async {
                        final result = await Navigator.of(context)
                            .pushNamed(NotificationsScreen.routeName);

                        if (result == true) {
                          dashboardCubit.loadTwins();
                        }
                      }),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  if (authBloc.state.user == null)
                    const Text(
                      'Connect with your AstroTwins',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                      ),
                    ),
                  Expanded(
                    child: state.twins.isEmpty
                        ? const Center(
                            child: Text(
                              'No Twins Found',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17.0,
                              ),
                            ),
                          )
                        : PageView.builder(
                            controller: _pageController,
                            itemCount: state.twins.length,
                            itemBuilder: (context, index) {
                              final twin = state.twins[index];

                              final connectedUsersState =
                                  context.watch<ConnectCubit>().state;

                              final Connect connect = connectedUsersState
                                  .connectedUserIds
                                  .firstWhere(
                                      (element) =>
                                          element.userId == twin?.userId,
                                      orElse: () {
                                return const Connect(
                                    status: ConnectStatus.unknown,
                                    userId: null);
                              });
                              print('COnnect ----- $connect');

                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (state.twins.length > 1) {
                                            _pageController.previousPage(
                                              duration:
                                                  const Duration(seconds: 1),
                                              curve: Curves.ease,
                                            );
                                          }
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: index == 0
                                              ? Colors.transparent
                                              : Colors.white,
                                          radius: 10.0,
                                          child: Icon(
                                            Icons.chevron_left,
                                            size: 18.0,
                                            color: index == 0
                                                ? Colors.transparent
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                      Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          side: const BorderSide(
                                            width: 2.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                        //  borderRadius: BorderRadius.circular(20.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          child: SizedBox(
                                            //width: 250.0,
                                            width: size.width * 0.65,
                                            //fit: BoxFit.cover,
                                            // height: 320.0,
                                            height: size.height * 0.42,
                                            child: Stack(
                                              fit: StackFit.expand,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    if (connect.status ==
                                                        ConnectStatus
                                                            .connected) {
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                        ChatScreen.routeName,
                                                        arguments:
                                                            ChatScreenArgs(
                                                          otherUser: twin,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child: DisplayImage(
                                                    imageUrl: twin?.profileImg,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                if (authBloc.state.user == null)
                                                  SizedBox(
                                                    width: size.width * 0.65,
                                                    //fit: BoxFit.cover,
                                                    // height: 320.0,
                                                    height: size.height * 0.42,
                                                    child: BackdropFilter(
                                                      filter: ImageFilter.blur(
                                                          sigmaX: 10.0,
                                                          sigmaY: 10.0),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white
                                                              .withOpacity(
                                                            0.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          if (state.twins.length - 1 != index) {
                                            _pageController.nextPage(
                                              duration:
                                                  const Duration(seconds: 1),
                                              curve: Curves.ease,
                                            );
                                          }
                                        },
                                        child: CircleAvatar(
                                          backgroundColor:
                                              state.twins.length - 1 == index
                                                  ? Colors.transparent
                                                  : Colors.white,
                                          radius: 10.0,
                                          child: Icon(
                                            Icons.chevron_right,
                                            size: 18.0,
                                            color:
                                                state.twins.length - 1 == index
                                                    ? Colors.transparent
                                                    : Colors.black,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 20.0),
                                  Text(
                                    twin?.name ?? '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.9,
                                    ),
                                  ),
                                  const SizedBox(height: 9.0),
                                  Text(
                                    twin?.birthPlace ?? '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  SizedBox(height: size.height * 0.03),
                                  GestureDetector(
                                    onTap: () {
                                      if (authBloc.state.user == null) {
                                        Navigator.of(context)
                                            .pushNamed(LoginScreen.routeName);
                                      } else if (connect.status !=
                                          ConnectStatus.connected) {
                                        context
                                            .read<ConnectCubit>()
                                            .connectUser(
                                              userConnect: Connect(
                                                status: ConnectStatus.pending,
                                                userId: twin?.userId,
                                              ),
                                            );

                                        showDialog(
                                          context: context,
                                          builder: (_) => RequestSentDialog(
                                            name: twin?.name,
                                          ),
                                        );
                                      } else {
                                        // todo change

                                      }
                                    },
                                    child: Container(
                                      height: 44.0,
                                      width: 160.0,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(28.0),
                                          border:
                                              Border.all(color: Colors.white)),
                                      child: Center(
                                        child: Text(
                                          connectionStatus(connect.status),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15.0),

                                  // authBloc.state.user != null
                                  //     ? TextButton(
                                  //         onPressed: () => Navigator.of(context)
                                  //             .pushNamed(
                                  //                 TwinsDetailsScreen.routeName,
                                  //                 arguments: TwinsDetailsArgs(
                                  //                     twin: twin)),
                                  //         child: const Text(
                                  //           'Details',
                                  //           style: TextStyle(
                                  //             color: Colors.white,
                                  //             fontSize: 13.5,
                                  //           ),
                                  //         ),
                                  //       )
                                  //     : Text.rich(
                                  //         TextSpan(
                                  //           style: const TextStyle(
                                  //             color: Colors.white,
                                  //             fontSize: 14.0,
                                  //             fontWeight: FontWeight.w500,
                                  //           ),
                                  //           children: [
                                  //             const TextSpan(
                                  //                 text:
                                  //                     'In Order To View Please '),
                                  //             TextSpan(
                                  //               text: 'Register',
                                  //               style: const TextStyle(
                                  //                   decoration: TextDecoration
                                  //                       .underline),
                                  //               recognizer: TapGestureRecognizer()
                                  //                 ..onTap = () => Navigator.of(
                                  //                         context)
                                  //                     .pushNamedAndRemoveUntil(
                                  //                         LoginScreen.routeName,
                                  //                         (route) => false),
                                  //             ),
                                  //             const TextSpan(
                                  //                 text: ' & Connect'),
                                  //           ],
                                  //         ),
                                  //       ),
                                  // const Text(
                                  //   'Details',
                                  //   style: TextStyle(
                                  //     color: Colors.white,
                                  //     fontSize: 13.5,
                                  //   ),
                                  // ),
                                ],
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
