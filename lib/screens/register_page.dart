import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:langapp/screens/initallang.dart';
import 'package:langapp/screens/login_page.dart';
import 'package:langapp/utils/fire_auth.dart';
import 'package:langapp/utils/validator.dart';

class RegisterPage extends StatefulWidget {
  late ColorScheme dync;
  RegisterPage({required this.dync});
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  String mss = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusName.unfocus();
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    tophead(context),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 18,
                    ),
                    Form(
                      key: _registerFormKey,
                      child: Column(
                        children: <Widget>[
                          Text(
                            mss,
                            style: TextStyle(color: Colors.red),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: TextFormField(
                              controller: _nameTextController,
                              focusNode: _focusName,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 15),
                                  hintText: "Pick an username",
                                  hintStyle: TextStyle(fontSize: 16),
                                  focusedBorder: InputBorder.none,
                                  border: InputBorder.none),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: TextFormField(
                              controller: _emailTextController,
                              focusNode: _focusEmail,
                              validator: (value) => Validator.validateEmail(
                                email: value,
                              ),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 15),
                                  hintText: "Enter your email id",
                                  hintStyle: TextStyle(fontSize: 16),
                                  focusedBorder: InputBorder.none,
                                  border: InputBorder.none),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: TextFormField(
                              controller: _passwordTextController,
                              focusNode: _focusPassword,
                              obscureText: true,
                              validator: (value) => Validator.validatePassword(
                                password: value,
                              ),
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 15),
                                  hintStyle: TextStyle(fontSize: 16),
                                  hintText: "Enter a password",
                                  focusedBorder: InputBorder.none,
                                  border: InputBorder.none),
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          SizedBox(height: 32.0),
                          _isProcessing
                              ? CircularProgressIndicator()
                              : Row(
                                  children: [
                                    Expanded(
                                      child: signupbutton(context),
                                    ),
                                  ],
                                )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account ? "),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(
                                    dync: widget.dync,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Color.fromARGB(200, 139, 61, 241)),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector signupbutton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          _isProcessing = true;
        });

        if (_registerFormKey.currentState!.validate()) {
          User? user = await FireAuth.registerUsingEmailPassword(
            name: _nameTextController.text,
            email: _emailTextController.text,
            password: _passwordTextController.text,
          );

          if (user != null) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => RegisterLang(user: user,dync: widget.dync,),
              ),
              ModalRoute.withName('/'),
            );
          }

          setState(() {
            mss = "The account already exists for that email";
            _isProcessing = false;
          });
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height / 17,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: widget.dync.background,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        width: 150,
        child: Center(
          child: Text(
            'Sign up',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Container tophead(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      height: MediaQuery.of(context).size.height / 4,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
              image: AssetImage("assets/Studentbackpack.png"),
              alignment: Alignment.bottomRight)),
      child: Text(
        "Hi user \nRegister",
        style: TextStyle(fontSize: 36, color: Colors.white),
      ),
    );
  }
}
