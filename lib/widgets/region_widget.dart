// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_offer/app_screens/place_selection_screen.dart';
import 'package:final_offer/constants.dart';
import 'package:final_offer/models/favorit.dart';
import 'package:final_offer/models/lodge.dart';
import 'package:final_offer/models/users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegionWidget extends StatefulWidget {
  final LodgeData lodgeData;
  final Users userdata;
  const RegionWidget({Key? key, required this.lodgeData, required this.userdata}) : super(key: key);

  @override
  State<RegionWidget> createState() => _RegionWidgetState();
}

class _RegionWidgetState extends State<RegionWidget> {
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
        : Padding(
            padding: EdgeInsets.all(3.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PlaceSelection(
                              userdata: widget.userdata,
                              region: widget.lodgeData.region!,
                            )));
              },
              child: Container(
                width: 160.w,
                height: 238.h,
                decoration: BoxDecoration(
                  color: kColorWhite,
                  borderRadius: BorderRadius.circular(20.r),
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
                      width: 150.w,
                      height: 150.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          topRight: Radius.circular(20.r),
                        ),
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
                              left: 120.w,
                              top: 12.h,
                              child: InkWell(
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
                                    final favdoc =
                                        FirebaseFirestore.instance.collection('favourite').doc();
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
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                        width: 130.w,
                        child: Center(
                          child: Text(
                            widget.lodgeData.region!,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: kColorBlack2,
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          );
  }
}
