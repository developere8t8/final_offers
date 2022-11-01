// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_offer/app_screens/hotel_booking.dart';
import 'package:final_offer/app_screens/place_selection_screen.dart';
import 'package:final_offer/constants.dart';
import 'package:final_offer/models/favorit.dart';
import 'package:final_offer/models/lodge.dart';
import 'package:final_offer/models/users.dart';
import 'package:final_offer/widgets/gradient_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeWidget extends StatefulWidget {
  final LodgeData lodgeData;
  final Users userdata;
  const HomeWidget({Key? key, required this.lodgeData, required this.userdata}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  bool favorit = false;
  bool isLoading = false;
  FavoritData? favoritData;
  //getting lodge
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
        : InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HotelBooking(
                            userdata: widget.userdata,
                            lodgeData: widget.lodgeData,
                          )));
            },
            child: Padding(
              padding: EdgeInsets.only(
                left: 7.w,
                right: 7.w,
                top: 6.h,
              ),
              child: Container(
                  width: 180.w,
                  height: 166.h,
                  decoration: BoxDecoration(
                    color: kColorWhite,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(112, 144, 176, 0.2),
                        offset: Offset(0.0, 16.0),
                        blurRadius: 40,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 166.w,
                        height: 106.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          image: DecorationImage(
                            image: NetworkImage(
                              widget.lodgeData.photos![0],
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                                left: 134.w,
                                top: 8.h,
                                child: InkWell(
                                  onTap: () async {
                                    if (favorit) {
                                      final userDoc = FirebaseFirestore.instance
                                          .collection('favourite')
                                          .doc(favoritData!.id!);
                                      await userDoc.delete();
                                      setState(() {
                                        favorit = false;
                                      });
                                    } else {
                                      final favdoc =
                                          FirebaseFirestore.instance.collection('favourite').doc();
                                      FavoritData data = FavoritData(
                                          id: favdoc.id,
                                          lodgeid: widget.lodgeData.id,
                                          userid: widget.userdata.id);
                                      await favdoc.set(data.toMap());
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
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 7.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.lodgeData.name!,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: kColorBlack2,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 4.h),
                              child: Wrap(
                                children: [
                                  GradientIcon(
                                    icon: CupertinoIcons.star_fill,
                                    size: 10,
                                    gradient: kGradientBlue,
                                  ),
                                  SizedBox(
                                    width: 3.56.w,
                                  ),
                                  Text(
                                    widget.lodgeData.reviews.toString(),
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w400,
                                      color: kUILight2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 9.74),
                        child: Row(
                          children: [
                            GradientIcon(
                              icon: Icons.location_pin,
                              size: 10,
                              gradient: kGradientBlue,
                            ),
                            SizedBox(
                              width: 4.26.w,
                            ),
                            SizedBox(
                              width: 130.w,
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
                      ),
                    ],
                  )),
            ),
          );
  }
}
