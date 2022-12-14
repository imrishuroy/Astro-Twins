import '/repositories/astro/astro_repository.dart';
import '/cubits/connect/connect_cubit.dart';
import '/repositories/profile/profile_repository.dart';
import '/screens/astrologers/cubit/astrologers_cubit.dart';
import '/screens/profile/cubit/profile_cubit.dart';
import '/screens/your-match/cubit/your_match_cubit.dart';
import '/blocs/auth/auth_bloc.dart';
import '/repositories/twins/twins_repository.dart';
import '/screens/dashboard/cubit/dashboard_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/screens/astrologers/astrologers_screen.dart';
import '/screens/profile/profile_screen.dart';
import '/screens/your-match/your_match_screen.dart';
import '/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';

import '/enums/nav_item.dart';

class SwitchScreen extends StatelessWidget {
  final NavItem navItem;

  const SwitchScreen({Key? key, required this.navItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (navItem) {
      case NavItem.dashboard:
        return BlocProvider(
          create: (context) => DashboardCubit(
              authBloc: context.read<AuthBloc>(),
              connectCubit: context.read<ConnectCubit>(),
              twinsRepository: context.read<TwinsRepository>())
            ..loadTwins(),
          child: const DashBoardScreen(),
        );

      case NavItem.match:
        return BlocProvider(
          create: (context) => YourMatchCubit(
            authBloc: context.read<AuthBloc>(),
            twinsRepository: context.read<TwinsRepository>(),
          )..loadMatchingUsers(),
          child: const YourMatch(),
        );

      case NavItem.astrologers:
        return BlocProvider(
          create: (context) => AstrologersCubit(
            astroRepository: context.read<AstroRepository>(),
            authBloc: context.read<AuthBloc>(),
            connectCubit: context.read<ConnectCubit>(),
          )..loadAstrolgers(),
          child: const AstrologersScreen(),
        );

      case NavItem.profile:
        return BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(
            authBloc: context.read<AuthBloc>(),
            profileRepository: context.read<ProfileRepository>(),
          )..loadProfile(),
          child: const ProfileScreen(),
        );

      default:
        return const Center(
          child: Text('Wrong'),
        );
    }
  }
}
