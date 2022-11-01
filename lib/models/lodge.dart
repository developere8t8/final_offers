import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LodgeData {
  var amentities;
  String? companyId;
  String? description;
  String? duration;
  Timestamp? from;
  Timestamp? to;
  String? id;
  String? location;
  String? name;
  bool? permanent;
  List? photos;
  double? price;
  String? region;
  String? terms;
  String? unit;
  String? videoUrl;
  double? ranking;
  double? bookings;
  double? reviews;
  double? longitude;
  double? latitude;
  Timestamp? date;
  String? category;
  String? status;
  String? dateCreated;
  String? adminStatus;
  bool? archive;

  LodgeData(
      {required this.amentities,
      required this.companyId,
      required this.description,
      required this.duration,
      required this.from,
      required this.id,
      required this.location,
      required this.name,
      required this.permanent,
      required this.unit,
      required this.photos,
      required this.price,
      required this.region,
      required this.terms,
      required this.to,
      required this.videoUrl,
      required this.bookings,
      required this.ranking,
      required this.reviews,
      required this.latitude,
      required this.longitude,
      required this.date,
      required this.status,
      required this.category,
      required this.dateCreated,
      required this.adminStatus,
      required this.archive});

  LodgeData.fromMap(Map<String, dynamic> map) {
    amentities = map['amentites'];
    companyId = map['companyid'];
    description = map['description'];
    duration = map['duration'];
    from = map['from'];
    id = map['id'];
    location = map['location'];
    name = map['name'];
    permanent = map['permanent'];
    photos = map['photos'];
    price = double.parse(map['price'].toString());
    region = map['region'];
    terms = map['terms'];
    to = map['to'];
    unit = map['unit'];
    videoUrl = map['video'];
    bookings = double.parse(map['booking'].toString());
    ranking = double.parse(map['ranking'].toString());
    reviews = double.parse(map['reviews'].toString());
    latitude = double.parse(map['latitude'].toString());
    longitude = double.parse(map['longitude'].toString());
    date = map['date'];
    category = map['category'];
    status = map['status'];
    dateCreated = map['date_created'];
    adminStatus = map['adminStatus'];
    archive = map['archive'];
  }
  Map<String, dynamic> toMap() {
    return {
      'amentites': amentities,
      'companyid': companyId,
      'description': description,
      'duration': duration,
      'from': from,
      'id': id,
      'location': location,
      'name': name,
      'permanent': permanent,
      'photos': photos,
      'price': price,
      'region': region,
      'terms': terms,
      'to': to,
      'unit': unit,
      'video': videoUrl,
      'bookings': bookings,
      'reviews': reviews,
      'ranking': ranking,
      'latitude': latitude,
      'longitude': longitude,
      'date': date,
      'category': category,
      'status': status,
      'date_created': dateCreated,
      'adminStatus': adminStatus,
      'archive': archive
    };
  }
}

// class LodgeBooking {
//   String? id;
//   int? booking;

//   LodgeBooking({required this.booking, required this.id});

//   LodgeBooking.fromMap(Map<String, dynamic> map) {
//     id = map['id'];
//     booking = map['bookings'];
//   }
// }

// class LodgeRating {
//   String? id;
//   int? stars;
//   String? userid;

//   LodgeRating({required this.id, required this.stars, required this.userid});
//   LodgeRating.fromMap(Map<String, dynamic> map) {
//     id = map['id'];
//     stars = map['stars'];
//     userid = map['userid'];
//   }
// }
