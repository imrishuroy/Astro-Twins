import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '/blocs/auth/auth_bloc.dart';
import '/cubits/connect/connect_cubit.dart';
import '/enums/connect_status.dart';
import '/models/connect.dart';
import '/screens/astrologers/cubit/astrologers_cubit.dart';
import '/screens/astrologers/widgets/astrologer_tile.dart';
import '/screens/login/login_screen.dart';
import '/screens/notifictions/notifications_screen.dart';
import '/widgets/app_drawer.dart';
import '/widgets/loading_indicator.dart';
import '/widgets/notification_icon.dart';
import '/widgets/show_snakbar.dart';

class AstrologersScreen extends StatelessWidget {
  const AstrologersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authBloc = context.read<AuthBloc>();

    return Scaffold(
      drawer: const AppDrawer(),
      body: BlocConsumer<AstrologersCubit, AstrologersState>(
        listener: (context, state) {
          if (state.status == AstrologersStatus.error) {
            ShowSnackBar.showSnackBar(context,
                title: state.failure.message, backgroundColor: Colors.red);
          }
        },
        builder: (context, state) {
          if (state.status == AstrologersStatus.loading) {
            return const LoadingIndicator();
          }
          return Stack(
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
                        // stops: [0.1, 0.5, 0.7, 0.9],
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
                top: 38.0,
                left: 2.0,
                right: 2.0,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Astrologers',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    NotificationIcon(
                      onTap: () => Navigator.of(context)
                          .pushNamed(NotificationsScreen.routeName),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 100.0,
                left: 8.0,
                right: 8.0,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  color: const Color(0xffFAFAFA),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      height: size.height * 0.8,
                      child: state.astrologers.isEmpty
                          ? const Center(
                              child: Text(
                                'No Astrologer Found',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17.0,
                                ),
                              ),
                            )
                          : AnimationLimiter(
                              child: ListView.builder(
                                itemCount: state.astrologers.length,
                                itemBuilder: (context, index) {
                                  final astrologer = state.astrologers[index];

                                  final connectedState =
                                      context.watch<ConnectCubit>().state;

                                  final Connect connect = connectedState
                                      .connectedAstroIds
                                      .firstWhere(
                                    (element) =>
                                        element.userId == astrologer?.astroId,
                                    orElse: () {
                                      return const Connect(
                                        status: ConnectStatus.unknown,
                                        userId: null,
                                      );
                                    },
                                  );
                                  print('COnnect ----- $connect');

                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 375),
                                    child: SlideAnimation(
                                      verticalOffset: 50.0,
                                      child: FadeInAnimation(
                                        child: AstrologerTile(
                                          astrologer: astrologer,
                                          connectStatus: connect.status,
                                          onTap: () {
                                            print('aalaa');
                                            if (authBloc.state.user == null) {
                                              ShowSnackBar.showSnackBar(
                                                context,
                                                title:
                                                    'Please login to see details',
                                                backgroundColor:
                                                    Colors.deepOrangeAccent,
                                                onTap: () => Navigator.of(
                                                        context)
                                                    .pushNamedAndRemoveUntil(
                                                  LoginScreen.routeName,
                                                  (route) => false,
                                                ),
                                              );
                                            } else if (connect.status !=
                                                ConnectStatus.connected) {
                                              print('this runs 11');
                                              print('Astro -- $astrologer');
                                              context
                                                  .read<ConnectCubit>()
                                                  .connectAstro(
                                                    astroConnect: Connect(
                                                      status: ConnectStatus
                                                          .connected,
                                                      userId:
                                                          astrologer?.astroId,
                                                    ),
                                                  );
                                            }
                                          },
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
