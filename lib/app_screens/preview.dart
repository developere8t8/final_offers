import 'package:final_offer/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PicPreview extends StatefulWidget {
  final List pics;
  final String name;
  const PicPreview({super.key, required this.name, required this.pics});

  @override
  State<PicPreview> createState() => _PicPreviewState();
}

class _PicPreviewState extends State<PicPreview> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          drawerScrimColor: Colors.transparent,
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: kColorWhite,
            title: Text(
              widget.name,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: kColorBlack,
              ),
            ),
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0.w),
              child: Column(
                children: [
                  ListView.builder(
                      itemCount: widget.pics.length,
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                          height: 300,
                          width: 300,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: NetworkImage(widget.pics[index]),
                                fit: BoxFit.cover,
                              )),
                        );
                      })
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async => false);
  }
}
