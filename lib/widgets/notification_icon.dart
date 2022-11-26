import '/screens/notifictions/cubit/notifications_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationIcon extends StatelessWidget {
  final VoidCallback onTap;

  const NotificationIcon({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notificationCubit = context.read<NotificationsCubit>();
    return Padding(
      padding: const EdgeInsets.only(right: 5.0),
      child: IconButton(
        onPressed: onTap,
        icon: Stack(
          children: [
            const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            Align(
              alignment: Alignment.topRight,
              child: CircleAvatar(
                backgroundColor: Colors.amber,
                radius: 7.0,
                child: Text(
                  '${notificationCubit.state.notifications.length}',
                  style: const TextStyle(
                    fontSize: 10.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
