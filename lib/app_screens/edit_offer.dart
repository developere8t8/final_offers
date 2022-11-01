import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_offer/app_screens/home_screen.dart';
import 'package:final_offer/app_screens/preview.dart';
import 'package:final_offer/models/lodge.dart';
import 'package:final_offer/models/offers.dart';
import 'package:final_offer/models/users.dart';
import 'package:final_offer/widgets/bottom_navigation_bar.dart';
import 'package:final_offer/widgets/buttons.dart';
import 'package:final_offer/widgets/error.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';
import '../constants.dart';

class EditOffer extends StatefulWidget {
  final OffersData offersData;
  final LodgeData lodgeData;
  const EditOffer({Key? key, required this.lodgeData, required this.offersData}) : super(key: key);

  @override
  State<EditOffer> createState() => _EditOfferState();
}

class _EditOfferState extends State<EditOffer> {
  bool isLoading = false;
  Completer<GoogleMapController> controller = Completer();
  DateRangePickerController rangePickerController = DateRangePickerController();
  bool checkbox24 = true;
  bool checkbox48 = false;
  bool checkboxflex = false;
  String noticeDays = '24h';
  List<DateTime> blackOutDays = [];
  TextEditingController finalOffer = TextEditingController();
  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now();
  int days = 0;
  late VideoPlayerController videoPlayerController;
  int persons = 1;
  List<DateTime>? alreadySelectedDates = [];

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _playVideo(init: false);
    getbookings();
    super.initState();
    getAlreadySelectedDates();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: Container(
            constraints: const BoxConstraints.expand(),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  widget.lodgeData.photos![0],
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              constraints: const BoxConstraints.expand(),
              decoration: const BoxDecoration(
                gradient: kGradientShadow,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                      child: Column(
                        children: [
                          SizedBox(height: 54.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  CupertinoIcons.arrow_left,
                                  color: kColorWhite,
                                  size: 20,
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: Stack(
                                  children: [
                                    Positioned(
                                        child: Container(
                                      width: 52.w,
                                      height: 52.h,
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(255, 255, 255, 0.3),
                                        borderRadius: BorderRadius.circular(12.r),
                                      ),
                                    )),
                                    Positioned(
                                      left: 4.w,
                                      top: 4.h,
                                      child: Container(
                                        width: 44.w,
                                        height: 44.h,
                                        decoration: BoxDecoration(
                                          color: kPrimary1,
                                          borderRadius: BorderRadius.circular(10.r),
                                        ),
                                        child: Image.asset(
                                          'assets/icons/Share.png',
                                          scale: 4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 315.h,
                          ),
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
                                  itemPadding: const EdgeInsets.symmetric(horizontal: 0.5),
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                  ),
                                  onRatingUpdate: (rating) {
                                    null;
                                  },
                                  ignoreGestures: true,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Wrap(
                                children: [
                                  Text(
                                    '${widget.lodgeData.ranking! / widget.lodgeData.reviews!}  (${widget.lodgeData.reviews!.toInt()})',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: kColorWhite,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              widget.lodgeData.name!,
                              style: TextStyle(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.w600,
                                color: kColorWhite,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      width: 375.w,
                      //height: 1500.h,
                      decoration: BoxDecoration(
                        color: kUILight3,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.r),
                          topRight: Radius.circular(40.r),
                        ),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            left: 282.w,
                            top: -25.h,
                            child: Container(
                              width: 54.w,
                              height: 54.h,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black26,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 287.w,
                            top: -20.h,
                            child: InkWell(
                              onTap: () {},
                              child: Container(
                                width: 44.w,
                                height: 44.h,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: kColorWhite,
                                ),
                                child: Image.asset(
                                  'assets/icons/Bookmark.png',
                                  scale: 4,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 29.h,
                                ),
                                Text(
                                  widget.lodgeData.name!,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                    color: kUIDark,
                                  ),
                                ),
                                Text(
                                  widget.lodgeData.location!,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w500,
                                    color: kUIDark,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Per person Per Night:  R${widget.lodgeData.price}',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        color: kUILight2,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 36.h,
                                ),
                                Text(
                                  'About Trip',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color: kUIDark,
                                  ),
                                ),
                                SizedBox(
                                  height: 21.h,
                                ),
                                Text(
                                  widget.lodgeData.description!,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    color: kUILight2,
                                  ),
                                ),
                                SizedBox(
                                  height: 29.h,
                                ),
                                Text(
                                  'What’s Included?',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color: kUIDark,
                                  ),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Row(
                                  children: [
                                    Visibility(
                                      visible: widget.lodgeData.amentities['wifi'] ? true : false,
                                      child: Column(
                                        children: [
                                          const Icon(
                                            Icons.wifi,
                                            color: kUIDark,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Wi-fi',
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                              color: kUIDark,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 31.w),
                                    Visibility(
                                      visible:
                                          widget.lodgeData.amentities['pet friendly'] ? true : false,
                                      child: Column(
                                        children: [
                                          const Icon(
                                            CupertinoIcons.paw,
                                            color: kUIDark,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Pets Friendly',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                              color: kUIDark,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 31.w),
                                    Visibility(
                                      visible:
                                          widget.lodgeData.amentities['cell reception'] ? true : false,
                                      child: Column(
                                        children: [
                                          const Icon(
                                            Icons.signal_cellular_4_bar,
                                            color: kUIDark,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Cell Reception',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                              color: kUIDark,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 26.h,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 186.61.w,
                                      height: 145.14.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.r),
                                        image: DecorationImage(
                                          image: NetworkImage(widget.lodgeData.photos![0]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12.39.w,
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          width: 140.w,
                                          height: 66.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.r),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                widget.lodgeData.photos![1],
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 13.h,
                                        ),
                                        Container(
                                          width: 140.w,
                                          height: 66.h,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.r),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                widget.lodgeData.photos![2],
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 14.h,
                                ),
                                FixedSecondary(
                                  buttonText: 'See all ${widget.lodgeData.photos!.length} photos',
                                  ontap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PicPreview(
                                                name: widget.lodgeData.name!,
                                                pics: widget.lodgeData.photos!)));
                                  },
                                ),
                                SizedBox(
                                  height: 30.h,
                                ),
                                SizedBox(
                                  height: 196.97.h,
                                  width: 339.w,
                                  child: GoogleMap(
                                    //ading location
                                    initialCameraPosition: CameraPosition(
                                        target: LatLng(
                                            widget.lodgeData.latitude!, widget.lodgeData.longitude!),
                                        zoom: 17.4746),
                                    markers: <Marker>{
                                      Marker(
                                          markerId: const MarkerId('0'),
                                          position: LatLng(
                                              widget.lodgeData.latitude!, widget.lodgeData.longitude!),
                                          infoWindow: InfoWindow(title: widget.lodgeData.name!))
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 40.h,
                                ),
                                SizedBox(
                                  height: 250.h,
                                  // decoration: BoxDecoration(
                                  //     border: Border.all(style: BorderStyle.solid, color: Colors.black),
                                  //     borderRadius: BorderRadius.circular(20)),
                                  child: VideoPlayer(videoPlayerController),
                                ),
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  ValueListenableBuilder(
                                      valueListenable: videoPlayerController,
                                      builder: (context, VideoPlayerValue value, child) {
                                        return Text(
                                          _videoDuration(value.position),
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        );
                                      }),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: SizedBox(
                                    height: 20,
                                    child: VideoProgressIndicator(videoPlayerController,
                                        allowScrubbing: true),
                                  )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  ValueListenableBuilder(
                                      valueListenable: videoPlayerController,
                                      builder: (context, VideoPlayerValue value, child) {
                                        return Text(
                                          _videoDuration(value.duration),
                                          style: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        );
                                      }),
                                ]),
                                SizedBox(
                                  height: 40.h,
                                  child: Center(
                                      child: InkWell(
                                    onTap: () {
                                      videoPlayerController.value.isPlaying
                                          ? videoPlayerController.pause()
                                          : videoPlayerController.play();
                                    },
                                    child: Container(
                                      color: Colors.blue,
                                      height: 40,
                                      width: 50,
                                      child: Center(
                                        child: videoPlayerController.value.isPlaying
                                            ? const Icon(Icons.pause)
                                            : const Icon(Icons.play_arrow),
                                      ),
                                    ),
                                  )),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Total cost',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                            color: kUILight6,
                                          ),
                                        ),
                                        Wrap(
                                          children: [
                                            Text(
                                              'R${widget.lodgeData.price!.toInt()}  ',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 24.sp,
                                                fontWeight: FontWeight.w700,
                                                color: kUIDark,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: 10.h),
                                              child: Text(
                                                '/ night',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 22.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: kUILight6,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Booking Dates:',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: kUILight6,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'From',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: kUILight6,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      DateFormat('MMM dd yyyy').format(widget.offersData.from!.toDate()),
                                      style: TextStyle(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w700,
                                        color: kUIDark,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'To',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: kUILight6,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 35,
                                    ),
                                    Text(
                                      DateFormat('MMM dd yyyy').format(widget.offersData.to!.toDate()),
                                      style: TextStyle(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w700,
                                        color: kUIDark,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Persons',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: kUILight6,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      widget.offersData.persons.toString(),
                                      style: TextStyle(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w700,
                                        color: kUIDark,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Want\nto know\nwithin',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: kUILight6,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      widget.offersData.deadLine!,
                                      style: TextStyle(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w700,
                                        color: kUIDark,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Offer\namount',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: kUILight6,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      '\$${widget.offersData.amount.toString()}',
                                      style: TextStyle(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w700,
                                        color: kUIDark,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Status',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                        color: kUILight6,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    Text(
                                      widget.offersData.status!,
                                      style: TextStyle(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w700,
                                        color: kUIDark,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                FixedPrimary(
                                    buttonText: 'Back',
                                    ontap: () {
                                      Navigator.pop(context);
                                    }),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  showBottomSheet() {
    showModalBottomSheet(
        backgroundColor: kColorWhite,
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(40.r),
          ),
        ),
        // ignore: sized_box_for_whitespace
        builder: (context) => StatefulBuilder(
              builder: (context, StateSetter setState) => SizedBox(
                height: 700.h,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.h,
                      vertical: 20.h,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 44.w,
                              height: 44.h,
                              decoration: const BoxDecoration(
                                color: kUILight8,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.close,
                                ),
                                color: kColorBlack,
                                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                              ),
                            ),
                            SizedBox(
                              width: 50.w,
                            ),
                            Text(
                              'Check Availability',
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w500,
                                color: kUIDark,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 570.h,
                          child: Column(
                            children: [
                              Expanded(
                                  child: SfDateRangePicker(
                                initialSelectedDates: getAlreadySelectedDates(),
                                monthViewSettings:
                                    DateRangePickerMonthViewSettings(blackoutDates: blackOutDays),
                                selectionMode: DateRangePickerSelectionMode.range,
                                controller: rangePickerController,
                                enablePastDates: false,
                                monthCellStyle: const DateRangePickerMonthCellStyle(
                                    blackoutDateTextStyle: TextStyle(
                                        color: Colors.red, decoration: TextDecoration.lineThrough)),
                                onSelectionChanged: (args) => {
                                  if (args.value is PickerDateRange)
                                    {
                                      setState(() {
                                        startDate = args.value.startDate ?? DateTime.now();
                                        endDate = args.value.endDate ?? DateTime.now();
                                        days = endDate!.difference(startDate!).inDays + 1;
                                        days = days <= 0 ? 1 : days;
                                      })
                                    }
                                },
                              )),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${DateFormat('MMM yyyy').format(startDate!)}: $days Days',
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        FixedPrimary(
                            buttonText: 'Next',
                            ontap: () {
                              if (days == 0) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ErrorDialog(
                                            title: 'Alert',
                                            message: 'Please select minimum 1 day',
                                            type: 'E',
                                            function: () {
                                              Navigator.pop(context);
                                            },
                                            buttontxt: 'Close')));
                              } else {
                                setState(() {
                                  finalOffer.text = (widget.lodgeData.price!.toInt() * days).toString();
                                });
                                Navigator.of(context).pop();
                                showOfferBottomSheet();
                              }
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  showOfferBottomSheet() {
    showModalBottomSheet(
        backgroundColor: kColorWhite,
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(40.r),
          ),
        ),
        // ignore: sized_box_for_whitespace
        builder: (context) => StatefulBuilder(
              builder: (context, StateSetter setState) => SizedBox(
                height: 700.h,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 18.w,
                        right: 18.w,
                        top: 25.h,
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 44.w,
                              height: 44.h,
                              decoration: const BoxDecoration(
                                color: kUILight8,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                ),
                                color: kColorBlack,
                              ),
                            ),
                            Text(
                              'Make Offer',
                              style: TextStyle(
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w500,
                                color: kUIDark,
                              ),
                            ),
                            Text(
                              '   ',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: kPrimary1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            '$persons Person(s)',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color: kUIDark,
                            ),
                          ),
                        ),
                        Slider(
                          label: persons.toString(),
                          min: 1,
                          max: 10,
                          divisions: 10,
                          activeColor: kPrimary1,
                          inactiveColor: const Color(0xFFD6E0FF),
                          value: persons.toDouble(),
                          onChanged: (double newValue) {
                            setState(() {
                              persons = newValue.toInt();
                              int offeramount = widget.lodgeData.price!.toInt() * persons * days;
                              finalOffer.text = offeramount.toString();
                            });
                          },
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'I need to know within',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color: kUIDark,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: checkbox24,
                                  onChanged: (value) {
                                    setState(() {
                                      checkbox24 = value!;
                                      checkbox48 = false;
                                      checkboxflex = false;
                                      noticeDays = '24h';
                                    });
                                  },
                                ),
                                //
                                Text(
                                  '24hrs',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: kUIDark,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: checkbox48,
                                  onChanged: (value) {
                                    setState(() {
                                      checkbox24 = false;
                                      checkbox48 = value!;
                                      checkboxflex = false;
                                      noticeDays = '48h';
                                    });
                                  },
                                ),
                                //
                                Text(
                                  '48hrs',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: kUIDark,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  value: checkboxflex,
                                  onChanged: (value) {
                                    setState(() {
                                      checkbox24 = false;
                                      checkbox48 = false;
                                      checkboxflex = value!;
                                      noticeDays = 'flexible';
                                    });
                                  },
                                ),
                                //
                                Text(
                                  'Flexible',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: kUIDark,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Total Offer Amount',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color: kUIDark,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(
                          width: 332.w,
                          height: 46.h,
                          child: TextField(
                            controller: finalOffer,
                            style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.w400, color: kUILight2),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.r),
                                borderSide: BorderSide(color: kFormStockColor, width: 1.w),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.r),
                                borderSide: BorderSide(color: kFormStockColor, width: 1.w),
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                              hintStyle: TextStyle(
                                  fontSize: 14.sp, fontWeight: FontWeight.w400, color: kUILight2),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        FixedPrimary(
                          buttonText: 'Make Offer',
                          ontap: () async {
                            //making new offer for this lodge
                            try {
                              if (finalOffer.text.isNotEmpty) {
                                final newOffer = FirebaseFirestore.instance.collection('offers').doc();
                                OffersData data = OffersData(
                                    amount: double.parse(finalOffer.text),
                                    companyid: widget.lodgeData.companyId,
                                    deadLine: noticeDays,
                                    from: Timestamp.fromDate(startDate!),
                                    id: newOffer.id,
                                    lodgeid: widget.lodgeData.id,
                                    persons: persons,
                                    status: 'pending',
                                    to: Timestamp.fromDate(endDate!),
                                    userid: FirebaseAuth.instance.currentUser!.uid,
                                    dateCreated: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                                    date: Timestamp.fromDate(DateTime.now()),
                                    paid: 'Not Paid',
                                    actualAmount: widget.lodgeData.price! * days * persons);
                                await newOffer.set(data.tomap());
                                // .whenComplete(() => showErrorDialogue(
                                //         context, 'Success', 'Your Offer is successfully submitted',
                                //         () {
                                //       Navigator.pop(context);
                                //     }))
                                // .then((value) => Navigator.push(context,
                                //     MaterialPageRoute(builder: (context) => const BottomBar())));
                                // // ignore: use_build_context_synchronously
                                // showErrorDialogue(
                                //     context, 'Success', 'Your Offer is successfully submitted', () {
                                //   Navigator.pop(context);
                                // });
                              }
                            } catch (e) {
                              // showErrorDialogue(context, 'Error', e.toString(), () {
                              //   Navigator.pop(context);
                              // });
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

//showing time of playing video
  String _videoDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final mintue = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      mintue,
      seconds,
    ].join(':');
  }

//getting bookings of current lodge
  Future getbookings() async {
    try {
      setState(() {
        isLoading = true;
      });
      QuerySnapshot bookings = await FirebaseFirestore.instance
          .collection('offers')
          .where('lodgeid', isEqualTo: widget.lodgeData.id)
          .where('to', isGreaterThan: Timestamp.fromDate(DateTime.now().add(const Duration(days: 1))))
          .where('status', isEqualTo: 'accepted')
          .get();
      if (bookings.docs.isNotEmpty) {
        //getting days from range of dates
        List<OffersData> offers =
            bookings.docs.map((e) => OffersData.fromMap(e.data() as Map<String, dynamic>)).toList();
        for (var offer in offers) {
          for (int i = 0;
              i <
                  DateTime.parse(offer.to!.toDate().add(const Duration(days: 1)).toString())
                      .difference(offer.from!.toDate())
                      .inDays;
              i++) {
            setState(() {
              blackOutDays.add(DateTime.parse(
                  DateFormat('yyyy-MM-dd').format(offer.from!.toDate().add(Duration(days: i)))));
            });
          }
        }
      }
    } catch (e) {
      // showErrorDialogue(context, 'Error', e.toString(), () {
      //   Navigator.pop(context);
      // });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  //getting already selected dates

  List<DateTime>? getAlreadySelectedDates() {
    Future.delayed(Duration.zero, () async {
      for (int i = 0;
          i <
              DateTime.parse(widget.offersData.to!.toDate().add(const Duration(days: 1)).toString())
                  .difference(widget.offersData.from!.toDate())
                  .inDays;
          i++) {
        setState(() {
          alreadySelectedDates!.add(DateTime.parse(
              DateFormat('yyyy-MM-dd').format(widget.offersData.from!.toDate().add(Duration(days: i)))));
        });
      }
    });

    return alreadySelectedDates!;
  }

//playing video
  void _playVideo({bool init = false}) {
    try {
      videoPlayerController = VideoPlayerController.network(widget.lodgeData.videoUrl!)
        ..addListener(() {
          setState(() {});
        })
        ..setLooping(true)
        ..initialize().then((value) => videoPlayerController.pause());
    } catch (e) {
      // showErrorDialogue(context, 'Error', e.toString(), () {
      //   Navigator.pop(context);
      // });
    }
  }
}
