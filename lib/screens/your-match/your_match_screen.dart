import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/cubits/connect/connect_cubit.dart';
import '/enums/connect_status.dart';
import '/models/connect.dart';
import '/screens/notifictions/notifications_screen.dart';
import '/screens/your-match/cubit/your_match_cubit.dart';
import '/widgets/app_drawer.dart';
import '/widgets/curved_container.dart';
import '/widgets/loading_indicator.dart';
import '/widgets/notification_icon.dart';
import '/widgets/show_snakbar.dart';
import 'widgets/user_tile.dart';

class YourMatch extends StatelessWidget {
  const YourMatch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final yourMatchCubit = context.read<YourMatchCubit>();

    return Scaffold(
      drawer: const AppDrawer(),
      body: BlocConsumer<YourMatchCubit, YourMatchState>(
        listener: (context, state) {
          if (state.status == YourMatchStatus.error) {
            ShowSnackBar.showSnackBar(context,
                title: state.failure.message, backgroundColor: Colors.red);
          }
        },
        builder: (context, state) {
          if (state.status == YourMatchStatus.loading) {
            return const LoadingIndicator();
          }

          return Stack(
            children: [
              const CurvedContainer(),
              Positioned(
                top: 38.0,
                left: 2.0,
                right: 2.0,
                child: Row(
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
                        yourMatchCubit.loadMatchingUsers();
                      }
                    }),
                  ],
                ),
              ),
              const Positioned(
                top: 100.0,
                left: 8.0,
                right: 8.0,
                child: Card(
                  color: Color(0xffFAFAFA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 20.0,
                    ),
                    child: Text(
                      'Your matches',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 140.0,
                left: 8.0,
                right: 8.0,
                child: Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                    ),
                  ),
                  color: const Color(0xffFAFAFA),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: SizedBox(
                      height: size.height * 0.745,
                      child: state.users.isEmpty
                          ? const Center(
                              child: Text(
                                'No Match Found',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                ),
                              ),
                            )
                          : AnimationLimiter(
                              child: ListView.builder(
                                itemCount: state.users.length,
                                itemBuilder: (context, index) {
                                  final user = state.users[index];
                                  final connectedUsersState =
                                      context.watch<ConnectCubit>().state;

                                  final Connect connect = connectedUsersState
                                      .connectedUserIds
                                      .firstWhere(
                                          (element) =>
                                              element.userId == user?.userId,
                                          orElse: () {
                                    return const Connect(
                                        status: ConnectStatus.unknown,
                                        userId: null);
                                  });
                                  print('COnnect ----- $connect');

                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 375),
                                    child: SlideAnimation(
                                      verticalOffset: 50.0,
                                      child: FadeInAnimation(
                                        child: UserTile(
                                          user: user,
                                          connectStatus: connect.status,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
