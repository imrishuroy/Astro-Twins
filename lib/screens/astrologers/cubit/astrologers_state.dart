part of 'astrologers_cubit.dart';

enum AstrologersStatus { initial, loading, succuss, error }

class AstrologersState extends Equatable {
  final List<Astrologer?> astrologers;
  final AstrologersStatus status;
  final Failure failure;

  const AstrologersState({
    required this.astrologers,
    required this.status,
    required this.failure,
  });
  factory AstrologersState.initial() => const AstrologersState(
      astrologers: [], status: AstrologersStatus.initial, failure: Failure());

  @override
  List<Object> get props => [astrologers, status, failure];

  AstrologersState copyWith({
    List<Astrologer?>? astrologers,
    AstrologersStatus? status,
    Failure? failure,
  }) {
    return AstrologersState(
      astrologers: astrologers ?? this.astrologers,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  @override
  String toString() =>
      'AstrologersState(astrologers: $astrologers, status: $status, failure: $failure)';
}
