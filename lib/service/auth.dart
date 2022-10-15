import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomodoro/Screens/home.dart';
import 'package:pomodoro/Screens/loginScreens/Log_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //get uid
  Future<String> getCurrintUID() async {
    return await _auth.currentUser!.uid;
  }

// sign in with email and password
  Future logInWithEmailAndPassword(
      String email, String password, context) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("sorry there is an error")));
    }
  }

  // signUp with email and password
  Future signUpWithEmailAndPassword(
      String email, String password, context) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Navigator.pop(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ));
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("sorry there is an error")));
    }
  }

  // sign out
  Future signOut(context) async {
    try {
      await _auth.signOut();
      Navigator.pop(context);
    } catch (error) {
      print(error.toString());
      null;
    }
  }
}
