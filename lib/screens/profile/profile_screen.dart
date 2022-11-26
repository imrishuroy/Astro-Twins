import '/widgets/curved_container.dart';
import '/screens/profile/widgets/progress_container.dart';
import '/screens/login/login_screen.dart';
import '/widgets/app_drawer.dart';
import '/widgets/display_image.dart';
import 'edit_profile_screen.dart';
import '/screens/profile/cubit/profile_cubit.dart';
import '/widgets/loading_indicator.dart';
import '/widgets/show_snakbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return Scaffold(
      //backgroundColor: Colors.white,
      drawer: const AppDrawer(),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.error) {
            ShowSnackBar.showSnackBar(context, title: state.failure.message);
          }
        },
        builder: (context, state) {
          if (state.status == ProfileStatus.loading) {
            return const LoadingIndicator();
          }
          final user = state.user;
          final localizations = MaterialLocalizations.of(context);
          final formattedTimeOfDay = user?.birthTime != null
              ? localizations.formatTimeOfDay(user!.birthTime!)
              : 'N/A';

          return Stack(
            children: [
              const CurvedContainer(),
              Positioned(
                top: 38.0,
                left: 2.0,
                right: 2.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      icon: const Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svgs/twins.svg',
                          height: 27.0,
                          width: 27.0,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10.0),
                        const Text(
                          'AstroTwins',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    state.user == null
                        ? const SizedBox(width: 36.0)
                        : IconButton(
                            onPressed: () async {
                              final result = await Navigator.of(context)
                                  .pushNamed(EditProfileScreen.routeName);
                              if (result == true) {
                                context
                                    .read<ProfileCubit>()
                                    .loadProfile(editProfile: true);
                              }
                            },
                            icon: const Icon(
                              Icons.edit,
                              size: 20.0,
                              color: Colors.white,
                            ),
                          )
                  ],
                ),
              ),
              state.user == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'No data found, please',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Contants.primaryColor,
                            ),
                            onPressed: () => Navigator.of(context)
                                .pushNamedAndRemoveUntil(
                                    LoginScreen.routeName, (route) => false),
                            child: const Text('Login'),
                          ),
                        ],
                      ),
                    )
                  : Positioned(
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: SizedBox(
                              height: _size.height * 0.74,
                              child: ListView(
                                children: [
                                  const SizedBox(height: 80.0),
                                  Center(
                                    child: Text(
                                      state.user?.name ?? 'N/A',
                                      style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        size: 18.0,
                                      ),
                                      const SizedBox(width: 5.0),
                                      // Text('Chennai, India'),
                                      Text(state.user?.birthPlace ?? ''),
                                      const SizedBox(width: 5.0)
                                    ],
                                  ),
                                  const SizedBox(height: 20.0),
                                  ProgressContainer(
                                      progress: state.profileCompleteCount),
                                  // Padding(
                                  //   padding: const EdgeInsets.symmetric(
                                  //       horizontal: 20.0),
                                  //   child: Container(
                                  //     height: 9.0,
                                  //     width: 30.0,
                                  //     decoration: BoxDecoration(
                                  //       color: Contants.primaryColor,
                                  //       borderRadius:
                                  //           BorderRadius.circular(40.0),
                                  //     ),
                                  //   ),
                                  // ),

                                  const SizedBox(height: 30.0),
                                  const Text(
                                    'About',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(state.user?.about ?? 'N/A'),
                                  const SizedBox(height: 10.0),
                                  const Text(
                                    'Email',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(state.user?.email ?? ''),
                                  const SizedBox(height: 20.0),
                                  const Divider(thickness: 1.0),
                                  const SizedBox(height: 15.0),
                                  const Text('Date Of Birth'),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    state.user?.birthDate ?? 'N/A',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 17.0),
                                  const Text('Time Of Birth'),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    formattedTimeOfDay,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 17.0),
                                  const Text('Place Of Birth'),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    state.user?.birthPlace ?? 'N/A',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 17.0),
                                  const Text('Timezone'),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    state.user?.timezone ?? 'N/A',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),

                                  const SizedBox(height: 20.0),
                                  const Divider(thickness: 1.0),
                                  // const SizedBox(height: 20.0),
                                  // const Text('My Astro'),
                                  // const SizedBox(height: 8.0),
                                  // Text(
                                  //   user?.astro ?? 'N/A',
                                  //   style: const TextStyle(
                                  //     fontWeight: FontWeight.w600,
                                  //   ),
                                  // ),
                                  const SizedBox(height: 20.0),
                                  const Text('Sex'),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    user?.sex ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 10.0),
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
                        imageUrl: state.user?.profileImg,
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
