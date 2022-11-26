import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class BirthDetails extends Equatable {
  final String? birthDate;
  final TimeOfDay? birthTime;
  final String? birthPlace;
  final String? timezone;

  const BirthDetails({
    this.birthDate,
    this.birthTime,
    this.birthPlace,
    this.timezone,
  });

  BirthDetails copyWith(
      {String? birthDate,
      TimeOfDay? birthTime,
      String? birthPlace,
      String? timezone}) {
    return BirthDetails(
      birthDate: birthDate ?? this.birthDate,
      birthTime: birthTime ?? this.birthTime,
      birthPlace: birthPlace ?? this.birthPlace,
      timezone: timezone ?? this.timezone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'birthDate': birthDate.toString(),

      // (birthDate != null ? Timestamp.fromDate(birthDate!) : null)
      //     .toString(),
      'birthPlace': birthPlace,
      'birthTime':
          birthTime != null ? '${birthTime?.hour}:${birthTime?.minute}' : null,
      'timezone': timezone,
    };
  }

  static BirthDetails? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    TimeOfDay? timeOfBirth;

    print('Time of day --- ${map['birthTime'].runtimeType}');

    final stringTime = map['birthTime'] as String?;

    if (stringTime != null && stringTime.contains(':')) {
      final listTime = stringTime.split(':');

      if (listTime.length == 2) {
        timeOfBirth = TimeOfDay(
          hour: int.tryParse(listTime[0]) ?? 0,
          minute: int.tryParse(listTime[1]) ?? 0,
        );
      }
    }

    return BirthDetails(
        birthDate: map['birthDate'],

        //  map['birthDate'] != null
        //     ? (map['birthDate'] as Timestamp).toDate()
        //     : null,
        birthTime: timeOfBirth,
        birthPlace: map['birthPlace'],
        timezone: map['timezone']);
  }

  @override
  String toString() =>
      'BirthDetails(birthDate: $birthDate, birthTime: $birthTime, birthPlace: $birthPlace, timezone: $timezone)';

  @override
  List<Object?> get props => [birthDate, birthTime, birthPlace, timezone];
}
