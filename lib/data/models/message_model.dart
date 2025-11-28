import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String sender;
  final String message;
  final DateTime time;
  final String? senderId;

  MessageModel({
    required this.sender,
    required this.message,
    required this.time,
    this.senderId,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    sender: json['sender'] ?? '',
    message: json['message'] ?? '',
    time: (json['time'] as Timestamp).toDate(),
    senderId: json['senderId'],
  );

  Map<String, dynamic> toJson() => {
    'sender': sender,
    'message': message,
    'time': Timestamp.fromDate(time),
    'senderId': senderId,
  };
}
