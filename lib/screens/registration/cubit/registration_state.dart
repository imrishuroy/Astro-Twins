part of 'registration_cubit.dart';

enum RegistrationStatus {
  initial,
  submitting,
  succuss,
  error,
}

class RegistrationState extends Equatable {
  final String name;
  final String email;
  final String mobileNumber;
  final String password;
  final Failure failure;
  final bool showPassword;
  final String countryCode;
  final Country? country;
  final String? birthDate;
  final TimeOfDay? birthTime;
  final String? birthPlace;
  final String? timezone;
  final Gender gender;
  final RegistrationStatus status;

  const RegistrationState({
    required this.name,
    required this.email,
    required this.mobileNumber,
    required this.password,
    required this.failure,
    required this.showPassword,
    required this.status,
    required this.countryCode,
    required this.country,
    required this.birthDate,
    required this.birthTime,
    required this.birthPlace,
    required this.timezone,
    required this.gender,
  });

  factory RegistrationState.initial() => RegistrationState(
        name: '',
        email: '',
        mobileNumber: '',
        password: '',
        failure: const Failure(),
        showPassword: false,
        status: RegistrationStatus.initial,
        countryCode: '+91',
        country: null,
        birthDate: SharedPrefs().birthDetails?.birthDate,
        birthTime: SharedPrefs().birthDetails?.birthTime,
        birthPlace: SharedPrefs().birthDetails?.birthPlace,
        timezone: SharedPrefs().birthDetails?.timezone,
        gender: Gender.male,
      );

  bool get isFormValid =>
      email.isNotEmpty &&
      password.isNotEmpty &&
      name.isNotEmpty &&
      mobileNumber.isNotEmpty &&
      countryCode.isNotEmpty;
  // birthDate != null &&
  // birthTime != null &&
  // birthPlace != null;

  @override
  List<Object?> get props {
    return [
      name,
      email,
      mobileNumber,
      countryCode,
      password,
      failure,
      showPassword,
      status,
      country,
      birthDate,
      birthTime,
      birthPlace,
      timezone,
      gender,
    ];
  }

  RegistrationState copyWith({
    String? name,
    String? email,
    String? mobileNumber,
    String? password,
    Failure? failure,
    bool? showPassword,
    String? countryCode,
    Country? country,
    String? birthDate,
    TimeOfDay? birthTime,
    String? birthPlace,
    RegistrationStatus? status,
    String? timezone,
    Gender? gender,
  }) {
    return RegistrationState(
      name: name ?? this.name,
      email: email ?? this.email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      password: password ?? this.password,
      failure: failure ?? this.failure,
      showPassword: showPassword ?? this.showPassword,
      countryCode: countryCode ?? this.countryCode,
      country: country ?? this.country,
      birthDate: birthDate ?? this.birthDate,
      birthTime: birthTime ?? this.birthTime,
      birthPlace: birthPlace ?? this.birthPlace,
      status: status ?? this.status,
      timezone: timezone ?? this.timezone,
      gender: gender ?? this.gender,
    );
  }
}
