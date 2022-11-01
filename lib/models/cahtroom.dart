import 'package:cloud_firestore/cloud_firestore.dart';

class ChatroomModel {
  String? id;
  Timestamp? date;
  String? lastMessage;
  List? participants;

  ChatroomModel(
      {required this.date, required this.id, required this.lastMessage, required this.participants});

  ChatroomModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    date = map['date'];
    lastMessage = map['last_message'];
    participants = map['participant'];
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'date': date, 'last_message': lastMessage, 'participant': participants};
  }
}
