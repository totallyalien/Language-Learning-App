import 'dart:typed_data';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:langapp/leaderboard/leaderboard.dart';
import 'package:langapp/progress_brain.dart/progress.dart';
import 'package:langapp/screens/image.dart';
import 'package:langapp/screens/login_page.dart';
import 'package:langapp/utils/fire_auth.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'RLSW/Reading.dart';
import 'RLSW/Listening.dart';
import 'RLSW/Speaking.dart';
import 'RLSW/writing.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  final ColorScheme dync;
  final List list_data;
  final Map name_image;

  const ProfilePage(
      {required this.user,
      required this.name_image,
      required this.dync,
      required this.list_data});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isSendingVerification = false;
  bool _isSigningOut = false;

  late User _currentUser;
  int _index_body = 0;
  var _dphoto = null;
  late bool con;
  late var lang;

  // late Future<DocumentSnapshot> onetimebuilder;
  late Future<DocumentSnapshot> List_Data;
  late List progress_list;

  @override
  void initState() {
    progress prag = progress();
    prag.get_firebase_progress();
    progress_list = prag.progress_get();
    _currentUser = widget.user;
    CollectionReference users = FirebaseFirestore.instance.collection('user');
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    // onetimebuilder = users.doc(_currentUser.email).get();

    Future getFile() async {
      final destination = 'files/${widget.user.email}';
      final ref = await firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');

      setState(() {
        ref.getData().then((value) {
          print(value);
          try {
            _dphoto = value!;
            con = true;
          } catch (e) {
            _dphoto = null;
            con = false;
          }
        });
      });
    }

    getFile();
    var box = Hive.box("LocalDB");
    lang = box.get("Lang")['Selected_lang'];
    print(lang);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> GridNav = [
      Reading(
        dync: widget.dync,
      ),
      Listening(),
      Speaking(
        dync: widget.dync,
      ),
      writing()
    ];

    return Scaffold(
        backgroundColor: widget.dync.primary,
        bottomNavigationBar: Container(
          margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
              color: widget.dync.inversePrimary,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: GNav(
            duration: Duration(milliseconds: 500),
            tabBorderRadius: 20,
            tabMargin: EdgeInsets.all(8),
            color: widget.dync.primary,
            tabBackgroundColor: widget.dync.primary,
            activeColor: Colors.white,
            backgroundColor: widget.dync.inversePrimary,
            tabs: [
              GButton(
                icon: Icons.home,
              ),
              GButton(
                icon: Icons.leaderboard,
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
                                    color: widget.dync.inversePrimary),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              child: Text(
                                "Continue\n${lang[0]}",
                                style: TextStyle(
                                    fontSize: 50,
                                    height: 1,
                                    fontWeight: FontWeight.bold,
                                    color: widget.dync.inversePrimary),
                                textAlign: TextAlign.left,
                              ),
                            ),
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
                                    color: widget.dync.primaryContainer,
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
                                        flex: 3,
                                      ),
                                      Expanded(
                                        child: Text(
                                          Gridhead[Index],
                                          style: TextStyle(
                                              color: widget.dync.primary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.all(14.0),
                                          child: LinearPercentIndicator(
                                            animation: true,
                                            barRadius: Radius.circular(20),
                                            progressColor: widget.dync.primary,
                                            percent:
                                                (progress_list[Index]) / 50,
                                          ),
                                        ),
                                      ),
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
          leaderboard(
            dync: widget.dync,
            name_image: widget.name_image,
            list_data: widget.list_data,
          ),
          ImageUploads(
            dync: widget.dync,
            user: widget.user,
            dphoto: _dphoto,
            lang: lang[0],
          )
        ][_index_body]
        // body: bodyList[_index_body],
        );
  }
}

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

class ClipPathClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 30);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstPoint.dx, firstPoint.dy);

    var secondControlPoint = Offset(size.width - (size.width / 4), size.height);
    var secondPoint = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondPoint.dx, secondPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
