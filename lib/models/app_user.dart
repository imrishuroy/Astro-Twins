import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppUser extends Equatable {
  final String? userId;
  final String? name;
  final String? email;
  final String? mobileNumber;
  final String? profileImg;
  final String? about;
  //final BirthDetails? birthDetails;
  // final DateTime? birthDate;
  final String? birthDate;
  final TimeOfDay? birthTime;
  final String? birthPlace;
  final String? sex;
  final String? timezone;

  const AppUser({
    this.userId,
    this.name,
    this.email,
    this.mobileNumber,
    this.profileImg,
    this.about,
    //this.birthDetails,

    this.sex,
    this.birthDate,
    this.birthTime,
    this.birthPlace,
    this.timezone,
  });

  AppUser copyWith({
    String? userId,
    String? name,
    String? email,
    String? mobileNumber,
    String? profileImg,
    String? about,
    String? sex,
    String? birthDate,
    TimeOfDay? birthTime,
    String? birthPlace,
    String? timezone,
  }) {
    return AppUser(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      profileImg: profileImg ?? this.profileImg,
      about: about ?? this.about,
      // birthDetails: birthDetails ?? this.birthDetails,

      sex: sex ?? this.sex,
      birthDate: birthDate ?? this.birthDate,
      birthTime: birthTime ?? this.birthTime,
      birthPlace: birthPlace ?? this.birthPlace,
      timezone: timezone ?? this.timezone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'mobileNumber': mobileNumber,
      'profileImg': profileImg,
      'about': about,
      // 'birthDetails': birthDetails?.toMap(),

      'sex': sex,
      'birthDate': birthDate,

      // birthDate != null ? Timestamp.fromDate(birthDate!) : null,
      'birthPlace': birthPlace,
      'birthTime':
          birthTime != null ? '${birthTime?.hour}:${birthTime?.minute}' : null,
      'timezone': timezone,
    };
  }

  // factory AppUser.fromMap(Map<String, dynamic> map) {
  //   return AppUser(
  //     userId: map['userId'],
  //     name: map['name'],
  //     email: map['email'],
  //     mobileNumber: map['mobileNumber'],
  //     profileImg: map['profileImg'],
  //     about: map['about'],
  //     // birthDetails: map['birthDetails'] != null
  //     //     ? BirthDetails.fromMap(map['birthDetails'])
  //     //     : null,
  //     astro: map['astro'],
  //     sex: map['sex'],
  //   );
  // }

  static AppUser? fromDocument(DocumentSnapshot? doc) {
    final data = doc?.data() as Map?;
    if (data != null) {
      TimeOfDay? timeOfBirth;

      print('Time of day --- ${data['birthTime'].runtimeType}');

      final stringTime = data['birthTime'] as String?;

      if (stringTime != null && stringTime.contains(':')) {
        final listTime = stringTime.split(':');

        if (listTime.length == 2) {
          timeOfBirth = TimeOfDay(
            hour: int.tryParse(listTime[0]) ?? 0,
            minute: int.tryParse(listTime[1]) ?? 0,
          );
        }
      }

      return AppUser(
          userId: data['userId'],
          name: data['name'],
          email: data['email'],
          mobileNumber: data['mobileNumber'],
          profileImg: data['profileImg'],
          about: data['about'],
          // birthDetails: data['birthDetails'] != null
          //     ? BirthDetails.fromMap(data['birthDetails'])
          // : null,
          // birthDate: data['birthDate'] != null
          //     ? (data['birthDate'] as Timestamp).toDate()
          //     : null,
          birthDate: data['birthDate'],
          birthTime: timeOfBirth,
          birthPlace: data['birthPlace'],
          sex: data['sex'],
          timezone: data['timezone']);
    }
    return null;
  }

  //String toJson() => json.encode(toMap());

  // factory AppUser.fromJson(String source) =>
  //     AppUser.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AppUser(userId: $userId, name: $name, email: $email, mobileNumber: $mobileNumber, profileImg: $profileImg, about: $about, birthDate: $birthDate, birthTime: $birthTime, birthPlace: $birthPlace, sex: $sex, timezone: $timezone)';
  }

  @override
  List<Object?> get props {
    return [
      userId,
      name,
      email,
      mobileNumber,
      profileImg,
      about,
      // birthDetails,

      sex,
      birthDate, birthTime, birthPlace,
      timezone,
    ];
  }
}






// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';

// class AppUser extends Equatable {
  // final String? userId;
  // final String? name;
  // final String? email;
  // final String? mobileNumber;
  // final String? profileImg;
  // final String? about;
  // final DateTime? dob;
  // final String? birthPlace;
  // final TimeOfDay? timeOfDay;
  // final String? astro;
  // final String? sex;

//   const AppUser({
//     this.userId,
//     this.name,
//     this.email,
//     this.mobileNumber,
//     this.profileImg,
//     this.about,
//     this.dob,
//     this.birthPlace,
//     this.timeOfDay,
//     this.astro,
//     this.sex,
//   });

//   AppUser copyWith({
//     String? userId,
//     String? name,
//     String? email,
//     String? mobileNumber,
//     String? profileImg,
//     String? about,
//     DateTime? dob,
//     String? birthPlace,
//     TimeOfDay? timeOfDay,
//     String? astro,
//     String? sex,
//   }) {
//     return AppUser(
//       userId: userId ?? this.userId,
//       name: name ?? this.name,
//       email: email ?? this.email,
//       mobileNumber: mobileNumber ?? this.mobileNumber,
//       profileImg: profileImg ?? this.profileImg,
//       about: about ?? this.about,
//       dob: dob ?? this.dob,
//       birthPlace: birthPlace ?? this.birthPlace,
//       timeOfDay: timeOfDay ?? this.timeOfDay,
//       astro: astro ?? this.astro,
//       sex: sex ?? this.sex,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'userId': userId,
//       'name': name,
//       'email': email,
//       'mobileNumber': mobileNumber,
//       'profileImg': profileImg,
//       'about': about,
//       'dob': dob != null ? Timestamp.fromDate(dob!) : null,
//       'birthPlace': birthPlace,
//       'timeOfDay':
//           timeOfDay != null ? '${timeOfDay?.hour}:${timeOfDay?.minute}' : null,
//       'astro': astro,
//       'sex': sex,
//     };
//   }

//   static AppUser? fromDocument(DocumentSnapshot snap) {
//     final data = snap.data() as Map?;

//     TimeOfDay? timeOfBirth;

//     print('Time of day --- ${data?['timeOfDay'].runtimeType}');

//     if (data != null) {
//       final stringTime = data['timeOfDay'] as String?;

//       if (stringTime != null && stringTime.contains(':')) {
//         final listTime = stringTime.split(':');

//         if (listTime.length == 2) {
//           timeOfBirth = TimeOfDay(
//             hour: int.tryParse(listTime[0]) ?? 0,
//             minute: int.tryParse(listTime[1]) ?? 0,
//           );
//         }
//       }

//       return AppUser(
//         userId: data['userId'],
//         name: data['name'],
//         email: data['email'],
//         mobileNumber: data['mobileNumber'],
//         profileImg: data['profileImg'],
//         about: data['about'],
//         dob: data['dob'] != null ? (data['dob'] as Timestamp).toDate() : null,
//         birthPlace: data['birthPlace'],
//         timeOfDay: timeOfBirth,
//         //  data['timeOfDay'] != null ? jsonDecode(data['timeOfDay']) : null,
//         astro: data['astro'],
//         sex: data['sex'],
//       );
//     }
//     return null;
//   }

//   factory AppUser.fromMap(Map<String, dynamic> map) {
//     return AppUser(
//       userId: map['userId'],
//       name: map['name'],
//       email: map['email'],
//       mobileNumber: map['mobileNumber'],
//       profileImg: map['profileImg'],
//       about: map['about'],
//       dob: map['dob'] != null
//           ? DateTime.fromMillisecondsSinceEpoch(map['dob'])
//           : null,
//       birthPlace: map['birthPlace'],
//       timeOfDay: map['timeOfDay'] != null ? jsonDecode(map['timeOfDay']) : null,
//       astro: map['astro'],
//       sex: map['sex'],
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory AppUser.fromJson(String source) =>
//       AppUser.fromMap(json.decode(source));

//   @override
//   String toString() {
//     return 'AppUser(userId: $userId, name: $name, email: $email, mobileNumber: $mobileNumber, profileImg: $profileImg, about: $about, dob: $dob, birthPlace: $birthPlace, timeOfDay: $timeOfDay, astro: $astro, sex: $sex)';
//   }

//   @override
//   List<Object?> get props {
//     return [
//       userId,
//       name,
//       email,
//       mobileNumber,
//       profileImg,
//       about,
//       dob,
//       birthPlace,
//       timeOfDay,
//       astro,
//       sex,
//     ];
//   }
// }
