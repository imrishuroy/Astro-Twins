import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/blocs/auth/auth_bloc.dart';
import '/cubits/connect/connect_cubit.dart';
import '/repositories/astro/astro_repository.dart';
import '/repositories/chat/chat_repository.dart';
import '/repositories/notif/notif_repository.dart';
import '/repositories/twins/twins_repository.dart';
import '/screens/notifictions/cubit/notifications_cubit.dart';
import '/screens/splash/splash_screen.dart';
import 'blocs/simple_bloc_observer.dart';
import 'config/custom_router.dart';
import 'config/shared_prefs.dart';
import 'firebase_options.dart';
import 'repositories/agora/agora_repository.dart';
import 'repositories/auth/auth_repo.dart';
import 'repositories/profile/profile_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SharedPrefs().init();
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = SimpleBlocObserver();

  runApp(const MyApp());
  //runApp(const MaterialApp(home: JoinChannelAudio()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //SharedPrefs().deleteEverything();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(

          /// systemNavigationBarColor: Colors.blue, // navigation bar color
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark // status bar color
          ),
    );
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) => AuthRepository(),
        ),
        RepositoryProvider<ProfileRepository>(
          create: (_) => ProfileRepository(),
        ),
        RepositoryProvider<TwinsRepository>(
          create: (_) => TwinsRepository(),
        ),
        RepositoryProvider<NotificationRepository>(
          create: (_) => NotificationRepository(),
        ),
        RepositoryProvider<ChatRepository>(
          create: (_) => ChatRepository(),
        ),
        RepositoryProvider<AstroRepository>(
          create: (_) => AstroRepository(),
        ),
        RepositoryProvider<AgoraRepository>(
          create: (_) => AgoraRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
                authRepository: context.read<AuthRepository>(),
                profileRepository: context.read<ProfileRepository>()),
          ),
          BlocProvider<ConnectCubit>(
            create: (context) => ConnectCubit(
                twinsRepository: context.read<TwinsRepository>(),
                authBloc: context.read<AuthBloc>(),
                astroRepository: context.read<AstroRepository>()),
          ),
          BlocProvider<NotificationsCubit>(
            create: (context) => NotificationsCubit(
              notificationRepository: context.read<NotificationRepository>(),
              authBloc: context.read<AuthBloc>(),
            ),
          ),
        ],
        child: MaterialApp(
          //showPerformanceOverlay: true,
          theme: ThemeData(
            primaryColor: const Color(0xffED462F),
            // CUSTOMIZE showDatePicker Colors
            colorScheme: const ColorScheme.light(primary: Color(0xffED462F)),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),

            fontFamily: 'GoogleSans',

            // scaffoldBackgroundColor: const Color(0xffED462F),
          ),
          debugShowCheckedModeBanner: false,
          //  home: const SplashScreen3(),

          //  const ShowUp(
          //   child: Scaffold(
          //     body: Center(
          //       child: Text('I am good'),
          //     ),
          //   ),
          //   delay: 10,
          // ),
          onGenerateRoute: CustomRouter.onGenerateRoute,
          initialRoute: SplashScreen.routeName,

          // (SharedPrefs().birthDetails?.birthDate == null)
          //     ? SearchTwinsScreen.routeName
          //     : AuthWrapper.routeName
          //AutphWrapper.routeName,

          // debugShowCheckedModeBanner: false,
          // title: 'Flutter Demo',
          // theme: ThemeData(
          //   scaffoldBackgroundColor: Colors.white,
          //   primarySwatch: Colors.blue,
          //   fontFamily: 'GoogleSans',
          // ),
          // home: const SplashScreen(),
          //home: const DashBoard(),
        ),
      ),
    );
  }
}
