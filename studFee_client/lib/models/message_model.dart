// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Message {
  final String sender;
  final String message;
  final String? mediaUrl;
  final DateTime? date;

  Message({
    required this.sender,
    required this.message,
    this.mediaUrl,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sender': sender,
      'message': message,
      'mediaUrl': mediaUrl,
      'date': date?.millisecondsSinceEpoch,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      sender: map['sender'] as String,
      message: map['message'] as String,
      mediaUrl: map['mediaUrl'] != null ? map['mediaUrl'] as String : null,
      date: map['date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['date'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);
}
