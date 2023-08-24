import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:langapp/screens/login_page.dart';
import 'package:langapp/utils/fire_auth.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'RLSW/Reading.dart';
import 'RLSW/Listening.dart';
import 'RLSW/Speaking.dart';
import 'RLSW/writing.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({required this.user});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isSendingVerification = false;
  bool _isSigningOut = false;

  late User _currentUser;
  int _index_body = 0;

  late Future<DocumentSnapshot> onetimebuilder;
  late Future<DocumentSnapshot> List_Data;

  @override
  void initState() {
    _currentUser = widget.user;
    CollectionReference users = FirebaseFirestore.instance.collection('user');

    onetimebuilder = users.doc(_currentUser.email).get();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color.fromRGBO(27, 36, 48, 0),
          bottomNavigationBar: Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: GNav(
              duration: Duration(milliseconds: 500),
              tabBorderRadius: 20,
              tabMargin: EdgeInsets.all(8),
              color: Colors.black,
              tabBackgroundColor: Colors.black,
              activeColor: Colors.white,
              backgroundColor: Colors.white,
              tabs: [
                GButton(
                  icon: Icons.home,
                ),
                GButton(
                  icon: Icons.handshake,
                ),
                GButton(
                  icon: Icons.settings,
                ),
              ],
              onTabChange: (value) {
                setState(() {
                  _index_body = value;
                });
              },
            ),
          ),
          body: [
            SafeArea(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Text(
                                  "Hello ${(_currentUser.displayName.toString())},",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  textAlign: TextAlign.left,
                                ),
                                color: Colors.black,
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 50,
                              ),
                              Container(
                                child: Text(
                                  "Continue",
                                  style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  textAlign: TextAlign.left,
                                ),
                                color: Colors.black,
                              ),
                              getLangDet(onetimebuilder)
                            ],
                          ),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: AlignedGridView.count(
                            crossAxisCount: 2,
                            itemCount: Gridhead.length,
                            itemBuilder: (context, Index) {
                              return GestureDetector(
                                onTap: () {
                                  print(GridNav[Index]);

                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => GridNav[Index]));
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                      color: Colors.white,
                                    ),
                                    margin: EdgeInsets.all(8),
                                    height:
                                        MediaQuery.of(context).size.height / 4,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(14.0),
                                            child: Image.asset(GridIcon[Index]),
                                          ),
                                          flex: 2,
                                        ),
                                        Expanded(
                                          child: Text(
                                            Gridhead[Index],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                        )
                                      ],
                                    )),
                              );
                            }),
                        flex: 2,
                      )
                    ],
                  )
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  child: Center(
                      child: Text(
                    "Assessment",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  )),
                  height: MediaQuery.of(context).size.height / 10,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: ((context, index) {
                        return Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Colors.white,
                          ),
                          height: MediaQuery.of(context).size.height / 8.5,
                          child: Center(
                              child: Text("Test " + (index + 1).toString())),
                        );
                      })),
                )
              ],
            ),
            Center(
              child: Container(
                decoration: BoxDecoration(color: Colors.black),
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        'NAME: ${(_currentUser.displayName)!.toUpperCase()}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'EMAIL: ${(_currentUser.email)!.toUpperCase()}',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 16.0),
                    getLangDet(onetimebuilder),
                    SizedBox(height: 16.0),
                    _currentUser.emailVerified
                        ? Text(
                            'Email verified ',
                            style: TextStyle(color: Colors.green),
                          )
                        : GestureDetector(
                            onTap: () async {
                              setState(() {
                                _isSendingVerification = true;
                              });
                              await _currentUser.sendEmailVerification();
                              setState(() {
                                _isSendingVerification = false;
                              });
                            },
                            child: Text(
                              'Email not verified ? Tap to verify',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                    SizedBox(height: 16.0),
                    _isSendingVerification
                        ? CircularProgressIndicator()
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(width: 8.0),
                              IconButton(
                                icon: Icon(Icons.refresh),
                                onPressed: () async {
                                  User? user =
                                      await FireAuth.refreshUser(_currentUser);

                                  if (user != null) {
                                    setState(() {
                                      _currentUser = user;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                    SizedBox(height: 16.0),
                    _isSigningOut
                        ? CircularProgressIndicator()
                        : GestureDetector(
                            onTap: () async {
                              setState(() {
                                _isSigningOut = true;
                              });
                              await FirebaseAuth.instance.signOut();
                              
                              setState(() {
                                _isSigningOut = false;
                              });
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            },
                            child: Center(
                              child: Container(
                                child: Center(
                                  child: Text(
                                    'Sign out',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                height: 40,
                                width: 150,
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ][_index_body]
          // body: bodyList[_index_body],
          ),
    );
  }
}

List<dynamic> GridNav = [Reading(), Listening(), Speaking(), Writing()];

List<String> GridIcon = [
  "assets/reading.png",
  "assets/lis.png",
  "assets/speaking.png",
  "assets/writing.png"
];

List<String> Gridhead = ["Reading", "Listening", "Speaking", "Writing"];

List<String> heading = [
  "Order food, describe people",
  "Introduce yourself,order food and drink",
  "Talk about countries ,ask for directions",
  "Describe belongings ,talk about neighbours"
];

class getLangDet extends StatelessWidget {
  final Future<DocumentSnapshot> onetimebuilder;

  getLangDet(this.onetimebuilder);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: onetimebuilder,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Text(data['Selected_lang'][0] + "!",
              style: TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.left);
        }

        return Text("loading");
      },
    );
  }
}
