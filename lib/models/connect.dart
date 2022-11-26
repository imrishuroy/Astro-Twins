import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';
import 'package:astro_twins/enums/connect_status.dart';

class Connect extends Equatable {
  final ConnectStatus status;
  final String? userId;

  const Connect({
    required this.status,
    required this.userId,
  });

  Connect copyWith({
    ConnectStatus? status,
    String? userId,
  }) {
    return Connect(
      status: status ?? this.status,
      userId: userId ?? this.userId,
    );
  }

  int compareTo(other) {
    return 1;
  }

  Map<String, dynamic> toMap() {
    return {
      'status': EnumToString.convertToString(status),
      'userId': userId,
    };
  }

  static Connect fromDocument(DocumentSnapshot? doc) {
    // if (doc == null) {
    //   return ;
    // }
    final data = doc?.data() as Map?;

    return Connect(
      status: data?['status'] != null
          ? EnumToString.fromString(ConnectStatus.values, data?['status']) ??
              ConnectStatus.unknown
          : ConnectStatus.unknown,
      userId: doc?.id,
    );

    /// return null;
  }

  factory Connect.fromMap(Map<String, dynamic> map) {
    return Connect(
      status: map['status'] != null
          ? EnumToString.fromString(ConnectStatus.values, map['status']) ??
              ConnectStatus.unknown
          : ConnectStatus.unknown,
      // map['status'] != null ? EnumToString.fromString(ConnectStatus.values, map['status']) : ConnectStatus.unknown)
      userId: map['userId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Connect.fromJson(String source) =>
      Connect.fromMap(json.decode(source));

  @override
  String toString() => 'Connect(status: $status, userId: $userId)';

  @override
  List<Object?> get props => [status, userId];
}
