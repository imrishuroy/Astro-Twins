import 'package:astro_twins/enums/enums.dart';
import 'package:astro_twins/widgets/choose_gender.dart';
import 'package:country_calling_code_picker/picker.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '/blocs/auth/auth_bloc.dart';
import '/constants/constants.dart';
import '/repositories/auth/auth_repo.dart';
import '/screens/login/login_screen.dart';
import '/screens/nav/nav_screen.dart';
import '/screens/registration/cubit/registration_cubit.dart';
import '/utils/utils.dart';
import '/widgets/birth_fields.dart';
import '/widgets/curved_container.dart';
import '/widgets/custom_textfield.dart';
import '/widgets/loading_indicator.dart';
import '/widgets/show_snakbar.dart';
import '/widgets/time_zone_field.dart';

class RegistrationScreen extends StatefulWidget {
  static const String routeName = '/registration';
  const RegistrationScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider(
        create: (context) => RegistrationCubit(
          authRepository: context.read<AuthRepository>(),
          authBloc: context.read<AuthBloc>(),
        ),
        child: const RegistrationScreen(),
      ),
    );
  }

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _submitForm(BuildContext context, bool isSubmitting) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate() && !isSubmitting) {
      context.read<RegistrationCubit>().registerUser();
      //  _formKey.currentState?.reset();
      // Navigator.of(context).pushReplacementNamed(NavScreen.routeName);
    }
  }

  bool isPasswordTyping = false;

  @override
  void initState() {
    context.read<RegistrationCubit>().intCountry(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //  print('Scroll position -- ${scrollController.position}');
    // // if (scrollController.hasClients) {
    //   print('Scroll position -- ${scrollController.position}');
    // }

    final _size = MediaQuery.of(context).size;
    final _registrationCubit = context.read<RegistrationCubit>();

    final dateFormat = DateFormat('dd MMMM yyyy');

    final localizations = MaterialLocalizations.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: BlocConsumer<RegistrationCubit, RegistrationState>(
          listener: (context, state) {
            if (state.status == RegistrationStatus.error) {
              ShowSnackBar.showSnackBar(
                context,
                title: state.failure.message,
                backgroundColor: Colors.red,
              );
            }

            // if (state.failure.code == 'mobile-no-error') {
            //   ShowSnackBar.showSnackBar(
            //     context,
            //     title: state.failure.message,
            //     backgroundColor: Colors.red,
            //   );
            // }

            if (state.status == RegistrationStatus.succuss) {
              ShowSnackBar.showSnackBar(
                context,
                title: 'Registration Successful',
                backgroundColor: Colors.green,
              );

              Navigator.of(context).pushReplacementNamed(NavScreen.routeName);
            }
          },
          builder: (context, state) {
            if (state.status == RegistrationStatus.submitting) {
              return const LoadingIndicator(
                color: Contants.primaryColor,
              );
            }
            return Form(
              key: _formKey,
              child: Stack(
                children: [
                  const CurvedContainer(),
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
                  const Positioned(
                    top: 140.0,
                    left: 10.0,
                    right: 10.0,
                    child: Card(
                      color: Color(0xffFAFAFA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 20.0,
                        ),
                        child: Center(
                          child: Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 180.0,
                    left: 10.0,
                    right: 10.0,
                    child: Card(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(8.0),
                          bottomRight: Radius.circular(8.0),
                        ),
                      ),
                      color: const Color(0xffFAFAFA),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SizedBox(
                          height: _size.height * 0.8,
                          child: ListView(
                            //  controller: scrollController,
                            children: [
                              const SizedBox(height: 25.0),
                              const Text('Name'),
                              const SizedBox(height: 5.0),
                              CustomTextField(
                                initialValue: state.name,
                                onChanged: _registrationCubit.nameChanged,
                                hintText: 'Enter name',
                                validator: (value) {
                                  if (value!.length < 3) {
                                    return 'Name too short';
                                  }
                                  return null;
                                },
                                inputType: TextInputType.name,
                              ),
                              const SizedBox(height: 20.0),
                              const Text('Email'),
                              const SizedBox(height: 5.0),
                              CustomTextField(
                                initialValue: state.email,
                                onChanged: _registrationCubit.emailChanged,
                                hintText: 'Enter email',
                                validator: (value) {
                                  bool emailValid = RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value!);

                                  if (emailValid) {
                                    return null;
                                  }
                                  return 'Invalid Email';
                                },
                                inputType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 20.0),
                              const Text('Mobile Number'),
                              const SizedBox(height: 5.0),
                              Container(
                                height: 50.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  border: Border.all(
                                      color: Colors.grey.shade300, width: 1.8),
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(width: 10.0),
                                    GestureDetector(
                                      onTap: () => context
                                          .read<RegistrationCubit>()
                                          .pickCountryCode(context),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            state.country?.flag ?? '',
                                            package: countryCodePackageName,
                                            height: 40.0,
                                            width: 35.0,
                                          ),
                                          const SizedBox(width: 5.0),
                                          const Icon(
                                            Icons.expand_more,
                                            size: 20.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 5.0),
                                    Container(
                                      height: 35.0,
                                      width: 1.2,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(width: 12.0),
                                    Expanded(
                                      child: TextFormField(
                                        initialValue: state.mobileNumber,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        onChanged: context
                                            .read<RegistrationCubit>()
                                            .mobileNumberChanged,
                                        validator: (value) {
                                          if (value != null) {
                                            if (value.isEmpty) {
                                              return 'Invalid Mobile Number';
                                            }
                                          }
                                          return null;
                                        },
                                        decoration:
                                            const InputDecoration.collapsed(
                                          hintText: '8540928489',
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              const Text('Password'),
                              const SizedBox(height: 5.0),
                              CustomTextField(
                                initialValue: state.password,
                                maxLines: 1,
                                suffixIcon: IconButton(
                                  color: Colors.grey.shade400,
                                  icon: Icon(
                                    state.showPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () => context
                                      .read<RegistrationCubit>()
                                      .showPassword(state.showPassword),
                                ),
                                onChanged: context
                                    .read<RegistrationCubit>()
                                    .passwordChanged,
                                hintText: 'Password',
                                validator: (value) {
                                  return PasswordUtil.checkPassword(value!);
                                },
                                inputType: TextInputType.visiblePassword,
                                isPassowrdField: !state.showPassword,
                              ),
                              const SizedBox(height: 20.0),
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
                                    _registrationCubit.dateOfBirthChanged(
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
                                    _registrationCubit
                                        .timeOfBirthChanged(pickedTime);
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
                                    iconTheme: const IconThemeData(
                                        color: Colors.black),
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
                                  ),

                                  onChanged: (CountryCode? code) {
                                    print(code?.name);
                                    print(code?.code);
                                    print(code?.dialCode);
                                    print(code?.flagUri);
                                    print(
                                        'Country ---${code?.toCountryStringOnly()}');
                                    if (code != null) {
                                      _registrationCubit.placeOfBirth(
                                          code.toCountryStringOnly());
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
                              const Text('Place of Birth'),
                              const SizedBox(height: 7.0),
                              //// time zone
                              TimeZoneField(
                                onChanged: _registrationCubit.timezoneChanged,
                                timezone: state.timezone,
                              ),
                              const SizedBox(height: 20.0),

                              const Text('Sex'),
                              const SizedBox(height: 5.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ChooseGender(
                                    imageUrl: 'assets/svgs/male.svg',
                                    label: 'Male',
                                    onTap: () => _registrationCubit
                                        .sexChanged(Gender.male),
                                    isSelected: state.gender == Gender.male,
                                  ),
                                  const SizedBox(width: 40.0),
                                  ChooseGender(
                                      imageUrl: 'assets/svgs/female.svg',
                                      label: 'Female',
                                      onTap: () => _registrationCubit
                                          .sexChanged(Gender.female),
                                      isSelected: state.gender == Gender.female
                                      // onTap: () => profileCubit
                                      //     .sexChanged(Gender.female),
                                      // isSelected: state.gender == Gender.female,
                                      ),
                                ],
                              ),
                              const SizedBox(height: 20.0),
                              const SizedBox(height: 35.0),
                              SizedBox(
                                height: 42.0,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: const Color(0xffDC402B),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0))),
                                  onPressed: () => _submitForm(
                                      context,
                                      state.status ==
                                          RegistrationStatus.submitting),
                                  child: const Text('Register'),
                                ),
                              ),
                              const SizedBox(height: 6.0),
                              TextButton(
                                onPressed: () => Navigator.of(context)
                                    .pushNamed(LoginScreen.routeName),
                                child: const Text(
                                  'Have an Account, Sign In',
                                  style: TextStyle(
                                    color: Color(0xffDC402B),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 100.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
