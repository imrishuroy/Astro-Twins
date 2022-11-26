import '/screens/chat/astro_chat_screen.dart';
import '/screens/chat/chat_screen.dart';
import '/screens/chat/media_preview.dart';
import '/screens/faq/faq_screen.dart';
import '/screens/reset-password/reset_password.dart';
import '/screens/terms/terms_screen.dart';
import '/screens/privacy/privacy_screen.dart';
import '/screens/profile/edit_profile_screen.dart';
import '/screens/dashboard/widgets/twin_details.dart';
import '/screens/astrologers/astrologer_details.dart';
import '/screens/login/login_screen.dart';
import '/screens/nav/nav_screen.dart';
import '/screens/notifictions/notifications_screen.dart';
import '/screens/registration/screens/registration_prompt.dart';
import '/screens/registration/screens/registration_screen.dart';
import '../screens/search-twins/search_twins_screen.dart';
import 'package:flutter/material.dart';

import '/screens/splash/splash_screen.dart';

import 'auth_wrapper.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print('Route: ${settings.name}');
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            settings: const RouteSettings(name: '/'),
            builder: (_) => const Scaffold());

      case AuthWrapper.routeName:
        return AuthWrapper.route();

      case SplashScreen.routeName:
        return SplashScreen.route();

      case NavScreen.routeName:
        return NavScreen.route();

      case RegistrationPrompt.routeName:
        return RegistrationPrompt.route();

      case RegistrationScreen.routeName:
        return RegistrationScreen.route();

      case SearchTwinsScreen.routeName:
        return SearchTwinsScreen.route();

      case LoginScreen.routeName:
        return LoginScreen.route();

      case EditProfileScreen.routeName:
        return EditProfileScreen.route();

      case AstrologerDetails.routeName:
        return AstrologerDetails.route(
            args: settings.arguments as AstrologerArgs?);

      case NotificationsScreen.routeName:
        return NotificationsScreen.route();

      case TwinsDetailsScreen.routeName:
        return TwinsDetailsScreen.route(
            args: settings.arguments as TwinsDetailsArgs);

      case PrivacyScreen.routeName:
        return PrivacyScreen.route();

      case TermsScreen.routeName:
        return TermsScreen.route();

      case ChatScreen.routeName:
        return ChatScreen.route(args: settings.arguments as ChatScreenArgs);

      case AstoChatScreen.routeName:
        return AstoChatScreen.route(
            args: settings.arguments as AstroChatScreenArgs);

      case MediaPreview.routeName:
        return MediaPreview.route(args: settings.arguments as MediaPreviewArgs);

      case ResetPassword.routeName:
        return ResetPassword.route(
            args: settings.arguments as ResetPasswordArgs?);

      case FaqScreen.routeName:
        return FaqScreen.route();
      default:
        return _errorRoute();
    }
  }

  static Route onGenerateNestedRouter(RouteSettings settings) {
    print('NestedRoute: ${settings.name}');
    switch (settings.name) {
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Error',
          ),
        ),
        body: const Center(
          child: Text(
            'Something went wrong',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
