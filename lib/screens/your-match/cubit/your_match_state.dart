part of 'your_match_cubit.dart';

enum YourMatchStatus { initial, loading, succuss, error }

class YourMatchState extends Equatable {
  final List<AppUser?> users;
  final Failure failure;
  final YourMatchStatus status;

  const YourMatchState({
    required this.users,
    required this.failure,
    required this.status,
  });

  factory YourMatchState.initial() => const YourMatchState(
        users: [],
        failure: Failure(),
        status: YourMatchStatus.initial,
      );

  @override
  List<Object> get props => [users, failure, status];

  YourMatchState copyWith({
    List<AppUser?>? users,
    Failure? failure,
    YourMatchStatus? status,
  }) {
    return YourMatchState(
      users: users ?? this.users,
      failure: failure ?? this.failure,
      status: status ?? this.status,
    );
  }

  @override
  String toString() =>
      'YourMatchState(users: $users, failure: $failure, status: $status)';
}
