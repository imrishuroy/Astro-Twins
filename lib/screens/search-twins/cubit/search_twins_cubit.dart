import '/constants/constants.dart';
import '/models/birth_details.dart';
import '/config/shared_prefs.dart';
import '/blocs/auth/auth_bloc.dart';
import '/models/failure.dart';
import '/repositories/twins/twins_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
part 'search_twins_state.dart';

class SearchTwinsCubit extends Cubit<SearchTwinsState> {
  final AuthBloc _authBloc;
  final TwinsRepository _twinsRepository;

  SearchTwinsCubit({
    required AuthBloc authBloc,
    required TwinsRepository twinsRepository,
  })  : _authBloc = authBloc,
        _twinsRepository = twinsRepository,
        super(SearchTwinsState.initial());

  void dateOfBirthChanged(String dateTime) {
    emit(
        state.copyWith(birthDate: dateTime, status: SearchTwinsStatus.initial));
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
      emit(
          state.copyWith(timezone: list[0], status: SearchTwinsStatus.initial));
    } else {
      emit(state.copyWith(
          timezone: timeZones[0], status: SearchTwinsStatus.initial));
    }
  }

  void timeOfBirthChanged(TimeOfDay timeOfDay) {
    emit(state.copyWith(
        birthTime: timeOfDay, status: SearchTwinsStatus.initial));
  }

  void placeOfBirth(String place) {
    emit(state.copyWith(birthPlace: place, status: SearchTwinsStatus.initial));
  }

  void timezoneChanged(String? timezone) {
    emit(state.copyWith(timezone: timezone, status: SearchTwinsStatus.initial));
  }

  void search() async {
    try {
      emit(state.copyWith(status: SearchTwinsStatus.loading));
      if (_authBloc.state.user == null) {
        // saving details to local storage
        await SharedPrefs().setBirthDetails(
          BirthDetails(
            birthDate: state.birthDate,
            birthPlace: state.birthPlace,
            birthTime: state.birthTime,
            timezone: state.timezone,
          ),

          //   {
          //   'birthDate': state.birthDate.toString(),
          //   'birthPlace': state.birthPlace,
          //   'birthTime': state.birthTime.toString(),

          // }
        );
      } else {
        await _twinsRepository.addUserBirthDetails(
          user: _authBloc.state.user?.copyWith(
            birthDate: state.birthDate,
            birthTime: state.birthTime,
            birthPlace: state.birthPlace,
            timezone: state.timezone,
          ),
        );
      }

      emit(state.copyWith(status: SearchTwinsStatus.succuss));
    } on Failure catch (failure) {
      emit(state.copyWith(status: SearchTwinsStatus.error, failure: failure));
    }
  }
}
