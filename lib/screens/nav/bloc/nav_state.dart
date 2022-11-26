part of 'nav_bloc.dart';

enum NavStatus { initial, loading, succuss, error }

class NavState extends Equatable {
  final NavItem item;
  final NavStatus status;

  const NavState({
    required this.item,
    required this.status,
  });

  factory NavState.initial() =>
      const NavState(item: NavItem.dashboard, status: NavStatus.initial);
  @override
  List<Object> get props => [item, status];

  @override
  String toString() => 'NavState(item: $item, status: $status)';

  @override
  bool? get stringify => true;

  NavState copyWith({
    NavItem? item,
    NavStatus? status,
  }) {
    return NavState(
      item: item ?? this.item,
      status: status ?? this.status,
    );
  }
}
