import 'package:astro_twins/screens/login/login_screen.dart';
import 'package:astro_twins/screens/reset-password/reset_password.dart';

import '/config/shared_prefs.dart';
import '../screens/search-twins/search_twins_screen.dart';
import '/screens/notifictions/cubit/notifications_cubit.dart';
import '/screens/faq/faq_screen.dart';
import '/screens/notifictions/notifications_screen.dart';
import '/screens/terms/terms_screen.dart';
import '/screens/privacy/privacy_screen.dart';
import '/constants/constants.dart';
import 'package:flutter_svg/svg.dart';
import '/widgets/display_image.dart';
import '/blocs/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final size = MediaQuery.of(context).size;
    final notificationCubit = context.read<NotificationsCubit>();
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              height: 100.0,
              decoration: const BoxDecoration(
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        authBloc.state.user?.name ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        authBloc.state.user?.email ?? '',
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  CircleAvatar(
                    radius: 30.0,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: DisplayImage(
                        imageUrl: authBloc.state.user?.profileImg,
                        height: 56.0,
                        width: 56.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                ListTile(
                  title: const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 14.5,
                      // color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: CircleAvatar(
                    backgroundColor: const Color(0xff00CBFF),
                    radius: 12.0,
                    child: Text(
                      '${notificationCubit.state.notifications.length}',
                      style: const TextStyle(
                        fontSize: 13.2,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  onTap: () => Navigator.of(context)
                      .pushNamed(NotificationsScreen.routeName),
                ),
                ListTile(
                  title: Text(
                    'Privacy',
                    style: TextStyle(
                      fontSize: 14.5,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  onTap: () =>
                      Navigator.of(context).pushNamed(PrivacyScreen.routeName),
                ),
                ListTile(
                  title: Text(
                    'Terms',
                    style: TextStyle(
                      fontSize: 14.5,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  onTap: () =>
                      Navigator.of(context).pushNamed(TermsScreen.routeName),
                ),
                ListTile(
                  title: Text(
                    'FAQ',
                    style: TextStyle(
                      fontSize: 14.5,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  onTap: () =>
                      Navigator.of(context).pushNamed(FaqScreen.routeName),
                ),

                if (authBloc.state.user != null)
                  ListTile(
                      title: Text(
                        'Reset Password',
                        style: TextStyle(
                          fontSize: 14.5,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      onTap: () {
                        Scaffold.of(context).closeDrawer();
                        Navigator.of(context)
                            .pushNamed(ResetPassword.routeName);
                      }),

                authBloc.state.user == null
                    ? ListTile(
                        title: Text(
                          'Login / Register',
                          style: TextStyle(
                            fontSize: 14.5,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        onTap: () => Navigator.of(context)
                            .pushNamedAndRemoveUntil(
                                LoginScreen.routeName, (route) => false),
                      )
                    : ListTile(
                        title: Text(
                          'Sign out',
                          style: TextStyle(
                            fontSize: 14.5,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        onTap: () async {
                          context.read<AuthBloc>().add(AuthLogoutRequested());
                          await SharedPrefs().deleteEverything();
                          await SharedPrefs().setShowLogin();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              SearchTwinsScreen.routeName, (route) => false);
                        },
                      ),
                //const Spacer(),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.33),
          Divider(
            color: Colors.grey.shade400,
            thickness: 0.2,
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(
              //vertical: 20.0,
              horizontal: 20.0,
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/svgs/twins.svg',
                  height: 30.0,
                  width: 30.0,
                  color: Contants.primaryColor,
                ),
                const SizedBox(width: 20.0),
                const Text(
                  'Astro Twins',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
