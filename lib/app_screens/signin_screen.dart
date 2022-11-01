// ignore_for_file: prefer_const_constructors

import 'package:final_offer/app_screens/signup_screen.dart';
import 'package:final_offer/constants.dart';
import 'package:final_offer/provider/signin.dart';
import 'package:final_offer/widgets/bottom_navigation_bar.dart';
import 'package:final_offer/widgets/error.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();
    final key = GlobalKey<FormState>();
    signInwithEmail() async {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email.text, password: password.text);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          showMsg('Email not registered yet', Icon(Icons.close, color: Colors.red), context);
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

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/signin.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.6),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 70.h,
                          ),
                          Image.asset(
                            'assets/images/flogo.png',
                            width: 157.92.w,
                            height: 108.17.h,
                          ),
                          SizedBox(
                            height: 70.h,
                          ),
                          Form(
                              key: key,
                              child: Column(
                                children: [
                                  TextFormField(
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: kUILight3,
                                    ),
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: kUILight3),
                                      ),
                                      hintText: 'Email',
                                      hintStyle: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        color: kUILight3,
                                      ),
                                    ),
                                    controller: email,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'enter email';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 46.h),
                                  TextFormField(
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: kUILight3,
                                    ),
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: kUILight3),
                                      ),
                                      hintText: 'Password',
                                      hintStyle: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        color: kUILight3,
                                      ),
                                    ),
                                    controller: password,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'enter password';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 14.h),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      'Forgot password',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        color: kPrimary2,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 65.h),
                                  SizedBox(
                                    width: 339.w,
                                    height: 52.h,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        if (key.currentState!.validate()) {
                                          signInwithEmail();
                                        } else {
                                          showMsg('Provide a registered email',
                                              Icon(Icons.close, color: Colors.red), context);
                                        }
                                      },
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(104.r),
                                          ),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all(Color.fromARGB(40, 255, 255, 255)),
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
                                      child: Text('Sign in'),
                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 14.h,
                          ),
                          Text(
                            'or',
                            style: TextStyle(
                              fontSize: 14.sp,
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
                                  final googleProvider =
                                      Provider.of<SigninProvider>(context, listen: false);
                                  googleProvider.googleLogin();
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
                                  final fbProvider = Provider.of<SigninProvider>(context, listen: false);
                                  fbProvider.fbLogin();
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
                                onPressed: () {},
                                icon: Image.asset(
                                  'assets/icons/Apple.png',
                                  scale: 4,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 46.h,
                          ),
                          Wrap(
                            children: [
                              Text(
                                'Dont have an account ?',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: kUILight2,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignUp(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Sign up',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: kPrimary2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
