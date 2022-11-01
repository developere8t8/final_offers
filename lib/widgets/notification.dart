import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationData {
  String? id;
  Timestamp? date;
  bool? status;
  String? msgid;
  String? message;

  NotificationData(
      {required this.date,
      required this.id,
      required this.status,
      required this.message,
      required this.msgid});

  NotificationData.fromMap(Map<String, dynamic> map) {
    msgid = map['msgid'];
    date = map['date'];
    id = map['id'];
    status = map['status'];
    message = map['message'];
  }
}
