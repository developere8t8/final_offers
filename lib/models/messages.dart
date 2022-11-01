import 'package:cloud_firestore/cloud_firestore.dart';

class Messages {
  String? id;
  Timestamp? date;
  String? receiver;
  String? sender;
  String? type;
  bool? seen;
  String? message;
  String? groupdDate;

  Messages(
      {required this.date,
      required this.id,
      required this.receiver,
      required this.seen,
      required this.sender,
      required this.type,
      required this.message,
      required this.groupdDate});
  Messages.fromMap(Map<String, dynamic> map) {
    date = map['date'];
    id = map['id'];
    receiver = map['receiver'];
    sender = map['sender'];
    type = map['type'];
    seen = map['seen'];
    message = map['message'];
    groupdDate = map['group'];
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'id': id,
      'receiver': receiver,
      'sender': sender,
      'type': type,
      'seen': seen,
      'message': message,
      'group': groupdDate
    };
  }
}
