import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

import '/blocs/auth/auth_bloc.dart';
import '/constants/constants.dart';
import '/enums/enums.dart';
import '/models/app_user.dart';
import '/models/failure.dart';
import '/repositories/profile/profile_repository.dart';
import '/utils/media_util.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository;
  final AuthBloc _authBloc;
  ProfileCubit({
    required ProfileRepository profileRepository,
    required AuthBloc authBloc,
  })  : _profileRepository = profileRepository,
        _authBloc = authBloc,
        super(ProfileState.initial());

  void loadProfile({bool editProfile = false}) async {
    try {
      emit(state.copyWith(status: ProfileStatus.loading));
      final user = await _profileRepository.getUserProfile(
          userId: _authBloc.state.user?.userId);

      int count = getProfileCompleteCount(user);

      emit(
        state.copyWith(
          name: user?.name,
          user: user,
          gender: user?.sex != null
              ? EnumToString.fromString(Gender.values, user!.sex!)
              : null,

          email: user?.email,
          birthDate: user?.birthDate,
          birthPlace: user?.birthPlace,
          birthTime: user?.birthTime,
          //astro: user?.astro,
          about: user?.about,
          profileCompleteCount: count,
          // status: ProfileStatus.success,
        ),
      );

      if (editProfile) {
        _authBloc.add(AuthUserChanged(user: user));
      }
      emit(state.copyWith(status: ProfileStatus.success));
    } on Failure catch (failure) {
      emit(state.copyWith(failure: failure, status: ProfileStatus.error));
    }
  }

  int getProfileCompleteCount(AppUser? user) {
    int count = 1;

    if (user?.name != null) {
      count += 1;
    }

    if (user?.about != null) {
      count += 1;
    }

    if (user?.birthDate != null) {
      count += 1;
    }

    if (user?.birthPlace != null) {
      count += 1;
    }
    if (user?.birthTime != null) {
      count += 1;
    }
    if (user?.email != null) {
      count += 1;
    }

    if (user?.mobileNumber != null) {
      count += 1;
    }
    if (user?.profileImg != null) {
      count += 1;
    }
    //for gender

    if (user?.sex != null) {
      count += 1;
    }
    return count;

    //emit(state.copyWith(profileCompleteCount: count));
  }

  void nameChanged(String value) {
    emit(state.copyWith(name: value, status: ProfileStatus.initial));
  }

  void aboutChanged(String value) {
    emit(state.copyWith(about: value, status: ProfileStatus.initial));
  }

  void sexChanged(Gender gender) async {
    emit(state.copyWith(gender: gender, status: ProfileStatus.initial));
  }

  void astroChange(String value) {
    emit(state.copyWith(astro: value, status: ProfileStatus.initial));
  }

  void dateOfBirthChanged(String dateTime) {
    emit(state.copyWith(birthDate: dateTime, status: ProfileStatus.initial));
  }

  void timeOfBirthChanged(TimeOfDay timeOfDay) {
    emit(state.copyWith(birthTime: timeOfDay, status: ProfileStatus.initial));
  }

  void placeOfBirth(String place) {
    emit(state.copyWith(birthPlace: place, status: ProfileStatus.initial));
  }

  void timezoneChanged(String? timezone) {
    emit(state.copyWith(timezone: timezone, status: ProfileStatus.initial));
  }

  void getCurrentTimeZone() async {
    DateTime dateTime = DateTime.now();
    final currentTimeZone = dateTime.timeZoneName;

    print('Current time zone ${dateTime.timeZoneName}');

    final list = timeZones
        .where((element) => element.contains(currentTimeZone))
        .toList();

    print('time zone list $list');
    if (list.isNotEmpty) {
      emit(state.copyWith(timezone: list[0], status: ProfileStatus.initial));
    } else {
      emit(state.copyWith(
          timezone: timeZones[0], status: ProfileStatus.initial));
    }
  }

  void pickImage(BuildContext context) async {
    final pickedFile = await MediaUtil.pickImageFromGallery(
      cropStyle: CropStyle.circle,
      context: context,
      title: 'Select Profile Image',
      imageQuality: 70,
    );
    if (pickedFile != null) {
      emit(state.copyWith(pickedImage: pickedFile));
    }
  }

  void editProfile() async {
    try {
      emit(state.copyWith(status: ProfileStatus.loading));

      final downloadUrl = state.pickedImage != null
          ? await MediaUtil.uploadProfileImageToStorage(
              'profile',
              state.pickedImage!.readAsBytesSync(),
              false,
              _authBloc.state.user?.userId ?? '123')
          : state.user?.profileImg;
      final user = _authBloc.state.user?.copyWith(
        name: state.name,
        email: state.email,
        sex: EnumToString.convertToString(state.gender),
        birthDate: state.birthDate,
        birthPlace: state.birthPlace,
        birthTime: state.birthTime,
        profileImg: downloadUrl ?? '',
        // astro: state.astro,
        about: state.about,
        timezone: state.timezone,
      );
      await _profileRepository.editProfile(user: user);
      emit(state.copyWith(status: ProfileStatus.profileEdited));
    } on Failure catch (failure) {
      emit(state.copyWith(failure: failure, status: ProfileStatus.error));
    }
  }
}
