import '/models/notif.dart';
import '/widgets/display_image.dart';
import '/widgets/notification_icon.dart';
import '/widgets/loading_indicator.dart';
import '/widgets/show_snakbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/blocs/auth/auth_bloc.dart';
import '/repositories/notif/notif_repository.dart';
import '/screens/notifictions/cubit/notifications_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/extensions/extensions.dart';

class NotificationsScreen extends StatelessWidget {
  static const String routeName = '/notifications';
  const NotificationsScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider(
        create: (context) => NotificationsCubit(
          authBloc: context.read<AuthBloc>(),
          notificationRepository: context.read<NotificationRepository>(),
        )..loadUserNotifications(),
        child: const NotificationsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    // final _registrationCubit = context.read<RegistrationCubit>();
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(true);
        return true;
      },
      child: Scaffold(
        body: BlocConsumer<NotificationsCubit, NotificationsState>(
          listener: (context, state) {
            if (state.status == NotificationStatus.error) {
              ShowSnackBar.showSnackBar(context,
                  title: state.failure.message, backgroundColor: Colors.red);
            }
          },
          builder: (context, state) {
            if (state.status == NotificationStatus.loading) {
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
                  top: 30.0,
                  left: 10.0,
                  right: 10.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/svgs/twins.svg',
                            height: 28.0,
                            width: 28.0,
                          ),
                          const SizedBox(width: 10.0),
                          const Text(
                            'AstroTwins',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                        ],
                      ),
                      NotificationIcon(
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
                const Positioned(
                  top: 100.0,
                  left: 10.0,
                  right: 10.0,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 22.0),
                        child: Text(
                          'Notifications',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 140.0,
                  left: 10.0,
                  right: 10.0,
                  child: Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: SizedBox(
                        height: _size.height * 0.8,
                        child: state.notifications.isEmpty
                            ? const Center(
                                child: Text('You don\'t have notifications'),
                              )
                            : ListView.builder(
                                itemCount: state.notifications.length,
                                itemBuilder: (context, index) {
                                  return NotificationTile(
                                    notif: state.notifications[index],
                                  );
                                },
                              ),
                      ),
                    ),
                  ),
                  //),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final Notif? notif;
  const NotificationTile({
    Key? key,
    required this.notif,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.grey.shade200,
          width: 0.8,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 12.0,
        ),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: DisplayImage(
                    imageUrl: notif?.fromUser?.profileImg,
                    height: 50.0,
                    width: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width * 0.38,
                      child: Text(
                        notif?.fromUser?.name ?? '',
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 7.0),
                    const Text(
                      'Friend Request',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.start,
                    )
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.read<NotificationsCubit>().acceptReq(
                            otherUserId: notif?.fromUser?.userId,
                            notifId: notif?.id,
                          ),
                      child: const CircleAvatar(
                        radius: 12.0,
                        backgroundColor: Colors.green,
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16.0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 28.0),
                    GestureDetector(
                      onTap: () => context.read<NotificationsCubit>().rejectReq(
                            otherUserId: notif?.fromUser?.userId,
                            notifId: notif?.id,
                          ),
                      child: const CircleAvatar(
                        radius: 12.0,
                        backgroundColor: Colors.red,
                        child: Icon(
                          Icons.clear,
                          color: Colors.white,
                          size: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
                // Column(
                //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [

                //     const SizedBox(height: 10.0),

                //   ],
                // ),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: Text(
                notif?.date != null ? notif!.date.timeAgo() : 'N/A',
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 13.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
