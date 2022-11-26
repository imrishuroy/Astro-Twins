part of 'profile_cubit.dart';

enum ProfileStatus { initial, loading, success, error, profileEdited }

class ProfileState extends Equatable {
  final AppUser? user;
  final ProfileStatus status;
  final Failure failure;
  final String? name;
  final String? email;
  final String? mobileNumber;
  final Gender gender;
  final String? birthDate;
  final TimeOfDay? birthTime;
  final String? birthPlace;
  final String? timezone;
  final String? astro;
  final String? about;
  final File? pickedImage;
  final int profileCompleteCount;

  const ProfileState({
    required this.user,
    required this.status,
    required this.failure,
    this.mobileNumber,
    this.name,
    this.email,
    required this.gender,
    this.birthDate,
    this.birthTime,
    this.birthPlace,
    this.astro,
    this.pickedImage,
    this.about,
    this.timezone,
    this.profileCompleteCount = 0,
  });

  factory ProfileState.initial() => const ProfileState(
        status: ProfileStatus.initial,
        user: null,
        failure: Failure(),
        gender: Gender.male,
        profileCompleteCount: 0,
      );

  @override
  List<Object?> get props {
    return [
      user,
      status,
      failure,
      name,
      email,
      gender,
      birthDate,
      birthTime,
      birthPlace,
      astro,
      pickedImage,
      about,
      profileCompleteCount,
      mobileNumber,
      timezone,
    ];
  }

  ProfileState copyWith({
    AppUser? user,
    ProfileStatus? status,
    Failure? failure,
    String? name,
    String? email,
    Gender? gender,
    String? birthDate,
    TimeOfDay? birthTime,
    String? birthPlace,
    String? astro,
    File? pickedImage,
    String? about,
    int? profileCompleteCount,
    String? mobileNumber,
    String? timezone,
  }) {
    return ProfileState(
      user: user ?? this.user,
      status: status ?? this.status,
      failure: failure ?? this.failure,
      name: name ?? this.name,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      birthTime: birthTime ?? this.birthTime,
      birthPlace: birthPlace ?? this.birthPlace,
      astro: astro ?? this.astro,
      pickedImage: pickedImage ?? this.pickedImage,
      about: about ?? this.about,
      profileCompleteCount: profileCompleteCount ?? this.profileCompleteCount,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      timezone: timezone ?? this.timezone,
    );
  }

  @override
  String toString() {
    return 'ProfileState(user: $user, status: $status, failure: $failure, name: $name, email: $email, gender: $gender, dateOfBirth: $birthDate, timeOfDay: $birthTime, birthPlace: $birthPlace, astro: $astro, pickedImage: $pickedImage, about: $about, profileCompleteCount: $profileCompleteCount, mobileNumber: $mobileNumber, timezone: $timezone)';
  }
}
