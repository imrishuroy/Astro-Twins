import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '/blocs/auth/auth_bloc.dart';
import '/config/shared_prefs.dart';
import '/repositories/twins/twins_repository.dart';
import '/screens/login/login_screen.dart';
import '/screens/nav/nav_screen.dart';
import '/screens/search-twins/cubit/search_twins_cubit.dart';
import '/widgets/birth_fields.dart';
import '/widgets/show_snakbar.dart';
import '/widgets/time_zone_field.dart';
import 'widgets/searching_indicator.dart';

//  add ticker
class SearchTwinsScreen extends StatefulWidget {
  static const String routeName = '/searchTwins';
  const SearchTwinsScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider<SearchTwinsCubit>(
        create: (context) => SearchTwinsCubit(
          twinsRepository: context.read<TwinsRepository>(),
          authBloc: context.read<AuthBloc>(),
        ),
        child: const SearchTwinsScreen(),
      ),
    );
  }

  @override
  State<SearchTwinsScreen> createState() => _SearchTwinsScreenState();
}

class _SearchTwinsScreenState extends State<SearchTwinsScreen> {
  void _search() async {
    await SharedPrefs().setSkipRegistration(true);
    final seachCubit = context.read<SearchTwinsCubit>();
    if (seachCubit.state.formValid) {
      seachCubit.search();
    } else {
      ShowSnackBar.showSnackBar(context,
          title: 'Please add fields to continue', backgroundColor: Colors.red);
    }
  }

  @override
  void initState() {
    context.read<SearchTwinsCubit>().getCurrentTimeZone();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMMM yyyy');
    final localizations = MaterialLocalizations.of(context);

    final searchCubit = context.read<SearchTwinsCubit>();
    final size = MediaQuery.of(context).size;
    //FirebaseAuth.instance.signOut();
    // print('Birth saved -- ${SharedPrefs().birthDetails?.isEmpty}');
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<SearchTwinsCubit, SearchTwinsState>(
        listener: (context, state) {
          if (state.status == SearchTwinsStatus.succuss) {
            // Navigator.of(context).pushNamedAndRemoveUntil(
            //     AuthWrapper.routeName, (route) => false);
            Navigator.of(context)
                .pushNamedAndRemoveUntil(NavScreen.routeName, (route) => false);
          }
        },
        builder: (context, state) {
          if (state.status == SearchTwinsStatus.loading) {
            return const SearchingTwinsIndicator();
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
                top: 60.0,
                left: 2.0,
                right: 2.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/svgs/twins.svg',
                      height: 27.0,
                      width: 27.0,
                    ),
                    const SizedBox(width: 10.0),
                    const Text(
                      'AstroTwins',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                  ],
                ),
              ),
              Positioned(
                top: 140.0,
                left: 10.0,
                right: 10.0,
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      height: size.height * 0.78,
                      child: ListView(
                        //crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20.0),
                          const Center(
                            child: Text(
                              'Seach Your Astro Twins',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            'Astro twins are two people born on same day,month,year,time and place.',
                            style: TextStyle(color: Colors.grey.shade600),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 40.0),
                          const Text('Date of Birth'),
                          const SizedBox(height: 7.0),
                          BirthFields(
                            text: state.birthDate,
                            hintText: 'Select Date',
                            icon: const Icon(
                              Icons.calendar_month,
                              color: Colors.black,
                            ),
                            onTap: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1700),
                                lastDate: DateTime.now(),
                              );
                              print('Picked date ');
                              if (pickedDate != null) {
                                searchCubit.dateOfBirthChanged(
                                    dateFormat.format(pickedDate));
                              }
                            },
                          ),
                          const SizedBox(height: 20.0),
                          const Text('Time of Birth'),
                          const SizedBox(height: 7.0),
                          BirthFields(
                            text: state.birthTime != null
                                ? localizations
                                    .formatTimeOfDay(state.birthTime!)
                                : null,
                            hintText: 'Select Time',
                            icon: const Icon(
                              Icons.schedule,
                              color: Colors.black,
                            ),
                            onTap: () async {
                              final pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now());
                              if (pickedTime != null) {
                                searchCubit.timeOfBirthChanged(pickedTime);
                              }

                              print('Picked Time ');
                            },
                          ),
                          const SizedBox(height: 20.0),
                          const Text('Place of Birth'),
                          const SizedBox(height: 7.0),
                          BirthFields(
                            text: state.birthPlace,
                            isPlaceField: true,
                            hintText: 'Select Place',
                            icon: CountryListPick(
                              appBar: AppBar(
                                iconTheme:
                                    const IconThemeData(color: Colors.black),
                                centerTitle: true,
                                elevation: 0.0,
                                backgroundColor: Colors.white,
                                title: const Text(
                                  'Set Place',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),

                              theme: CountryTheme(
                                isShowFlag: false,
                                isShowTitle: false,
                                isShowCode: false,
                                isDownIcon: true,
                                showEnglishName: true,
                                //lastPickText: null,
                              ),

                              // Set default value
                              // initialSelection: '+91',
                              // or
                              // initialSelection: 'US'
                              onChanged: (CountryCode? code) {
                                print(code?.name);
                                print(code?.code);
                                print(code?.dialCode);
                                print(code?.flagUri);
                                print(
                                    'Country ---${code?.toCountryStringOnly()}');
                                if (code != null) {
                                  searchCubit
                                      .placeOfBirth(code.toCountryStringOnly());
                                }
                              },
                              // Whether to allow the widget to set a custom UI overlay
                              useUiOverlay: false,
                              // Whether the country list should be wrapped in a SafeArea
                              useSafeArea: true,
                            ),
                            onTap: () {},
                          ),
                          const SizedBox(height: 20.0),
                          const Text('Timezone'),
                          const SizedBox(height: 7.0),
                          TimeZoneField(
                            onChanged: searchCubit.timezoneChanged,
                            timezone: state.timezone,
                          ),
                          const SizedBox(height: 35.0),
                          SizedBox(
                            height: 42.0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffDC402B),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0))),
                              onPressed: () => _search(),
                              child: const Text('Search'),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          if (SharedPrefs().showLogin)
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xffDC402B),
                              ),
                              onPressed: () async {
                                await SharedPrefs().setSkipRegistration(true);
                                Navigator.of(context)
                                    .pushNamed(LoginScreen.routeName);
                              },
                              child: const Text('Skip, Sign In'),
                            ),
                          const SizedBox(height: 25.0),
                        ],
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
