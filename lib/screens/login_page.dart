import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:langapp/ResourcePage/Resource.dart';
import 'package:langapp/screens/profile_page.dart';
import 'package:langapp/screens/register_page.dart';
import 'package:langapp/utils/fire_auth.dart';
import 'package:langapp/utils/validator.dart';
import 'package:translator/translator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  late ColorScheme dync;
  LoginPage({required this.dync});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Future<DocumentSnapshot> List_Data;
  GoogleTranslator translator = GoogleTranslator();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  late List<dynamic> Question;

  String mss = "";

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      var box = Hive.box("LocalDB");
      CollectionReference dataBase =
          FirebaseFirestore.instance.collection('DataBase');
      CollectionReference userBase =
          FirebaseFirestore.instance.collection('user');

      if (box.isOpen) {
        userBase
            .doc(user.email.toString())
            .get()
            .then((value) => box.put("Lang", value.data()));
        List_Data = dataBase.doc('English_Data').get();
        List_Data.then((value) => box.put("Data_downloaded", value.data()));

        dataBase
            .doc('LISTENING')
            .get()
            .then((value) => box.put('SPEAKING', value.data()));
        Map<dynamic, dynamic> SpeakingRawData = box.get("SPEAKING");
        box.put("Progress", 0);
        var lang = box.get("Lang")['Selected_lang'];

        Map<dynamic, dynamic> RawData = box.get("Data_downloaded");
        RawData.forEach((key, value) async {
          Question = await translatefunction(RawData, key, translator, lang[1]);
          box.put(key.toString(), Question);
        });

        SpeakingRawData.forEach((key, value) async {
          Question = await translatefunction(
              SpeakingRawData, key, translator, lang[1]);
          box.put(key.toString(), Question);
        });
      }

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ResourceDownloading(
            user: user,
            dync: widget.dync,
          ),
        ),
      );
    }
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        backgroundColor: widget.dync.onPrimaryContainer,
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: _initializeFirebase(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Padding(
                  padding: const EdgeInsets.only(left: 0, right: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      tophead(context, widget.dync.primary),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 18,
                      ),
                      Text(
                        mss,
                        style: TextStyle(color: Colors.red),
                      ),
                      formfield(context)
                    ],
                  ),
                );
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }

  Form formfield(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: widget.dync.inversePrimary,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: TextFormField(
              controller: _emailTextController,
              focusNode: _focusEmail,
              validator: (value) => Validator.validateEmail(
                email: value,
              ),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 15),
                  hintText: "Enter your email id",
                  hintStyle:
                      TextStyle(fontSize: 16, color: widget.dync.primary),
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none),
              style: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(height: 8.0),
          Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: widget.dync.inversePrimary,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: TextFormField(
              controller: _passwordTextController,
              focusNode: _focusPassword,
              obscureText: true,
              validator: (value) => Validator.validatePassword(
                password: value,
              ),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 5),
                  hintStyle:
                      TextStyle(fontSize: 16, color: widget.dync.primary),
                  hintText: " Your Password",
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none),
              style: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(height: 24.0),
          _isProcessing
              ? CircularProgressIndicator()
              : Row(
                  children: [
                    Expanded(child: signinbutton(context)),
                  ],
                ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don’t have an account ? "),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RegisterPage(
                          dync: widget.dync,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(color: Color.fromARGB(200, 139, 61, 241)),
                  )),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 6,
          ),
          GestureDetector(
            onTap: () async {
              signInWithGoogle().then((value) {
                print(value.additionalUserInfo);
                if (value.user != null) {
                  var box = Hive.box("LocalDB");
                  CollectionReference dataBase =
                      FirebaseFirestore.instance.collection('DataBase');
                  CollectionReference userBase =
                      FirebaseFirestore.instance.collection('user');

                  if (box.isOpen) {
                    userBase
                        .doc(value.user!.email.toString())
                        .get()
                        .then((value) => box.put("Lang", value.data()));
                    List_Data = dataBase.doc('English_Data').get();
                    List_Data.then(
                        (value) => box.put("Data_downloaded", value.data()));

                    dataBase
                        .doc('LISTENING')
                        .get()
                        .then((value) => box.put('SPEAKING', value.data()));
                    Map<dynamic, dynamic> SpeakingRawData = box.get("SPEAKING");

                    box.put("Data_downloaded_check", "true");
                    box.put("Progress", 0);
                    Map<dynamic, dynamic> RawData = box.get("Data_downloaded");
                    var lang = box.get("Lang")['Selected_lang'][1];
                    RawData.forEach((key, value) async {
                      Question = await translatefunction(
                          RawData, key, translator, lang[1]);
                      box.put(key.toString(), Question);
                    });

                    SpeakingRawData.forEach((key, value) async {
                      Question = await translatefunction(
                          SpeakingRawData, key, translator, lang[1]);
                      box.put(key.toString(), Question);
                    });
                  }

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => ResourceDownloading(
                        user: value.user!,
                        dync: widget.dync,
                      ),
                    ),
                  );
                }
              });
            },
            child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: widget.dync.inversePrimary,
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                height: MediaQuery.of(context).size.height / 13,
                child: Image.asset('assets/Google__G__Logo.svg.png')),
          )
        ],
      ),
    );
  }

  GestureDetector signinbutton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        _focusEmail.unfocus();
        _focusPassword.unfocus();

        if (_formKey.currentState!.validate()) {
          setState(() {
            _isProcessing = true;
          });

          User? user = await FireAuth.signInUsingEmailPassword(
            email: _emailTextController.text,
            password: _passwordTextController.text,
          );
          setState(() {
            mss = "Account not found | Invalid credentials";
          });

          setState(() {
            _isProcessing = false;
          });

          if (user != null) {
            var box = Hive.box("LocalDB");
            CollectionReference dataBase =
                FirebaseFirestore.instance.collection('DataBase');
            CollectionReference userBase =
                FirebaseFirestore.instance.collection('user');

            if (box.isOpen) {
              userBase
                  .doc(user.email.toString())
                  .get()
                  .then((value) => box.put("Lang", value.data()));
              List_Data = dataBase.doc('English_Data').get();
              List_Data.then(
                  (value) => box.put("Data_downloaded", value.data()));

              dataBase
                  .doc('LISTENING')
                  .get()
                  .then((value) => box.put('SPEAKING', value.data()));
              Map<dynamic, dynamic> SpeakingRawData = box.get("SPEAKING");

              box.put("Data_downloaded_check", "true");
              box.put("Progress", 0);
              Map<dynamic, dynamic> RawData = box.get("Data_downloaded");
              var lang = box.get("Lang")['Selected_lang'][1];
              RawData.forEach((key, value) async {
                Question =
                    await translatefunction(RawData, key, translator, lang[1]);
                box.put(key.toString(), Question);
              });

              SpeakingRawData.forEach((key, value) async {
                Question = await translatefunction(
                    SpeakingRawData, key, translator, lang[1]);
                box.put(key.toString(), Question);
              });
            }

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => ResourceDownloading(
                  user: user,
                  dync: widget.dync,
                ),
              ),
            );
          }
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height / 17,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: widget.dync.primary,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        width: 100,
        child: Center(
          child: Text(
            'Log In',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

Container tophead(BuildContext context, col) {
  return Container(
    padding: EdgeInsets.only(left: 20),
    height: MediaQuery.of(context).size.height / 3.4,
    width: double.infinity,
    alignment: Alignment.centerLeft,
    decoration: BoxDecoration(
        color: col,
        image: DecorationImage(
            image: AssetImage("assets/Studentbackpack.png"),
            scale: 1.4,
            alignment: Alignment.bottomRight)),
    child: Text(
      "Hi user\nWelcome\nback",
      style: TextStyle(fontSize: 36, color: Colors.white),
    ),
  );
}

// signinbutton(context),

Future<List> translatefunction(RawData, key, translator, tolang) async {
  List TempQuestion = RawData[key];
  for (int i = 0; i < TempQuestion.length; i++) {
    await translator
        .translate(TempQuestion[i], to: tolang.toString())
        .then((value) {
      TempQuestion[i] = value.text;
    });
  }
  return TempQuestion;
}

Future<UserCredential> signInWithGoogle() async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  return await FirebaseAuth.instance.signInWithCredential(credential);
}
