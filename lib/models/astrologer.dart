import 'dart:convert';

import 'package:equatable/equatable.dart';

class Astrologer extends Equatable {
  final String? astroId;
  final String? name;
  final String? email;
  final String? about;
  final String? mobileNumber;
  final String? profileImg;
  final String? address;

  const Astrologer({
    this.astroId,
    this.name,
    this.email,
    this.about,
    this.mobileNumber,
    this.profileImg,
    this.address,
  });

  Astrologer copyWith({
    String? astroId,
    String? name,
    String? email,
    String? about,
    String? mobileNumber,
    String? profileImg,
    String? address,
  }) {
    return Astrologer(
      astroId: astroId ?? this.astroId,
      name: name ?? this.name,
      email: email ?? this.email,
      about: about ?? this.about,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      profileImg: profileImg ?? this.profileImg,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'astroId': astroId,
      'name': name,
      'email': email,
      'about': about,
      'mobileNumber': mobileNumber,
      'profileImg': profileImg,
      'address': address,
    };
  }

  factory Astrologer.fromMap(Map<String, dynamic> map) {
    return Astrologer(
      astroId: map['astroId'],
      name: map['name'],
      email: map['email'],
      about: map['about'],
      mobileNumber: map['mobileNumber'],
      profileImg: map['profileImg'],
      address: map['address'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Astrologer.fromJson(String source) =>
      Astrologer.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Astrologer(astroId: $astroId, name: $name, email: $email, about: $about, mobileNumber: $mobileNumber, profileImg: $profileImg, address: $address)';
  }

  @override
  List<Object?> get props {
    return [
      astroId,
      name,
      email,
      about,
      mobileNumber,
      profileImg,
      address,
    ];
  }
}
