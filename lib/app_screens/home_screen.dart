// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darq/darq.dart';
import 'package:final_offer/app_screens/hotel_booking.dart';
import 'package:final_offer/app_screens/notifications_screen.dart';
import 'package:final_offer/constants.dart';
import 'package:final_offer/models/favorit.dart';
import 'package:final_offer/models/lodge.dart';
import 'package:final_offer/widgets/drawer.dart';
import 'package:final_offer/widgets/error.dart';
import 'package:final_offer/widgets/home_widget.dart';
import 'package:final_offer/widgets/region_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:location/location.dart';

import '../models/users.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  List<bool> isSelected = [true, false, false, false];
  Users? userdata;
  bool isLoading = false;
  TextEditingController search = TextEditingController();
  List<LodgeData> lodgesData = [];
  List<LodgeData> lodgesPopular = [];
  List<LodgeData> lodgeRegions = [];
  List<String> lodgesNames = [];
  int count = 0;

  @override
  void initState() {
    super.initState();
    getLodge();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: !isLoading
            ? SafeArea(
                child: Scaffold(
                  drawerScrimColor: Colors.transparent,
                  appBar: AppBar(
                    centerTitle: true,
                    elevation: 0,
                    backgroundColor: kColorWhite,
                    title: Text(
                      'Home',
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
                    actions: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyNotifications(),
                            ),
                          );
                        },
                        icon: Icon(
                          CupertinoIcons.bell_fill,
                          size: 20,
                          color: kColorBlack,
                        ),
                      ),
                    ],
                  ),
                  drawer: MyDrawer(
                    user: userdata!,
                  ),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 300.w,
                                height: 47.h,
                                child: TypeAheadFormField(
                                  suggestionsCallback: (patteren) => lodgesNames.where((element) =>
                                      element.toLowerCase().contains(patteren.toLowerCase())),
                                  onSuggestionSelected: (String value) {
                                    search.text = value;
                                    List<LodgeData> data = lodgesData
                                        .where((element) =>
                                            element.name!.toLowerCase().contains(value.toLowerCase()))
                                        .toList();

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HotelBooking(
                                                  userdata: userdata!,
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
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(128.r))),
                                    controller: search,
                                  ),
                                ),
                              )
                            ],
                          ),
                          // MySearch(),
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
                                  try {
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
                                      lodgesPopular = lodgesData.length > 10
                                          ? lodgesData.take(10).toList()
                                          : lodgesData.toList();
                                    } else if (index == 1) {
                                      getlocation(); //getting location nad near by places
                                    } else if (index == 2) {
                                      newlyAdded();
                                    } else if (index == 3) {
                                      getFavorit();
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
                                                buttontxt: 'Close')));
                                  }
                                },
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                    child: Text('Popular'),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                    child: Text('Near Me'),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                    child: Text('Newly Added'),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                                    child: Text('favourites'),
                                  )
                                ]),
                          ),

                          SizedBox(
                            height: 32.h,
                          ),
                          SizedBox(
                            height: 168.h,
                            //width: .w,
                            child: ListView.builder(
                                itemCount: lodgesPopular.isNotEmpty ? lodgesPopular.length : 0, //count,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                primary: false,
                                itemBuilder: (context, index) {
                                  return HomeWidget(
                                    lodgeData: lodgesPopular[index],
                                    userdata: userdata!,
                                  );
                                }),
                          ),

                          SizedBox(
                            height: 40.h,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Regions',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: kColorBlack,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          GridView.builder(
                              shrinkWrap: true,
                              primary: false,
                              itemCount: lodgeRegions.isNotEmpty ? lodgeRegions.length : 0,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                              itemBuilder: (context, index) {
                                return SizedBox(
                                    height: 240.h,
                                    width: 160.h,
                                    child: RegionWidget(
                                      lodgeData: lodgeRegions[index],
                                      userdata: userdata!,
                                    ));
                              }),
                        ],
                      ),
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
        onWillPop: () async => false);
  }

  ////all fubctions
  //get data
  Future getLodge() async {
    setState(() {
      isLoading = true;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').where('id', isEqualTo: user!.uid).get();
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          userdata = Users.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
        });
      }
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('lodges')
          .where('to', isGreaterThan: Timestamp.fromDate(DateTime.now()))
          .where('status', isEqualTo: 'active')
          .where('adminStatus', isEqualTo: 'Accepted')
          .get();
      if (snap.docs.isNotEmpty) {
        setState(() {
          lodgesData =
              snap.docs.map((e) => LodgeData.fromMap(e.data() as Map<String, dynamic>)).toList();
          lodgesNames = lodgesData.map((e) => e.name!).toList();
          lodgesData.sort(
            (a, b) => b.bookings!.compareTo(a.bookings!),
          );
          lodgesPopular = lodgesData.length > 10 ? lodgesData.take(10).toList() : lodgesData.toList();
          // count = lodgesData.length;
          lodgeRegions = lodgesData.distinct().toList();
          isLoading = false;
        });
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
                  buttontxt: 'Close')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  //newly added
  Future newlyAdded() async {
    lodgesPopular.clear();
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('lodges')
        .where('date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now().subtract(Duration(days: 30))))
        .where('status', isEqualTo: 'active')
        .where('adminStatus', isEqualTo: 'Accepted')
        .get();
    if (snapshot.docs.isNotEmpty) {
      setState(() {
        lodgesPopular =
            snapshot.docs.map((e) => LodgeData.fromMap(e.data() as Map<String, dynamic>)).toList();
      });
    }
  }

  //getting favorit

  Future getFavorit() async {
    lodgesPopular.clear();

    await FirebaseFirestore.instance
        .collection('favourite')
        .where('userid', isEqualTo: userdata!.id!)
        .where('status', isEqualTo: 'active')
        .get()
        .then((res) async {
      for (var result in res.docs) {
        FavoritData fav = FavoritData.fromMap(result.data());
        QuerySnapshot favsnap = await FirebaseFirestore.instance
            .collection('lodges')
            .where('id', isEqualTo: fav.lodgeid)
            .where('to', isGreaterThan: Timestamp.fromDate(DateTime.now()))
            .where('status', isEqualTo: 'active')
            .where('adminStatus', isEqualTo: 'Accepted')
            .get();
        LodgeData data = LodgeData.fromMap(favsnap.docs.first.data() as Map<String, dynamic>);
        setState(() {
          lodgesPopular.add(data);
        });
      }
    });
  }
  //get loaction and near by devices

  Future getlocation() async {
    try {
      bool _serviceEnabled;
      PermissionStatus _permissionGranted;
      LocationData? _userLocation;
      lodgesPopular.clear();
      // setState(() {
      //   isLoading = true;
      // });
      Location location = Location();

//checking location services is enabled or not
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      /// Check if permission is granted

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }
      final locationData = await location.getLocation();
      _userLocation = locationData;

      //getting near by

      for (var item in lodgesData) {
        double kilometers = calculateDistance(
            locationData.latitude, locationData.longitude, item.latitude, item.longitude);

        if (kilometers < 20) {
          lodgesPopular.add(item);
        }
      }

      setState(() {});
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
                  buttontxt: 'Close')));
    }
  }

  //calculate distance
  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
