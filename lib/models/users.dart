import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String? id;
  String? address;
  Timestamp? date;
  String? contact;
  String? email;
  String? imageurl;
  String? name;
  String? password;
  bool? status;
  double? offers;

  Users({
    required this.address,
    required this.contact,
    required this.date,
    required this.email,
    required this.id,
    required this.imageurl,
    required this.name,
    required this.password,
    required this.status,
    required this.offers,
  });
  Users.fromMap(Map<String, dynamic> map) {
    address = map['address'];
    contact = map['contact'];
    date = map['date'];
    email = map['email'];
    id = map['id'];
    imageurl = map['image'];
    name = map['name'];
    password = map['password'];
    status = map['status'];
    offers = map['offers'];
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'contact': contact,
      'date': date,
      'email': email,
      'id': id,
      'image': imageurl,
      'name': name,
      'password': password,
      'status': status,
      'offers': offers
    };
  }
}
