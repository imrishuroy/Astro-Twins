import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:equatable/equatable.dart';

import '/enums/enums.dart';

class ChatMessage extends Equatable {
  final String? message;
  final DateTime? createdAt;
  final String? authorId;
  final String? receiverId;
  final MediaType? mediaType;

  const ChatMessage({
    required this.message,
    required this.createdAt,
    required this.receiverId,
    this.mediaType = MediaType.none,
    required this.authorId,
  });

  Map<String, dynamic> toMap() {
    final chatMediaType = EnumToString.convertToString(mediaType);
    return {
      'message': message,
      'mediaType': chatMediaType,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'authorId': authorId,
      'receiverId': receiverId,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    final chatMediaType =
        EnumToString.fromString(MediaType.values, map['mediaType']);
    return ChatMessage(
      message: map['message'],
      mediaType: chatMediaType ?? MediaType.other,
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      authorId: map['authorId'],
      receiverId: map['receiverId'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessage.fromJson(String source) =>
      ChatMessage.fromMap(json.decode(source));

  @override
  List<Object?> get props =>
      [message, mediaType, createdAt, authorId, receiverId];

  ChatMessage copyWith({
    String? message,
    DateTime? createdAt,
    String? authorId,
    String? receiverId,
    MediaType? mediaType,
  }) {
    return ChatMessage(
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      authorId: authorId ?? this.authorId,
      receiverId: receiverId ?? this.receiverId,
      mediaType: mediaType ?? this.mediaType,
    );
  }

  @override
  String toString() {
    return 'ChatMessage(message: $message, createdAt: $createdAt, authorId: $authorId, receiverId: $receiverId, mediaType: $mediaType)';
  }
}
