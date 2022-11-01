import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_offer/models/users.dart';
import 'package:final_offer/widgets/bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class ValidateUser extends StatefulWidget {
  const ValidateUser({super.key});

  @override
  State<ValidateUser> createState() => _ValidateUserState();
}

class _ValidateUserState extends State<ValidateUser> {
  final userid = FirebaseAuth.instance.currentUser!.uid;
  bool isLoading = false;
  Users? userdata;
  String status = 'Waiting';

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: SafeArea(
          child: Scaffold(
              body: isLoading
                  ? const Center(
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Center(
                      child: Text(status),
                    )),

          // Center(
          //   child: Text('Validation for user active status needs to be implement'),
          // ),
        ));
  }

  Future getData() async {
    setState(() {
      isLoading = true;
    });
    await FirebaseMessaging.instance.subscribeToTopic('all');
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').where('id', isEqualTo: userid).get();
    setState(() {
      userdata = Users.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
      isLoading = false;
    });
    if (userdata!.status!) {
      // ignore: use_build_context_synchronously
      Navigator.push(context, MaterialPageRoute(builder: (context) => const BottomBar()));
    } else {
      setState(() {
        status = 'Your account has been blocked by admin';
      });
    }
  }
}
