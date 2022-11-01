// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_offer/constants.dart';
import 'package:final_offer/models/offers.dart';
import 'package:final_offer/widgets/bottom_navigation_bar.dart';
import 'package:final_offer/widgets/error.dart';
import 'package:final_offer/widgets/my_offers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';

class MyOffers extends StatefulWidget {
  const MyOffers({Key? key}) : super(key: key);

  @override
  State<MyOffers> createState() => _MyOffersState();
}

class _MyOffersState extends State<MyOffers> {
  bool isLoading = false;
  List<OffersData> offers = [];
  List<OffersData> acceptedOffers = [];
  List<OffersData> rejectedOffers = [];
  List<OffersData> pastOffers = [];
  @override
  void initState() {
    getAllData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
      onWillPop: () async => false,
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              indicatorColor: kPrimary2,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: kPrimary2,
              unselectedLabelColor: kUILight2,
              labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
              indicatorWeight: 3,
              tabs: [
                Tab(text: 'All'),
                Tab(text: 'Accepted'),
                Tab(text: 'Declined'),
                Tab(text: 'Past Trips'),
              ],
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: kColorWhite,
            title: Text(
              'My Offers',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: kColorBlack,
              ),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomBar()));
              },
              icon: const Icon(
                CupertinoIcons.arrow_left,
                color: kUIDark,
                size: 20,
              ),
            ),
          ),
          body: isLoading
              ? Container(
                  color: Colors.white,
                  child: Center(
                      child: SizedBox(
                    height: 30,
                    width: 60,
                    child: LoadingIndicator(
                      indicatorType: Indicator.lineScalePulseOut,
                    ),
                  )),
                )
              : TabBarView(
                  children: [
                    //showing all
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 30),
                          ListView.builder(
                              itemCount: offers.isEmpty ? 0 : offers.length,
                              primary: false,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return offers.isEmpty
                                    ? Center(
                                        child: Text(
                                          'Nothing to show',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      )
                                    : Padding(
                                        padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                                        child: MyOffersWidget(
                                          offer: offers[index],
                                          function: (() => deleteListItem(offers[index].id!)),
                                        ),
                                      );
                              }),
                        ],
                      ),
                    ),
                    //showing accepted
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 30),
                          ListView.builder(
                              itemCount: acceptedOffers.isEmpty ? 0 : acceptedOffers.length,
                              primary: false,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return acceptedOffers.isEmpty
                                    ? Center(
                                        child: Text(
                                          'Nothing to show',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      )
                                    : Padding(
                                        padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                                        child: MyOffersWidget(
                                          offer: acceptedOffers[index],
                                          function: (() => deleteListItem(acceptedOffers[index].id!)),
                                        ),
                                      );
                              }),
                        ],
                      ),
                    ),

                    //showing rejected
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 30),
                          ListView.builder(
                              itemCount: rejectedOffers.isEmpty ? 0 : rejectedOffers.length,
                              primary: false,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return rejectedOffers.isEmpty
                                    ? Center(
                                        child: Text(
                                          'Nothing to show',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      )
                                    : Padding(
                                        padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                                        child: MyOffersWidget(
                                          offer: rejectedOffers[index],
                                          function: (() => deleteListItem(rejectedOffers[index].id!)),
                                        ),
                                      );
                              }),
                        ],
                      ),
                    ),
                    //showing past trips
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 30),
                          ListView.builder(
                              itemCount: pastOffers.isEmpty ? 0 : pastOffers.length,
                              primary: false,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return pastOffers.isEmpty
                                    ? Center(
                                        child: Text(
                                          'Nothing to show',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      )
                                    : Padding(
                                        padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                                        child: MyOffersWidget(
                                          offer: pastOffers[index],
                                          function: (() => deleteListItem(pastOffers[index].id!)),
                                        ),
                                      );
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    ));
  }

  //getting data at begning

  Future getAllData() async {
    try {
      setState(() {
        isLoading = true;
      });
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('offers')
          .where('userid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          offers =
              snapshot.docs.map((e) => OffersData.fromMap(e.data() as Map<String, dynamic>)).toList();

          acceptedOffers =
              offers.where((element) => element.status!.toLowerCase() == 'accepted').toList();

          rejectedOffers =
              offers.where((element) => element.status!.toLowerCase() == 'rejected').toList();
          pastOffers = offers
              .where((element) =>
                  element.status!.toLowerCase() == 'accepted' &&
                  element.to!.toDate().isBefore(DateTime.now().subtract(Duration(days: 30))))
              .toList();
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
                  buttontxt: 'Ok')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  //deleting a widget from list
  Future deleteListItem(String id) async {
    final delOffer = FirebaseFirestore.instance.collection('offers').doc(id);
    await delOffer.delete();

    setState(() {
      offers.removeWhere(
        (element) => element.id == id,
      );
      acceptedOffers.removeWhere(
        (element) => element.id == id,
      );
      rejectedOffers.removeWhere(
        (element) => element.id == id,
      );
      pastOffers.removeWhere(
        (element) => element.id == id,
      );
    });
  }
}
