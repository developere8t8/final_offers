// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_offer/app_screens/edit_offer.dart';
import 'package:final_offer/constants.dart';
import 'package:final_offer/models/favorit.dart';
import 'package:final_offer/models/lodge.dart';
import 'package:final_offer/models/offers.dart';
import 'package:final_offer/widgets/error.dart';
import 'package:final_offer/widgets/gradient_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyOffersWidget extends StatefulWidget {
  final OffersData offer;
  final VoidCallback function;
  const MyOffersWidget({Key? key, required this.offer, required this.function}) : super(key: key);

  @override
  State<MyOffersWidget> createState() => _MyOffersWidgetState();
}

class _MyOffersWidgetState extends State<MyOffersWidget> {
  LodgeData? lodgeData;
  FavoritData? favData;
  bool isLoading = false;
  bool favourit = false;
  Color statusColors = kColorAqua;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? SizedBox(
            width: 339.w,
            height: 146.h,
          )
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
                Container(
                  width: 118.w,
                  height: 146.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    image: DecorationImage(
                      image: NetworkImage(
                        lodgeData!.photos![0],
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                    horizontal: 10.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 170.w,
                            child: Text(
                              lodgeData!.name!,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: kColorBlack2,
                              ),
                            ),
                          ),
                          Container(
                              width: 25.w,
                              height: 25.h,
                              decoration: BoxDecoration(
                                color: kUILight7,
                                shape: BoxShape.circle,
                              ),
                              child: InkWell(
                                onTap: () {
                                  if (favourit) {
                                    final userDoc = FirebaseFirestore.instance
                                        .collection('favourite')
                                        .doc(favData!.id!);
                                    userDoc.delete();
                                    setState(() {
                                      favourit = false;
                                    });
                                  } else {
                                    final favdoc =
                                        FirebaseFirestore.instance.collection('favourite').doc();
                                    FavoritData data = FavoritData(
                                        id: favdoc.id,
                                        lodgeid: widget.offer.lodgeid,
                                        userid: widget.offer.userid);
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
                                    favourit ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                                    size: 14,
                                    color: favourit ? Colors.red : Colors.black,
                                  ),
                                ),
                              )),
                        ],
                      ),
                      SizedBox(height: 5.h),
                      Wrap(
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
                            width: 200.w,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    lodgeData!.location!,
                                    //overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w400,
                                      color: kUILight2,
                                    ),
                                  ),
                                )
                              ],
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
                                  initialRating: lodgeData!.ranking! / lodgeData!.reviews!,
                                  itemSize: 14.0,
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
                                '${lodgeData!.ranking! / lodgeData!.reviews!}',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                  color: kUIDark,
                                ),
                              ),
                              SizedBox(
                                width: 90.w,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditOffer(
                                              lodgeData: lodgeData!, offersData: widget.offer)));
                                },
                                child: Text(
                                  'View',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: kPrimary1,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 147.w,
                                child: Text(
                                  statusString(widget.offer.status!),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: statusColors,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      widget.function();
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          CupertinoIcons.delete,
                                          size: 19,
                                          color: kUILight2,
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Text(
                                          'Delete',
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w500,
                                            color: kUILight2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  //all functions

  Future getData() async {
    try {
      setState(() {
        isLoading = true;
      });

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('lodges')
          .where('id', isEqualTo: widget.offer.lodgeid)
          .get();
      if (snapshot.docs.isNotEmpty) {
        lodgeData = LodgeData.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
      }
      QuerySnapshot fav = await FirebaseFirestore.instance
          .collection('favourite')
          .where('lodgeid', isEqualTo: widget.offer.lodgeid)
          .where('userid', isEqualTo: widget.offer.userid)
          .get();
      if (fav.docs.isNotEmpty) {
        favData = FavoritData.fromMap(fav.docs.first.data() as Map<String, dynamic>);
        favourit = true;
      }
    } catch (e) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ErrorDialog(
                  title: 'Error',
                  message: e.toString(),
                  type: 'E',
                  function: () {
                    Navigator.pop(context);
                  },
                  buttontxt: 'Ok')));
      // showErrorDialogue(context, 'Error', e.toString(), () {
      //   Navigator.pop(context);
      // });
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  Future favorite() async {
    try {
      setState(() {
        isLoading = true;
      });

      QuerySnapshot fav = await FirebaseFirestore.instance
          .collection('favourite')
          .where('lodgeid', isEqualTo: widget.offer.lodgeid)
          .where('userid', isEqualTo: widget.offer.userid)
          .get();
      if (fav.docs.isNotEmpty) {
        favData = FavoritData.fromMap(fav.docs.first.data() as Map<String, dynamic>);
        favourit = true;
      }
    } catch (e) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ErrorDialog(
                  title: 'Error',
                  message: e.toString(),
                  type: 'E',
                  function: () {
                    Navigator.pop(context);
                  },
                  buttontxt: 'Ok')));
      // showErrorDialogue(context, 'Error', e.toString(), () {
      //   Navigator.pop(context);
      // });
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  String statusString(String status) {
    if (widget.offer.to!.toDate().isBefore(DateTime.now().subtract(Duration(days: 60)))) {
      statusColors = kUILight2;
      return 'Inactive';
    } else if (status.toLowerCase() == 'accepted') {
      statusColors = kColorAqua;
      return 'Accepted';
    } else if (status.toLowerCase() == 'rejected') {
      statusColors = kPrimary2;
      return 'Declined';
    } else if (status.toLowerCase() == 'pending') {
      statusColors = kColorOrange;
      return 'Pending';
    } else {
      statusColors = kUILight2;
      return 'Inactive';
    }
  }
}
