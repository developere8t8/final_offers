import 'dart:convert';
import 'package:final_offer/models/fb.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_offer/models/users.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SigninProvider extends ChangeNotifier {
  //google signin function starts here
  final googleSignin = GoogleSignIn();
  GoogleSignInAccount? _user;

  GoogleSignInAccount? get user => _user;

  Future googleLogin() async {
    try {
      final googleUser = await googleSignin.signIn();
      if (googleUser == null) {
        return;
      } else {
        _user = googleUser;
      }
      final googleauth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleauth.accessToken,
        idToken: googleauth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot snapshot =
            await FirebaseFirestore.instance.collection('users').where('id', isEqualTo: user.uid).get();
        if (snapshot.docs.isEmpty) {
          final addUser = FirebaseFirestore.instance.collection('users').doc(user.uid);
          Users users = Users(
              address: '',
              contact: user.phoneNumber,
              date: Timestamp.fromDate(DateTime.now()),
              email: user.email,
              id: user.uid,
              imageurl: user.photoURL,
              name: user.displayName,
              password: '',
              status: true,
              offers: 0);

          addUser.set(users.toMap());
        } else {
          final addUser = FirebaseFirestore.instance.collection('users').doc(user.uid);
          addUser.update({
            //'contact': user.phoneNumber,
            'email': user.email,
            'name': user.displayName,
            'image': user.photoURL,
          });
        }
      }

      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  //google signin function ends here

  //logout function
  Future logOut() async {
    try {
      await googleSignin.disconnect();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      await FirebaseAuth.instance.signOut();
    } finally {
      await FirebaseAuth.instance.signOut();
    }
  }

  //fb function starts here
  Future fbLogin() async {
    final LoginResult result =
        await FacebookAuth.instance.login(permissions: (['email', 'public_profile']));
    final token = result.accessToken!.token;

    final graphResponse = await http.get(Uri.parse('https://graph.facebook.com/'
        'v2.12/me?fields=name,first_name,last_name,email&access_token=$token'));

    //final profile = jsonDecode(graphResponse.body);

    try {
      final AuthCredential facebookCredential =
          FacebookAuthProvider.credential(result.accessToken!.token);
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(facebookCredential);

      FaceBookLoginInfo fbinfo = FaceBookLoginInfo.fromMap(jsonDecode(graphResponse.body));

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot snapshot =
            await FirebaseFirestore.instance.collection('users').where('id', isEqualTo: user.uid).get();
        if (snapshot.docs.isEmpty) {
          final addUser = FirebaseFirestore.instance.collection('users').doc(user.uid);
          Users users = Users(
              address: '',
              contact: userCredential.user!.phoneNumber,
              date: Timestamp.fromDate(DateTime.now()),
              email: fbinfo.email,
              id: user.uid,
              imageurl: userCredential.user!.photoURL,
              name: '${fbinfo.fname} ${fbinfo.lname}',
              password: '',
              status: true,
              offers: 0);

          addUser.set(users.toMap());
        } else {
          final addUser = FirebaseFirestore.instance.collection('users').doc(user.uid);
          addUser.update({
            'contact': userCredential.user!.phoneNumber,
            'email': fbinfo.email,
            'name': '${fbinfo.fname} ${fbinfo.lname}',
            //'image': userCredential.user!.photoURL,
          });
        }
      }
    } catch (e) {
      throw e.toString();
    }
  }
  //fb function ends here
}
