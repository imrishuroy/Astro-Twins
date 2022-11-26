part of 'dashboard_cubit.dart';

enum DashBoardStatus { initial, loading, succuss, error }

class DashboardState extends Equatable {
  final List<AppUser?> twins;
  final DashBoardStatus status;
  final Failure failure;

  const DashboardState({
    required this.twins,
    required this.status,
    required this.failure,
  });

  factory DashboardState.initial() => const DashboardState(
      twins: [], status: DashBoardStatus.initial, failure: Failure());
  @override
  List<Object> get props => [twins, status, failure];

  DashboardState copyWith({
    List<AppUser?>? twins,
    DashBoardStatus? status,
    Failure? failure,
  }) {
    return DashboardState(
      twins: twins ?? this.twins,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }

  @override
  String toString() =>
      'DashboardState(twins: $twins, status: $status, failure: $failure)';
}
