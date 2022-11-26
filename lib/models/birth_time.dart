import 'dart:convert';

import 'package:equatable/equatable.dart';

class BirthTime extends Equatable {
  final int? minute;
  final int? hour;

  const BirthTime({
    this.minute,
    this.hour,
  });

  BirthTime copyWith({
    int? minute,
    int? hour,
  }) {
    return BirthTime(
      minute: minute ?? this.minute,
      hour: hour ?? this.hour,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'minute': minute,
      'hour': hour,
    };
  }

  factory BirthTime.fromMap(Map<String, dynamic> map) {
    return BirthTime(
      minute: map['minute']?.toInt(),
      hour: map['hour']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory BirthTime.fromJson(String source) =>
      BirthTime.fromMap(json.decode(source));

  @override
  String toString() => 'BirthTime(minute: $minute, hour: $hour)';

  @override
  List<Object?> get props => [minute, hour];
}
