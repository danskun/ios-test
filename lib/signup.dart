import 'package:flutter/material.dart';
import 'package:skripsi/color/color_utils.dart';
import 'package:skripsi/data/service/api_service.dart';
import 'package:skripsi/reusable_widget.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final key = GlobalKey<FormState>();

  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _phoneTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Sign Up",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: Colors.white),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 90, 20, 0),
              child: Form(
                key: key,
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      'assets/JAKEATS.png',
                      height: 100, 
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    reusableTextField(
                        "Name", Icons.person, false, _nameTextController),
                    const SizedBox(
                      height: 15,
                    ),
                    reusableTextField(
                        "Email", Icons.email, false, _emailTextController),
                    const SizedBox(
                      height: 15,
                    ),
                    reusableTextField(
                        "Password", Icons.lock, true, _passwordTextController),
                    const SizedBox(
                      height: 15,
                    ),
                    reusableTextField(
                        "Phone", Icons.phone, false, _phoneTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    signInSignUpButton(context, false, () {
                      if (key.currentState!.validate()) {
                        APIService().registerUser(
                          context,
                          _nameTextController.text,
                          _emailTextController.text,
                          _passwordTextController.text,
                          _phoneTextController.text,
                        );
                      }
                    })
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
