import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_calling_code_picker/picker.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '/blocs/auth/auth_bloc.dart';
import '/config/paths.dart';
import '/config/shared_prefs.dart';
import '/constants/constants.dart';
import '/enums/enums.dart';
import '/models/failure.dart';
import '/repositories/auth/auth_repo.dart';

part 'registration_state.dart';

class RegistrationCubit extends Cubit<RegistrationState> {
  final AuthRepository _authRepository;
  final AuthBloc _authBloc;
  RegistrationCubit({
    required AuthRepository authRepository,
    required AuthBloc authBloc,
  })  : _authRepository = authRepository,
        _authBloc = authBloc,
        super(RegistrationState.initial());

  final _userCollectionRef = FirebaseFirestore.instance.collection(Paths.users);

  void nameChanged(String name) {
    emit(state.copyWith(name: name, status: RegistrationStatus.initial));
  }

  void emailChanged(String email) {
    emit(state.copyWith(email: email, status: RegistrationStatus.initial));
  }

  void showPassword(bool showPassword) {
    emit(state.copyWith(
        showPassword: !showPassword, status: RegistrationStatus.initial));
  }

  void countryCodeChanged({required String code}) {
    emit(state.copyWith(countryCode: code, status: RegistrationStatus.initial));
  }

  void mobileNumberChanged(String mobileNumber) {
    emit(state.copyWith(
        mobileNumber: mobileNumber, status: RegistrationStatus.initial));
  }

  void sexChanged(Gender gender) async {
    emit(state.copyWith(gender: gender, status: RegistrationStatus.initial));
  }

  void dateOfBirthChanged(String dateTime) {
    emit(state.copyWith(
        birthDate: dateTime, status: RegistrationStatus.initial));
  }

  void timeOfBirthChanged(TimeOfDay timeOfDay) {
    emit(state.copyWith(
        birthTime: timeOfDay, status: RegistrationStatus.initial));
  }

  void placeOfBirth(String place) {
    emit(state.copyWith(birthPlace: place, status: RegistrationStatus.initial));
  }

  void intCountry(BuildContext context) async {
    emit(state.copyWith(status: RegistrationStatus.submitting));

    DateTime dateTime = DateTime.now();
    final currentTimeZone = dateTime.timeZoneName;
    String? timezone;

    final list = timeZones
        .where((element) => element.contains(currentTimeZone))
        .toList();

    print('time zone list $list');
    if (list.isNotEmpty) {
      timezone = list[0];
    } else {
      timezone = timeZones[0];
    }

    final country = await getDefaultCountry(context);
    emit(
      state.copyWith(
        country: country,
        timezone: timezone,
        status: RegistrationStatus.initial,
      ),
    );
  }

  void pickCountryCode(BuildContext context) async {
    final country = await showCountryPickerSheet(context);
    if (country != null) {
      emit(
        state.copyWith(
            country: country,
            countryCode: country.callingCode,
            status: RegistrationStatus.initial
            // mobileNumber: state.mobileNumber.isEmpty ? country.callingCode : '',
            ),
      );
    }
  }

  void passwordChanged(String password) {
    emit(
        state.copyWith(password: password, status: RegistrationStatus.initial));
  }

  void timezoneChanged(String? timezone) {
    emit(
        state.copyWith(timezone: timezone, status: RegistrationStatus.initial));
  }

  void registerUser() async {
    try {
      print('AuthBloc - $_authBloc');
      emit(state.copyWith(status: RegistrationStatus.submitting));

      if (state.birthDate == null ||
          state.birthTime == null ||
          state.birthPlace == null) {
        emit(
          state.copyWith(
            failure:
                const Failure(message: 'Please add birth details to continue'),
            status: RegistrationStatus.error,
          ),
        );
      } else {
        final _userSnaps = await _userCollectionRef
            .where('mobileNumber',
                isEqualTo: '${state.countryCode}${state.mobileNumber}')
            .get();

        print('User lenght ------ ${_userSnaps.docs.length}');

        if (_userSnaps.docs.isNotEmpty) {
          print('Email state - ${state.email}');
          emit(
            state.copyWith(
                failure: const Failure(
                    code: 'mobile-no-error',
                    message:
                        'Mobile number already exists, please try a different one.'),
                status: RegistrationStatus.error,
                mobileNumber: ''),
          );
          return;
        }

        final appUser = await _authRepository.signUpWithEmailAndPassword(
          email: state.email,
          password: state.password,
        );

        print('App User - $appUser');
        //final sharedPrefs = SharedPrefs();

        if (appUser != null) {
          final user = appUser.copyWith(
            name: state.name,
            mobileNumber: '${state.countryCode}${state.mobileNumber}',
            birthDate: state.birthDate,
            timezone: state.timezone,
            birthPlace: state.birthPlace,
            birthTime: state.birthTime,
            sex: EnumToString.convertToString(state.gender),
          );

          print('User -- $user');
          await _userCollectionRef.doc(user.userId).set(user.toMap());

          _authBloc.add(AuthUserChanged(user: user));
          emit(state.copyWith(status: RegistrationStatus.succuss));
        }
      }
    } on Failure catch (failure) {
      emit(state.copyWith(failure: failure, status: RegistrationStatus.error));
    }
  }

  @override
  String toString() =>
      'RegistrationCubit(_authRepository: $_authRepository, _authBloc: $_authBloc)';
}
