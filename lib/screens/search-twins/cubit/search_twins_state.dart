part of 'search_twins_cubit.dart';

enum SearchTwinsStatus { initial, loading, succuss, error }

class SearchTwinsState extends Equatable {
  final String? birthDate;
  final TimeOfDay? birthTime;
  final String? birthPlace;
  final String? timezone;
  final SearchTwinsStatus status;
  final Failure failure;

  const SearchTwinsState({
    this.birthDate,
    this.birthTime,
    this.birthPlace,
    this.timezone,
    required this.status,
    required this.failure,
  });

  factory SearchTwinsState.initial() => const SearchTwinsState(
        status: SearchTwinsStatus.initial,
        failure: Failure(),
      );

  bool get formValid =>
      birthPlace != null ||
      birthTime != null ||
      birthDate != null ||
      timezone != null;

  @override
  List<Object?> get props {
    return [
      birthDate,
      birthTime,
      birthPlace,
      status,
      failure,
      timezone,
    ];
  }

  SearchTwinsState copyWith({
    String? birthDate,
    TimeOfDay? birthTime,
    String? birthPlace,
    SearchTwinsStatus? status,
    Failure? failure,
    String? timezone,
  }) {
    return SearchTwinsState(
      birthDate: birthDate ?? this.birthDate,
      birthTime: birthTime ?? this.birthTime,
      birthPlace: birthPlace ?? this.birthPlace,
      status: status ?? this.status,
      failure: failure ?? this.failure,
      timezone: timezone ?? this.timezone,
    );
  }

  @override
  String toString() {
    return 'SearchTwinsState(dateOfBirth: $birthDate, timeOfBirth: $birthTime, birthPlace: $birthPlace, status: $status, failure: $failure, timezone: $timezone)';
  }
}
