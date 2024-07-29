import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skripsi/color/color_utils.dart';
import 'package:skripsi/data/service/api_service.dart';
import 'package:skripsi/reusable_widget.dart';
import 'package:skripsi/signup.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final key = GlobalKey<FormState>();

  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              MediaQuery.of(context).size.height * 0.1,
              20,
              0,
            ),
            child: Form(
              key: key,
              child: Column(
                children: <Widget>[
                  logoWidget("assets/JAKEATS.png"),
                  SizedBox(
                    height: 10,
                  ),
                  reusableTextField(
                    "Enter Username",
                    Icons.person_outlined,
                    false,
                    _emailTextController,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  reusableTextField(
                    "Enter Password",
                    Icons.lock,
                    true,
                    _passwordTextController,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  signInSignUpButton(context, true, () async {
                    if (key.currentState!.validate()) {
                      await APIService().loginUser(
                        context,
                        _emailTextController.text,
                        _passwordTextController.text,
                      );
                    }
                  }),
                  signUpOption(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't Have Account?", style: TextStyle(color: Color(0xff828282))),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUp()),
            );
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}