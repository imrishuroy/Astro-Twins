import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

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

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController();
    context.read<NotificationsCubit>().loadUserNotifications();
    super.initState();
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
