part of 'connect_cubit.dart';

class ConnectState extends Equatable {
  // final Set<String> connectedUserIds;
  final Set<Connect> connectedUserIds;
  final Set<Connect> connectedAstroIds;

  const ConnectState({
    required this.connectedUserIds,
    required this.connectedAstroIds,
  });

  factory ConnectState.initial() {
    return const ConnectState(
      connectedUserIds: <Connect>{},
      connectedAstroIds: <Connect>{},
    );
  }

  @override
  List<Object> get props => [
        connectedUserIds,
        connectedAstroIds,
      ];

  ConnectState copyWith({
    // Set<String>? connectedUserIds,
    Set<Connect>? connectedUserIds,
    Set<Connect>? connectedAstroIds,
  }) {
    return ConnectState(
      connectedUserIds: connectedUserIds ?? this.connectedUserIds,
      connectedAstroIds: connectedAstroIds ?? this.connectedAstroIds,
    );
  }
}
