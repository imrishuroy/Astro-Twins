import 'package:astro_twins/constants/constants.dart';

import '/blocs/auth/auth_bloc.dart';
import '/repositories/profile/profile_repository.dart';
import '/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/nav_bloc.dart';
import 'widgets/bottom_nav_bar.dart';
import 'widgets/switch_screen.dart';

class NavScreen extends StatefulWidget {
  static const String routeName = '/nav';

  static Route route() {
    return MaterialPageRoute(
      builder: (_) => BlocProvider<NavBloc>(
        create: (context) => NavBloc(
          authBloc: context.read<AuthBloc>(),
          profileRepository: context.read<ProfileRepository>(),
        )..add(UpDateAuthUser()),
        child: const NavScreen(),
      ),
    );
  }

  const NavScreen({Key? key}) : super(key: key);

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocBuilder<NavBloc, NavState>(
        builder: (context, state) {
          return

              // Container(
              //   height: double.infinity,
              //   decoration: const BoxDecoration(
              //     gradient: LinearGradient(
              //       begin: Alignment.topLeft,
              //       end: Alignment.bottomCenter,
              //       // stops: [0.1, 0.5, 0.7, 0.9],
              //       stops: [0.08, 0.2],
              //       colors: [
              //         Color(0xffF28931),
              //         Color(0xffED462F),
              //       ],
              //     ),
              //   ),
              //   child: const LoadingIndicator(color: Colors.white),

              Scaffold(
            // backgroundColor: state.status == NavStatus.loading
            //     ? const Color(0xffED462F)
            //     : Colors.white,
            body: state.status == NavStatus.loading
                ? const LoadingIndicator(color: Contants.primaryColor)
                : SwitchScreen(navItem: state.item),
            bottomNavigationBar: state.status == NavStatus.loading
                ? const SizedBox.shrink()
                : BottomNavBar(
                    navItem: state.item,
                    onitemSelected: (item) => BlocProvider.of<NavBloc>(context)
                        .add(UpdateNavItem(item: item)),
                  ),
          );
          //),
          // );
        },
      ),
    );
  }
}
