// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_offer/constants.dart';
import 'package:final_offer/models/favorit.dart';
import 'package:final_offer/models/lodge.dart';
import 'package:final_offer/models/users.dart';

import 'package:final_offer/widgets/gradient_icon.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../app_screens/hotel_booking.dart';

class PlaceSelectionWidget extends StatefulWidget {
  final Users userdata;
  final LodgeData lodgeData;
  const PlaceSelectionWidget({Key? key, required this.lodgeData, required this.userdata})
      : super(key: key);

  @override
  State<PlaceSelectionWidget> createState() => _PlaceSelectionWidgetState();
}

class _PlaceSelectionWidgetState extends State<PlaceSelectionWidget> {
  bool favorit = false;
  bool isLoading = false;
  FavoritData? favoritData;

  //getting favorite lodge
  Future favorite() async {
    try {
      setState(() {
        isLoading = true;
      });
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('favourite')
          .where('userid', isEqualTo: widget.userdata.id)
          .where('lodgeid', isEqualTo: widget.lodgeData.id)
          .get();
      if (snapshot.docs.isNotEmpty) {
        favoritData = FavoritData.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
        setState(() {
          favorit = true;
        });
      }
    } catch (e) {
      return e;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    favorite();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container()
        : Container(
            width: 339.w,
            height: 146.h,
            decoration: BoxDecoration(
              color: kColorWhite,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  offset: Offset(0.0, 4.0),
                  blurRadius: 50,
                ),
              ],
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HotelBooking(
                                  userdata: widget.userdata,
                                  lodgeData: widget.lodgeData,
                                )));
                  },
                  child: Container(
                    width: 118.w,
                    height: 146.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      image: DecorationImage(
                        image: NetworkImage(
                          widget.lodgeData.photos![0],
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 18.h,
                    horizontal: 10.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 176.w,
                            child: Text(
                              widget.lodgeData.name!,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: kColorBlack2,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (favorit) {
                                final userDoc = FirebaseFirestore.instance
                                    .collection('favourite')
                                    .doc(favoritData!.id!);
                                userDoc.delete();
                                setState(() {
                                  favorit = false;
                                });
                              } else {
                                final favdoc = FirebaseFirestore.instance.collection('favourite').doc();
                                FavoritData data = FavoritData(
                                    id: favdoc.id,
                                    lodgeid: widget.lodgeData.id,
                                    userid: widget.userdata.id);
                                favdoc.set(data.toMap());
                                favorite();
                              }
                            },
                            child: Container(
                              width: 25.w,
                              height: 25.h,
                              decoration: BoxDecoration(
                                color: kColorWhite,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                favorit ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                                size: 14,
                                color: favorit ? Colors.red : Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          GradientIcon(
                            icon: Icons.location_pin,
                            size: 10,
                            gradient: kGradientBlue,
                          ),
                          SizedBox(
                            width: 1.w,
                          ),
                          SizedBox(
                            width: 150.w,
                            child: Text(
                              widget.lodgeData.location!,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w400,
                                color: kUILight2,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                child: RatingBar.builder(
                                  initialRating: widget.lodgeData.ranking! / widget.lodgeData.reviews!,
                                  itemSize: 12.0,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding: EdgeInsets.symmetric(horizontal: 0.5),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.blue[400],
                                  ),
                                  onRatingUpdate: (rating) {
                                    null;
                                  },
                                  ignoreGestures: true,
                                ),
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                '${widget.lodgeData.ranking! / widget.lodgeData.reviews!}',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                  color: kUIDark,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HotelBooking(
                                            userdata: widget.userdata,
                                            lodgeData: widget.lodgeData,
                                          )));
                            },
                            child: Text(
                              'Make Offer',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: kPrimary1,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
