import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pomodoro/service/auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final AuthService _auth = AuthService();

  bool _isObscurePass = true;
  bool _isObscureCPass = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff92A65F),
      appBar: AppBar(
        backgroundColor: Color(0xff446129),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "SignUp",
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                SizedBox(
                  height: 40,
                ),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.white),
                  cursorColor: Color(0xff446129),
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xff446129), width: 2.0),
                      ),
                      border: OutlineInputBorder(),
                      label: Text("Email"),
                      labelStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.white,
                      )),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _isObscurePass,
                  style: TextStyle(color: Colors.white),
                  cursorColor: Color(0xff446129),
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xff446129), width: 2.0),
                      ),
                      border: OutlineInputBorder(),
                      label: Text("Password"),
                      labelStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscurePass
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscurePass = !_isObscurePass;
                          });
                        },
                      )),
                ),
                SizedBox(
                  height: 15,
                ),
                TextField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _isObscureCPass,
                  style: TextStyle(color: Colors.white),
                  cursorColor: Color(0xff446129),
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xff446129), width: 2.0),
                      ),
                      border: OutlineInputBorder(),
                      label: Text("Confirm Password"),
                      labelStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscureCPass
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscureCPass = !_isObscureCPass;
                          });
                        },
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  child: MaterialButton(
                    onPressed: ()  {
                    
                        

                        _auth.signUpWithEmailAndPassword(emailController.text,
                            passwordController.text, context);

                       

                      
                    },
                    child: Text(
                      "SignUp",
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Color(0xff446129),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
