// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_offer/app_screens/home_screen.dart';
import 'package:final_offer/constants.dart';
import 'package:final_offer/widgets/buttons.dart';
import 'package:final_offer/widgets/error.dart';
import 'package:final_offer/widgets/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../models/users.dart';
import '../widgets/bottom_navigation_bar.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool isLoading = false;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController newpassword = TextEditingController();
  XFile? img;
  final key = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser;
  Users? userdata;
  //get user detail

  Future getUser() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').where('id', isEqualTo: user!.uid).get();
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          userdata = Users.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
          name.text = userdata!.name!;
          email.text = userdata!.email!;
          phone.text = userdata!.contact != null ? userdata!.contact! : 'Phone Number';
          address.text = userdata!.address != null ? userdata!.address! : 'address';
          password.text = userdata!.password!;
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
    }
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: userdata != null
            ? Scaffold(
                resizeToAvoidBottomInset: true,
                appBar: AppBar(
                  centerTitle: true,
                  elevation: 0,
                  backgroundColor: kColorWhite,
                  title: Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: kColorBlack,
                    ),
                  ),
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => BottomBar()));
                    },
                    icon: Icon(
                      CupertinoIcons.arrow_left,
                      color: kUIDark,
                      size: 20,
                    ),
                  ),
                ),
                body: Form(
                    key: key,
                    child: ListView(
                      children: [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Positioned(
                                      child: img != null
                                          ? CircleAvatar(
                                              backgroundImage: FileImage(File(img!.path)),
                                              radius: 70.r,
                                            )
                                          : userdata!.imageurl!.isNotEmpty
                                              ? CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                    userdata!.imageurl!,
                                                  ),
                                                  radius: 70.r,
                                                )
                                              : CircleAvatar(
                                                  backgroundImage:
                                                      AssetImage('assets/images/splash_logo.png'),
                                                  radius: 70.r,
                                                ),
                                    ),
                                    Positioned(
                                        left: 80.w,
                                        child: InkWell(
                                          onTap: () {
                                            showImageSource(context);
                                          },
                                          child: Container(
                                              width: 41.w,
                                              height: 41.h,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: kUILight4,
                                              ),
                                              child: Icon(
                                                Icons.camera_alt,
                                                color: kPrimary1,
                                              )),
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  height: 25.h,
                                ),
                                Text(
                                  userdata!.name!,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w500,
                                    color: kUIDark,
                                  ),
                                ),
                                SizedBox(
                                  height: 47.h,
                                ),
                                SignUpTxtField(
                                  hintText: 'name',
                                  controller: name,
                                  validate: true,
                                  errorTxt: 'enter name',
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                SignUpTxtField(
                                  hintText: 'email',
                                  controller: email,
                                  validate: true,
                                  errorTxt: 'enter email',
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                SignUpTxtField(
                                  hintText: 'phone number',
                                  controller: phone,
                                  validate: true,
                                  errorTxt: 'enter phone number',
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                SignUpTxtField(
                                  hintText: 'address',
                                  controller: address,
                                  validate: true,
                                  errorTxt: 'enter address',
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                SignUpTxtField(
                                  hintText: 'current pasword',
                                  controller: password,
                                  validate: true,
                                  errorTxt: 'enter current password',
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                SignUpTxtField(
                                  hintText: 'new password',
                                  controller: newpassword,
                                  validate: true,
                                  errorTxt: 'new password can be same as current password',
                                ),
                                SizedBox(
                                  height: 62.h,
                                ),
                                isLoading
                                    ? SizedBox(
                                        width: 60,
                                        height: 50,
                                        child: LoadingIndicator(
                                          indicatorType: Indicator.ballPulse,
                                        ),
                                      )
                                    : FixedPrimary(
                                        buttonText: 'Save Changes',
                                        ontap: () {
                                          if (key.currentState!.validate()) {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            updateUser();
                                          }
                                        },
                                      ),
                                SizedBox(
                                  height: 51.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              )
            : Container(
                color: Colors.white,
                child: Center(
                    child: SizedBox(
                  height: 50,
                  width: 80,
                  child: LoadingIndicator(
                    indicatorType: Indicator.lineScalePulseOut,
                  ),
                )),
              ),
        onWillPop: () async => false);
  }

  //image sources
  showImageSource(BuildContext context) async {
    return await showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () async {
                    final image = await ImagePicker().pickImage(source: ImageSource.camera);

                    if (image == null) {
                      return;
                    } else {
                      setState(() {
                        img = image;
                      });
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  }),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Gallery'),
                onTap: () async {
                  final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (image == null) {
                    return;
                  } else {
                    setState(() {
                      img = image;
                    });
                  }
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  updateUser() async {
    final updateUser = FirebaseFirestore.instance.collection('users').doc(user!.uid);
    if (img != null) {
      final firebaseStorage = FirebaseStorage.instance;
      var snapshot =
          await firebaseStorage.ref().child('/profile_picks/${user!.uid}').putFile(File(img!.path));
      var imgUrl = await snapshot.ref.getDownloadURL();

      Users newUser = Users(
          address: address.text,
          contact: phone.text,
          date: userdata!.date,
          email: email.text,
          id: user!.uid,
          imageurl: imgUrl,
          name: name.text,
          password: newpassword.text,
          status: true,
          offers: userdata!.offers);
      await updateUser.update(newUser.toMap());
    } else {
      final updateUser = FirebaseFirestore.instance.collection('users').doc(user!.uid);
      Users newUser = Users(
          address: address.text,
          contact: phone.text,
          date: userdata!.date,
          email: email.text,
          id: user!.uid,
          imageurl: userdata!.imageurl,
          name: name.text,
          password: newpassword.text,
          status: true,
          offers: userdata!.offers);
      await updateUser.update(newUser.toMap());
    }
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomBar()));
  }
}
