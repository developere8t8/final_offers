import 'package:final_offer/app_screens/home_screen.dart';
import 'package:final_offer/app_screens/signin_screen.dart';
import 'package:final_offer/app_screens/validate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/bottom_navigation_bar.dart';

class CheckAuth extends StatefulWidget {
  const CheckAuth({super.key});

  @override
  State<CheckAuth> createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          );
        } else {
          if (snapshot.hasData) {
            return const ValidateUser();
          } else if (snapshot.hasError) {
            return const SignIn();
          } else {
            return const SignIn();
          }
        }
      },
    )));
  }
}
