// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:final_offer/app_screens/auth.dart';
import 'package:final_offer/app_screens/home_screen.dart';
import 'package:final_offer/constants.dart';
import 'package:final_offer/models/users.dart';
import 'package:final_offer/provider/signin.dart';
import 'package:final_offer/widgets/error.dart';
import 'package:final_offer/widgets/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  _StepperDemoState createState() => _StepperDemoState();
}

class _StepperDemoState extends State<SignUp> {
  TextEditingController email = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  XFile? img;

  bool isEnable = true;
  List<GlobalKey<FormState>> keys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];
  int _currentStep = 0;
  StepperType stepperType = StepperType.horizontal;
  bool lastField = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Text(
            'Register',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: kUIDark,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              CupertinoIcons.arrow_left,
              color: kUIDark,
            ),
          ),
        ),
        body: Column(
          children: [
            SizedBox(height: 40.h),
            Expanded(
              child: Theme(
                data: ThemeData(
                  canvasColor: kColorWhite,
                ),
                child: Stepper(
                  controlsBuilder: (BuildContext context, ControlsDetails details) {
                    return lastField
                        ? Column(
                            children: <Widget>[
                              SizedBox(height: 90.h),
                              Container(
                                width: 339.w,
                                height: 52.h,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.15),
                                      offset: Offset(0.0, 8.0),
                                      blurRadius: 24,
                                    ),
                                  ],
                                ),
                                child: OutlinedButton(
                                  onPressed: () {
                                    createUser();
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(104.r),
                                      ),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(kPrimary1),
                                    foregroundColor: MaterialStateProperty.all(kColorWhite),
                                    padding: MaterialStateProperty.all(
                                      EdgeInsets.symmetric(vertical: 14.h),
                                    ),
                                    textStyle: MaterialStateProperty.all(
                                      TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  child: Text('Continue'),
                                ),
                              ),
                              SizedBox(height: 12.h),
                              Wrap(
                                children: [
                                  Text(
                                    'By signing up you agree to our ',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: kUILight2,
                                    ),
                                  ),
                                  Text(
                                    'Terms & Conditions.',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: kPrimary2,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Column(
                            children: <Widget>[
                              SizedBox(height: 132.h),
                              Container(
                                width: 339.w,
                                height: 52.h,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.15),
                                      offset: Offset(0.0, 8.0),
                                      blurRadius: 24,
                                    ),
                                  ],
                                ),
                                child: OutlinedButton(
                                  onPressed: details.onStepContinue,
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(104.r),
                                      ),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(kPrimary1),
                                    foregroundColor: MaterialStateProperty.all(kColorWhite),
                                    padding: MaterialStateProperty.all(
                                      EdgeInsets.symmetric(vertical: 14.h),
                                    ),
                                    textStyle: MaterialStateProperty.all(
                                      TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  child: Text('Continue'),
                                ),
                              ),
                              SizedBox(
                                height: 14.h,
                              ),
                              Text(
                                'or',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: kUILight2,
                                ),
                              ),
                              SizedBox(
                                height: 14.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    onPressed: () {
                                      // final googleProvider =
                                      //     Provider.of<SigninProvider>(context, listen: false);
                                      // googleProvider.googleLogin();
                                      Navigator.pushReplacement(
                                          context, MaterialPageRoute(builder: (context) => CheckAuth()));
                                    },
                                    icon: Image.asset(
                                      'assets/icons/Google.png',
                                      scale: 4,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20.w,
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    onPressed: () {
                                      // final fbProvider =
                                      //     Provider.of<SigninProvider>(context, listen: false);
                                      // fbProvider.fbLogin();
                                      Navigator.pushReplacement(
                                          context, MaterialPageRoute(builder: (context) => CheckAuth()));
                                    },
                                    icon: Image.asset(
                                      'assets/icons/FB.png',
                                      scale: 4,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20.w,
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                          context, MaterialPageRoute(builder: (context) => CheckAuth()));
                                    },
                                    icon: Image.asset(
                                      'assets/icons/Apple.png',
                                      scale: 4,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                  },
                  type: stepperType,
                  elevation: 0,
                  physics: ScrollPhysics(),
                  currentStep: _currentStep,
                  onStepTapped: (step) => tapped(step),
                  onStepContinue: continued,
                  onStepCancel: cancel,
                  steps: <Step>[
                    Step(
                      title: Text(''),
                      content: Form(
                        key: keys[0],
                        child: Column(
                          children: <Widget>[
                            SignUpTxtField(
                              hintText: 'Email',
                              controller: email,
                              errorTxt: 'enter email',
                              validate: true,
                            ),
                            SizedBox(height: 46.h),
                            SignUpTxtField(
                              hintText: 'Contact Number',
                              controller: contact,
                              errorTxt: 'enter phone number',
                              validate: true,
                            ),
                            SizedBox(height: 19.h),
                            Wrap(
                              children: [
                                Text(
                                  'Have an account ?',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: kUILight2,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context, MaterialPageRoute(builder: (context) => CheckAuth()));
                                  },
                                  child: Text(
                                    'Sign in',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: kPrimary2,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 0 ? StepState.complete : StepState.disabled,
                    ),
                    Step(
                      title: Text(''),
                      content: Form(
                          key: keys[1],
                          child: Column(
                            children: <Widget>[
                              SignUpTxtField(
                                hintText: 'Name',
                                controller: name,
                                errorTxt: 'enter name',
                                validate: true,
                              ),
                              SizedBox(height: 46.h),
                              SignUpTxtField(
                                hintText: 'Address',
                                controller: address,
                                errorTxt: 'enter address',
                                validate: true,
                              ),
                              SizedBox(height: 19.h),
                              Wrap(
                                children: [
                                  Text(
                                    'Have an account ?',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: kUILight2,
                                    ),
                                  ),
                                  Text(
                                    'Sign in',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: kPrimary2,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 1 ? StepState.complete : StepState.disabled,
                    ),
                    Step(
                      title: Text(''),
                      content: Form(
                          key: keys[2],
                          child: Column(
                            children: <Widget>[
                              SignUpTxtField(
                                hintText: 'Password',
                                controller: password,
                                errorTxt: 'enter password',
                                obscure: true,
                                validate: true,
                              ),
                              SizedBox(height: 46.h),
                              SignUpTxtField(
                                hintText: 'Confirm Password',
                                controller: confirmPassword,
                                errorTxt: 'enter confirm password',
                                validate: true,
                                obscure: true,
                              ),
                              SizedBox(height: 19.h),
                              Wrap(
                                children: [
                                  Text(
                                    'Have an account ?',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: kUILight2,
                                    ),
                                  ),
                                  Text(
                                    'Sign in',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: kPrimary2,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 2 ? StepState.complete : StepState.disabled,
                    ),
                    Step(
                      title: Text(''),
                      content: Column(
                        children: <Widget>[
                          Text(
                            'Upload Picture',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: kUIDark,
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Stack(
                            children: [
                              DottedBorder(
                                  borderType: BorderType.Circle,
                                  color: kPrimary1,
                                  strokeWidth: 2.w,
                                  dashPattern: [10, 10],
                                  child: SizedBox(
                                    //height: 184.h,
                                    //width: 184.h,
                                    child: img != null
                                        ? CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 100,
                                            backgroundImage: FileImage(File(img!.path)),
                                          )
                                        : CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 100,
                                            backgroundImage: null,
                                          ),
                                  ) // child: SizedBox(

                                  ),
                              Positioned(
                                  left: 0,
                                  right: 140,
                                  top: 180,
                                  bottom: 0,
                                  child: IconButton(
                                      onPressed: () {
                                        showImageSource(context);
                                      },
                                      icon: Icon(
                                        CupertinoIcons.camera,
                                        color: Colors.blue,
                                      )))
                            ],
                          )
                        ],
                      ),
                      isActive: _currentStep >= 0,
                      state: _currentStep >= 3 ? StepState.complete : StepState.disabled,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  tapped(int step) {
    setState(() {
      _currentStep = step;
    });
  }

  continued() {
    if (_currentStep < 3) {
      if (_currentStep == 2 && password.text != confirmPassword.text) {
        showMsg(
            'password and confirm password did not match',
            Icon(
              Icons.close,
              color: Colors.red,
            ),
            context);
      } else {
        if (keys[_currentStep].currentState!.validate()) {
          setState(() {
            _currentStep += 1;
          });
        }
      }
      if (_currentStep == 3) {
        setState(() {
          lastField = true;
        });
      } else {
        setState(() {
          lastField = false;
        });
      }
    } else {
      null;
    }
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

//creating user
  Future createUser() async {
    try {
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email.text, password: password.text);
      //await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text);

      final newUser = FirebaseAuth.instance.currentUser;
      if (newUser != null) {
        final addUser = FirebaseFirestore.instance.collection('users').doc(newUser.uid);
        Users user = Users(
            address: address.text,
            contact: contact.text,
            date: Timestamp.fromDate(DateTime.now()),
            email: email.text,
            id: newUser.uid,
            imageurl: '',
            name: name.text,
            password: password.text,
            status: true,
            offers: 0);
        await addUser.set(user.toMap());

        //uploading profile image
        final firebaseStorage = FirebaseStorage.instance;
        if (img != null) {
          var snapshot = await firebaseStorage
              .ref()
              .child('/profile_picks/${newUser.uid}')
              .putFile(File(img!.path));
          var imgUrl = await snapshot.ref.getDownloadURL();
          final docuser = FirebaseFirestore.instance.collection('users').doc(newUser.uid);
          docuser.update({'image': imgUrl});
        }

        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CheckAuth()));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showMsg('Email already registers', Icon(Icons.close, color: Colors.red), context);
        tapped(0);
      } else if (e.code == 'weak-password') {
        showMsg('Week Password', Icon(Icons.close, color: Colors.red), context);
        tapped(2);
      } else {
        showMsg(e.code.toString(), Icon(Icons.close, color: Colors.red), context);
      }
    } catch (e) {
      showMsg(
          e.toString(),
          Icon(
            Icons.close,
            color: Colors.red,
          ),
          context);
    }
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
}
