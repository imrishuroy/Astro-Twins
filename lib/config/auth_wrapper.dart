import '/config/shared_prefs.dart';
import '../screens/search-twins/search_twins_screen.dart';
import '/blocs/auth/auth_bloc.dart';
import '/screens/nav/nav_screen.dart';
import '/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthWrapper extends StatelessWidget {
  static const String routeName = '/authwrapper';

  const AuthWrapper({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const AuthWrapper(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        print('Auth Wrapper state -- $state');
        print('Check -- 1');
        if (state.status == AuthStatus.unauthenticated) {
          if (SharedPrefs().birthDetails?.birthDate == null) {
            print('Check 2');
            Navigator.of(context).pushNamed(SearchTwinsScreen.routeName);
          } else {
            print('Check 3');
            Navigator.of(context).pushNamed(NavScreen.routeName);
            // Navigator.of(context).pushNamed(LoginScreen.routeName);
          }
        } else if (state.status == AuthStatus.authenticated) {
          Navigator.of(context).pushNamed(NavScreen.routeName);

          // print('Check 4');
          // print('User from auth wrapper - ${state.user}');
          // if (state.user?.birthPlace == null &&
          //     state.user?.birthDate == null &&
          //     state.user?.birthTime == null) {
          //   Navigator.of(context).pushNamed(SearchTwinsScreen.routeName);
          // } else {
          //   print('Check 5');
          //   Navigator.of(context).pushNamed(NavScreen.routeName);
          // }
        } else {
          print('Check 6');
        }
      },
      child: const Scaffold(
        backgroundColor: Color(0xffED462F),
        body: LoadingIndicator(color: Colors.white),
      ),
    );
  }
}
