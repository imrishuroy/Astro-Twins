import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '/blocs/auth/auth_bloc.dart';
import '/constants/constants.dart';
import '/enums/enums.dart';
import '/repositories/profile/profile_repository.dart';
import '/screens/profile/cubit/profile_cubit.dart';
import '/widgets/birth_fields.dart';
import '/widgets/choose_gender.dart';
import '/widgets/curved_container.dart';
import '/widgets/custom_textfield.dart';
import '/widgets/display_image.dart';
import '/widgets/loading_indicator.dart';
import '/widgets/show_snakbar.dart';
import '/widgets/succuss_dialog.dart';
import '/widgets/time_zone_field.dart';

class EditProfileScreen extends StatefulWidget {
  static const String routeName = '/editProfile';
  const EditProfileScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => BlocProvider(
        create: (context) => ProfileCubit(
          profileRepository: context.read<ProfileRepository>(),
          authBloc: context.read<AuthBloc>(),
        )..loadProfile(),
        child: const EditProfileScreen(),
      ),
    );
  }

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  void _submit(bool isSubmitting) async {
    print('aaa $isSubmitting');
    if (!isSubmitting) {
      if (_formKey.currentState!.validate()) {
        context.read<ProfileCubit>().editProfile();
      }
    }
  }

  @override
  void initState() {
    context.read<ProfileCubit>().getCurrentTimeZone();
    super.initState();
  }

  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dateFormat = DateFormat('dd MMMM yyyy');
    final profileCubit = context.read<ProfileCubit>();
    final localizations = MaterialLocalizations.of(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) async {
            if (state.status == ProfileStatus.error) {
              ShowSnackBar.showSnackBar(context, title: state.failure.message);
            }
            if (state.status == ProfileStatus.profileEdited) {
              await showDialog(
                context: context,
                builder: (_) => const SuccussDialog(),
              ).then((value) => Navigator.of(context).pop(true));
              // await showDialog(
              //   context: context,
              //   builder: (_) => const SuccussDialog(),
              // ).then((value) => Navigator.of(context)
              //     .pushReplacementNamed(AuthWrapper.routeName));

              //.pushNamedAndRemoveUntil('/', (route) => false));
            }
          },
          builder: (context, state) {
            if (state.status == ProfileStatus.loading) {
              return const LoadingIndicator(
                color: Contants.primaryColor,
              );
            }

            print('State of user --- ${state.user}');
            print('user name --- ${state.name}');

            if (state.name != null) {
              _nameController.text = state.name ?? '';
              _nameController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _nameController.text.length));
            }

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
                      const SizedBox(width: 36.0),
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
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.clear,
                          size: 18.0,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
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
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SizedBox(
                          height: size.height * 0.9,
                          child: Form(
                            key: _formKey,
                            child: ListView(
                              children: [
                                const SizedBox(height: 85.0),
                                const Text('Name'),
                                const SizedBox(height: 5.0),
                                TextFormField(
                                  decoration: InputDecoration(
                                    border: border,
                                    enabledBorder: border,
                                    focusedBorder: border,
                                    disabledBorder: border,
                                    contentPadding: const EdgeInsets.all(10),
                                  ),
                                  controller: _nameController,
                                  onChanged: (value) {
                                    profileCubit.nameChanged(value);
                                  },
                                  keyboardType: TextInputType.name,
                                ),
                                // const SizedBox(height: 20.0),
                                // CustomTextField(
                                //   initialValue: name,
                                //   onChanged: (value) =>
                                //       profileCubit.nameChanged(value),
                                //   hintText: 'Enter name',
                                //   validator: (value) {
                                //     // if (value!.length < 3) {
                                //     //   return 'Name too short';
                                //     // }
                                //     return null;
                                //   },
                                //   inputType: TextInputType.name,
                                // ),
                                const SizedBox(height: 20.0),
                                const Text('About'),
                                const SizedBox(height: 5.0),
                                CustomTextField(
                                  //maxLength: 150,
                                  //  maxLines: 2,
                                  initialValue: state.about,
                                  onChanged: profileCubit.aboutChanged,
                                  hintText: 'Enter about yourself',
                                  validator: (value) {
                                    // if (value!.length < 10) {
                                    //   return 'About too short';
                                    // }
                                    return null;
                                  },
                                  inputType: TextInputType.name,
                                ),
                                const SizedBox(height: 20.0),
                                const Text('Sex'),
                                const SizedBox(height: 5.0),
                                Row(
                                  children: [
                                    ChooseGender(
                                      imageUrl: 'assets/svgs/male.svg',
                                      label: 'Male',
                                      onTap: () =>
                                          profileCubit.sexChanged(Gender.male),
                                      isSelected: state.gender == Gender.male,
                                    ),
                                    const SizedBox(width: 40.0),
                                    ChooseGender(
                                      imageUrl: 'assets/svgs/female.svg',
                                      label: 'Female',
                                      onTap: () => profileCubit
                                          .sexChanged(Gender.female),
                                      isSelected: state.gender == Gender.female,
                                    ),
                                  ],
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
                                      profileCubit.dateOfBirthChanged(
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
                                      profileCubit
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
                                        context
                                            .read<ProfileCubit>()
                                            .placeOfBirth(
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
                                const Text('Timezone'),
                                const SizedBox(height: 7.0),
                                TimeZoneField(
                                  onChanged: profileCubit.timezoneChanged,
                                  timezone: state.timezone,
                                ),
                                const SizedBox(height: 32.0),
                                SizedBox(
                                  height: 42.0,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: const Color(0xffDC402B),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0))),
                                    onPressed: () => _submit(
                                        state.status == ProfileStatus.loading),
                                    child: const Text('Update Profile'),
                                  ),
                                ),
                                const SizedBox(height: 200.0),
                              ],
                            ),
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
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 64.5,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          backgroundColor: Contants.primaryColor,
                          radius: 62.0,
                          child: ClipOval(
                            child: state.pickedImage != null
                                ? Image.file(
                                    state.pickedImage!,
                                    fit: BoxFit.cover,
                                    height: 200.0,
                                    width: 200.0,
                                  )
                                : DisplayImage(
                                    imageUrl: state.user?.profileImg,
                                    width: 200.0,
                                    height: 200.0,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10.0,
                        right: 90.0,
                        // alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () => profileCubit.pickImage(context),
                          child: const CircleAvatar(
                            backgroundColor: Contants.primaryColor,
                            child: Icon(
                              Icons.camera_alt,
                              size: 24.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
            // } else {
            //   return const Center(
            //     child: CircularProgressIndicator(),
            //   );
            // }
          },
        ),
      ),
    );
  }
}

final border = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8.0),
  borderSide: BorderSide(color: Colors.grey.shade300, width: 1.8),
);
