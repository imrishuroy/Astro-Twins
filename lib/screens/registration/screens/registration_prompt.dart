import '/config/shared_prefs.dart';
import '/screens/login/login_screen.dart';
import '/screens/search-twins/search_twins_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RegistrationPrompt extends StatelessWidget {
  static const String routeName = '/registrationPrompt';
  const RegistrationPrompt({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const RegistrationPrompt(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomCenter,
          // stops: [0.1, 0.5, 0.7, 0.9],
          stops: [0.6, 0.9],
          colors: [
            Color(0xffED462F),
            Color(0xffF28931),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                const SizedBox(height: 200.0),
                SvgPicture.asset(
                  'assets/svgs/twins.svg',
                  height: 50.0,
                  width: 50.0,
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'AstroTwins',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                  ),
                ),
                const SizedBox(height: 40.0),
                const Text(
                  'You should register & view\n your astrotwins',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () async {
                    await SharedPrefs().setSkipRegistration(true);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        LoginScreen.routeName, (route) => false);
                  },
                  child: Container(
                    height: 44.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: Colors.white)),
                    child: const Center(
                      child: Text(
                        'Login / Register',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                TextButton(
                  onPressed: () async {
                    await SharedPrefs().setSkipRegistration(true);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        SearchTwinsScreen.routeName, (route) => false);
                  },
                  child: const Text(
                    'Skip >>',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
