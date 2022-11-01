import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class OffersData {
  String? companyid;
  double? amount;
  String? deadLine;
  Timestamp? from;
  String? id;
  String? lodgeid;
  int? persons;
  String? status;
  Timestamp? to;
  String? userid;
  String? dateCreated;
  Timestamp? date;
  double? actualAmount;
  String? paid;

  OffersData({
    required this.amount,
    required this.companyid,
    required this.deadLine,
    required this.from,
    required this.id,
    required this.lodgeid,
    required this.persons,
    required this.status,
    required this.to,
    required this.userid,
    required this.dateCreated,
    required this.date,
    required this.actualAmount,
    required this.paid,
  });
  OffersData.fromMap(Map<String, dynamic> map) {
    amount = double.parse(map['amount'].toString());
    companyid = map['compnyId'];
    deadLine = map['deadLine'];
    from = map['from'];
    id = map['id'];
    lodgeid = map['lodgeid'];
    persons = int.parse(map['persons'].toString());
    status = map['status'];
    to = map['to'];
    userid = map['userid'];
    dateCreated = map['date_created'];
    date = map['date'];
    actualAmount = map['actual_amount'];
    paid = map['paid'];
  }

  Map<String, dynamic> tomap() {
    return {
      'amount': amount,
      'compnyId': companyid,
      'deadLine': deadLine,
      'from': from,
      'id': id,
      'lodgeid': lodgeid,
      'persons': persons,
      'status': status,
      'to': to,
      'userid': userid,
      'date_created': dateCreated,
      'date': date,
      'actual_amount': actualAmount,
      'paid': paid
    };
  }
}
