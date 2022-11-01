// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_offer/app_screens/hotel_booking.dart';
import 'package:final_offer/app_screens/notifications_screen.dart';
import 'package:final_offer/constants.dart';
import 'package:final_offer/models/lodge.dart';
import 'package:final_offer/widgets/drawer.dart';
import 'package:final_offer/widgets/place_selection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../models/users.dart';
import 'package:video_player/video_player.dart';

class PlaceSelection extends StatefulWidget {
  final Users userdata;
  final String region;
  PlaceSelection({Key? key, required this.userdata, required this.region}) : super(key: key);

  @override
  State<PlaceSelection> createState() => _PlaceSelectionState();
}

class _PlaceSelectionState extends State<PlaceSelection> {
  TextEditingController search = TextEditingController();
  late VideoPlayerController videoPlayerController;
  bool isLoading = false;
  List<LodgeData> lodgedata = [];
  List<LodgeData> temp = [];
  List<String> lodgesNames = [];
  List<bool> isSelected = [true, false, false, false, false];
  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: !isLoading
          ? Scaffold(
              appBar: AppBar(
                centerTitle: true,
                elevation: 0,
                backgroundColor: kColorWhite,
                title: Text(
                  widget.region,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: kColorBlack,
                  ),
                ),
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: Image.asset(
                      'assets/icons/menu1.png',
                      scale: 3.5,
                    ),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                // actions: [
                //   IconButton(
                //     onPressed: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => MyNotifications(),
                //         ),
                //       );
                //     },
                //     icon: const Icon(
                //       CupertinoIcons.bell_fill,
                //       size: 20,
                //       color: kColorBlack,
                //     ),
                //   ),
                // ],
              ),
              drawer: MyDrawer(
                user: widget.userdata,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 26.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 300.w,
                            height: 47.h,
                            child: TypeAheadFormField(
                              suggestionsCallback: (patteren) => lodgesNames.where(
                                  (element) => element.toLowerCase().contains(patteren.toLowerCase())),
                              onSuggestionSelected: (String value) {
                                search.text = value;
                                List<LodgeData> data = lodgedata
                                    .where((element) =>
                                        element.name!.toLowerCase().contains(value.toLowerCase()))
                                    .toList();

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HotelBooking(
                                              userdata: widget.userdata,
                                              lodgeData: data[0],
                                            )));
                              },
                              itemBuilder: (_, String item) => Card(
                                // shape: StadiumBorder(
                                //   side: BorderSide(
                                //     color: Colors.blue,
                                //     width: 0.5,
                                //   ),
                                // ),
                                color: Colors.white,
                                child: ListTile(
                                  title: Text(item),
                                ),
                              ),
                              getImmediateSuggestions: true,
                              hideSuggestionsOnKeyboardHide: true,
                              hideOnEmpty: false,
                              noItemsFoundBuilder: (_) => const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text('No lodge found'),
                              ),
                              textFieldConfiguration: TextFieldConfiguration(
                                decoration: InputDecoration(
                                    suffixIcon: Icon(
                                      CupertinoIcons.search,
                                      color: kUILight2,
                                    ),
                                    labelText: 'Search',
                                    border:
                                        OutlineInputBorder(borderRadius: BorderRadius.circular(128.r))),
                                controller: search,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ToggleButtons(
                            selectedColor: Colors.white,
                            fillColor: Colors.blue,
                            isSelected: isSelected,
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10.0),
                            borderWidth: 2.0,
                            direction: Axis.horizontal,
                            onPressed: (int index) {
                              setState(() {
                                for (int i = 0; i < isSelected.length; i++) {
                                  if (i == index) {
                                    isSelected[i] = true;
                                  } else {
                                    isSelected[i] = false;
                                  }
                                }
                              });
                              if (index == 0) {
                                getdata();
                              } else if (index == 1) {
                                gethotels();
                              } else if (index == 2) {
                                getLodges();
                              } else if (index == 3) {
                                getbeach();
                              } else if (index == 4) {
                                getmountain();
                              }
                            },
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                child: Text('Popular'),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                child: Text('Hotel'),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                child: Text('Lodges'),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                child: Text('Beach'), //
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                child: Text('Mountains'),
                              )
                            ]),
                      ),
                      SizedBox(height: 25.h),
                      ListView.builder(
                          itemCount: temp.isEmpty ? 0 : temp.length,
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (context, index) {
                            return PlaceSelectionWidget(
                              lodgeData: temp[index],
                              userdata: widget.userdata,
                            );
                          }),
                      SizedBox(height: 15.h),
                    ],
                  ),
                ),
              ),
            )
          : Container(
              color: Colors.white,
              child: Center(
                  child: SizedBox(
                height: 30,
                width: 60,
                child: LoadingIndicator(
                  indicatorType: Indicator.lineScalePulseOut,
                ),
              )),
            ),
    );
  }

  //getting tyhpe data
  Future getdata() async {
    lodgedata.clear();
    lodgesNames.clear();
    temp.clear();
    setState(() {
      isLoading = true;
    });

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('lodges')
        .where('region', isEqualTo: widget.region)
        .where('to', isGreaterThan: Timestamp.fromDate(DateTime.now()))
        .where('status', isEqualTo: 'active')
        .where('adminStatus', isEqualTo: 'Accepted')
        .get();
    if (snapshot.docs.isNotEmpty) {
      lodgedata = snapshot.docs.map((e) => LodgeData.fromMap(e.data() as Map<String, dynamic>)).toList();
      lodgesNames = lodgedata.map((e) => e.name!).toList();
      temp = lodgedata;
    }
    isLoading = false;
    setState(() {});
  }

  Future gethotels() async {
    lodgedata.clear();
    lodgesNames.clear();
    temp.clear();
    setState(() {
      isLoading = true;
    });

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('lodges')
        .where('region', isEqualTo: widget.region)
        .where('category', isEqualTo: 'Hotel')
        .where('to', isGreaterThan: Timestamp.fromDate(DateTime.now()))
        .where('status', isEqualTo: 'active')
        .where('adminStatus', isEqualTo: 'Accepted')
        .get();
    if (snapshot.docs.isNotEmpty) {
      lodgedata = snapshot.docs.map((e) => LodgeData.fromMap(e.data() as Map<String, dynamic>)).toList();
      lodgesNames = lodgedata.map((e) => e.name!).toList();
      temp = lodgedata;
    }
    isLoading = false;
    setState(() {});
  }

  Future getLodges() async {
    lodgedata.clear();
    lodgesNames.clear();
    temp.clear();
    setState(() {
      isLoading = true;
    });

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('lodges')
        .where('region', isEqualTo: widget.region)
        .where('category', isEqualTo: 'Lodge')
        .where('to', isGreaterThan: Timestamp.fromDate(DateTime.now()))
        .where('status', isEqualTo: 'active')
        .where('adminStatus', isEqualTo: 'Accepted')
        .get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        lodgedata =
            snapshot.docs.map((e) => LodgeData.fromMap(e.data() as Map<String, dynamic>)).toList();
        lodgesNames = lodgedata.map((e) => e.name!).toList();
        temp = lodgedata;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Future getbeach() async {
    lodgedata.clear();
    lodgesNames.clear();
    temp.clear();
    setState(() {
      isLoading = true;
    });

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('lodges')
        .where('region', isEqualTo: widget.region)
        .where('category', isEqualTo: 'Beach')
        .where('to', isGreaterThan: Timestamp.fromDate(DateTime.now()))
        .where('status', isEqualTo: 'active')
        .where('adminStatus', isEqualTo: 'Accepted')
        .get();
    if (snapshot.docs.isNotEmpty) {
      lodgedata = snapshot.docs.map((e) => LodgeData.fromMap(e.data() as Map<String, dynamic>)).toList();
      lodgesNames = lodgedata.map((e) => e.name!).toList();
      temp = lodgedata;
    }
    isLoading = false;
    setState(() {});
  }

  Future getmountain() async {
    lodgedata.clear();
    lodgesNames.clear();
    temp.clear();
    setState(() {
      isLoading = true;
    });

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('lodges')
        .where('region', isEqualTo: widget.region)
        .where('category', isEqualTo: 'Mountain')
        .where('to', isGreaterThan: Timestamp.fromDate(DateTime.now()))
        .where('status', isEqualTo: 'active')
        .where('adminStatus', isEqualTo: 'Accepted')
        .get();
    if (snapshot.docs.isNotEmpty) {
      lodgedata = snapshot.docs.map((e) => LodgeData.fromMap(e.data() as Map<String, dynamic>)).toList();
      lodgesNames = lodgedata.map((e) => e.name!).toList();
      temp = lodgedata;
    }
    isLoading = false;
    setState(() {});
  }
}
