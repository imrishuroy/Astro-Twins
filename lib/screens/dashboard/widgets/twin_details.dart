import 'package:astro_twins/widgets/request_sent_dialog.dart';

import '/blocs/auth/auth_bloc.dart';
import '/cubits/connect/connect_cubit.dart';
import '/enums/connect_status.dart';
import '/models/connect.dart';
import '/repositories/twins/twins_repository.dart';
import '/screens/dashboard/cubit/dashboard_cubit.dart';
import '/models/app_user.dart';
import '/widgets/app_drawer.dart';
import '/widgets/display_image.dart';
import '/screens/profile/cubit/profile_cubit.dart';
import '/widgets/loading_indicator.dart';
import '/widgets/show_snakbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/constants/constants.dart';
import 'package:flutter/material.dart';

class TwinsDetailsArgs {
  final AppUser? twin;

  TwinsDetailsArgs({required this.twin});
}

class TwinsDetailsScreen extends StatefulWidget {
  static const String routeName = '/twinDetails';

  final AppUser? twin;
  const TwinsDetailsScreen({
    Key? key,
    required this.twin,
  }) : super(key: key);

  static Route route({required TwinsDetailsArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider(
        create: (context) => DashboardCubit(
          twinsRepository: context.read<TwinsRepository>(),
          authBloc: context.read<AuthBloc>(),
          connectCubit: context.read<ConnectCubit>(),
        ),
        child: TwinsDetailsScreen(twin: args.twin),
      ),
    );
  }

  @override
  State<TwinsDetailsScreen> createState() => _TwinsDetailsScreenState();
}

class _TwinsDetailsScreenState extends State<TwinsDetailsScreen> {
  String connectionStatus(ConnectStatus? status) {
    switch (status) {
      case ConnectStatus.connected:
        return 'Connected';

      case ConnectStatus.pending:
        return 'Request Pending';

      case ConnectStatus.sent:
        return 'Sent';

      case ConnectStatus.unknown:
        return 'Unknown';
      default:
        return 'Connect';
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = widget.twin;
    final localizations = MaterialLocalizations.of(context);
    final formattedTimeOfDay = user?.birthTime != null
        ? localizations.formatTimeOfDay(user!.birthTime!)
        : 'N/A';

    final connectedUsersState = context.watch<ConnectCubit>().state;

    final Connect? connect = connectedUsersState.connectedUserIds
        .firstWhere((element) => element.userId == user?.userId, orElse: () {
      return const Connect(status: ConnectStatus.unknown, userId: null);
    });
    print('COnnect ----- $connect');

    return Scaffold(
      drawer: const AppDrawer(),
      body: BlocConsumer<DashboardCubit, DashboardState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.error) {
            ShowSnackBar.showSnackBar(context, title: state.failure.message);
          }
        },
        builder: (context, state) {
          if (state.status == ProfileStatus.loading) {
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
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          user?.name ?? 'N/A',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
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
                        height: size.height * 0.82,
                        child: ListView(
                          children: [
                            const SizedBox(height: 80.0),
                            Center(
                              child: Text(
                                user?.name ?? 'N/A',
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Text(
                              user?.email ?? '',
                              style: const TextStyle(),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20.0),
                            const SizedBox(height: 30.0),
                            const Text(
                              'About',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(user?.about ?? ''),
                            const SizedBox(height: 10.0),
                            const Text(
                              'Email',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 8.0),
                            Text(user?.email ?? ''),
                            const SizedBox(height: 20.0),
                            const Divider(thickness: 1.0),
                            const SizedBox(height: 15.0),
                            const Text('Date Of Birth'),
                            const SizedBox(height: 8.0),
                            Text(
                              user?.birthDate ?? 'N/A',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 17.0),
                            const Text('Time Of Birth'),
                            const SizedBox(height: 8.0),
                            Text(
                              formattedTimeOfDay,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 17.0),
                            const Text('Place Of Birth'),
                            const SizedBox(height: 8.0),
                            Text(
                              user?.birthPlace ?? '',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 20.0),
                            const Divider(thickness: 1.0),
                            const SizedBox(height: 20.0),
                            const Text('Sex'),
                            const SizedBox(height: 8.0),
                            Text(
                              user?.sex ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.16),
                              child: GestureDetector(
                                onTap: () {
                                  if (connect?.userId != null) {}
                                  // context.read<ConnectCubit>().disConnectUser(
                                  //     otherUserId: twin?.userId);

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
                                  // }
                                },
                                child: Container(
                                  height: 46.0,
                                  width: 100.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(32.0),
                                    border: Border.all(
                                      color: Contants.primaryColor,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      connectionStatus(connect?.status),
                                      style: const TextStyle(
                                        color: Contants.primaryColor,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 25.0),
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
                        imageUrl: user?.profileImg,
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.cover,
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
