import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:langapp/ResourcePage/Resource.dart';
import 'package:langapp/screens/login_page.dart';
import 'package:langapp/utils/fire_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:langapp/screens/profile_page.dart';

import '../ResourcePage/resourcedownloading.dart';

class RegisterLang extends StatefulWidget {
  late ColorScheme dync;

  RegisterLang({required this.dync});

  @override
  _RegisterLang createState() => _RegisterLang();
}

class _RegisterLang extends State<RegisterLang> {
  bool _isSendingVerification = false;
  bool _isSigningOut = false;

  late User _currentUser;
  List<dynamic> LangAvail = [
    ["German", "de", "DE"],
    ["Japanese", "ja", "JP"],
    ["Russian", "ru", "RU"],
    ["Korean", "ko", "KR"],
    ["French", "fr", "PM"],
    ["Malayalam", "ml", "IN"],
    ["Tamil", "ta", "IN"],
    ["Hindi", "hi", "IN"],
    ["Kannada", "kn", "IN"],
  ];

  int selected = 0;

  @override
  void initState() {
    _currentUser = FirebaseAuth.instance.currentUser!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: widget.dync.inversePrimary,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(left: 18),
              decoration: BoxDecoration(
                  color: widget.dync.primary,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              height: MediaQuery.of(context).size.height / 4,
              width: double.infinity,
              child: Center(
                child: Text(
                  "What would you like to learn?",
                  style: TextStyle(fontSize: 27, color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.55,
              child: ListView.builder(
                  itemCount: LangAvail.length - 1,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        print("index");
                        setState(() {
                          selected = index;
                        });
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                width: double.infinity,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          "You have selected " +
                                              LangAvail[selected][0],
                                          style: TextStyle(
                                              color:
                                                  widget.dync.primaryContainer,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        ResourceBrain resourcebrain =
                                            ResourceBrain();
                                        await resourcebrain.addUserdetails(
                                            LangAvail[selected],
                                            _currentUser.email.toString());
                                        await resourcebrain
                                            .initaldownloadlang();

                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ResourceDownloading(
                                              user: _currentUser,
                                              dync: widget.dync,
                                            ),
                                          ),
                                        );
                                      },
                                      child: AbsorbPointer(
                                        child: Container(
                                          margin: EdgeInsets.all(10),
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            "Tap to continue",
                                            style: TextStyle(
                                                color: widget.dync.primary),
                                          ),
                                          decoration: BoxDecoration(
                                              color: widget.dync.background,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    color: widget.dync.primary,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20))),
                              );
                            });
                      },
                      child: AbsorbPointer(
                        child: Container(
                          padding: EdgeInsets.all(0),
                          decoration: BoxDecoration(
                              color: widget.dync.primary,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                  width: 2,
                                  color: Color.fromRGBO(31, 255, 134, 255))),
                          margin:
                              EdgeInsets.symmetric(horizontal: 50, vertical: 8),
                          height: MediaQuery.of(context).size.height / 15,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  LangAvail[index][0],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                width: 90,
                                height: 90,
                                padding: EdgeInsets.all(8),
                                child: SvgPicture.asset(
                                    "assets/flag/${LangAvail[index][2]}.svg"),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ));
  }
}
