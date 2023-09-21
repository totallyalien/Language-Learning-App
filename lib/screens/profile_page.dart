import 'dart:async';
import 'dart:typed_data';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:langapp/ResourcePage/Resource.dart';
import 'package:langapp/ResourcePage/additionallang.dart';
import 'package:langapp/chatroom/activity.dart';
import 'package:langapp/leaderboard/leaderboard.dart';
import 'package:langapp/progress_brain.dart/progress.dart';
import 'package:flutter_svg/svg.dart';
import 'package:langapp/screens/image.dart';
import 'package:langapp/screens/initallang.dart';
import 'package:langapp/screens/login_page.dart';
import 'package:langapp/utils/fire_auth.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../ResourcePage/resourcedownloading.dart';
import 'RLSW/Reading.dart';
import 'RLSW/Listening.dart';
import 'RLSW/Speaking.dart';
import 'RLSW/writing.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  final ColorScheme dync;

  const ProfilePage({
    required this.user,
    required this.dync,
  });

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with WidgetsBindingObserver {
  bool _isSendingVerification = false;
  bool _isSigningOut = false;

  late User _currentUser;
  int _index_body = 0;
  var _dphoto = null;
  late bool con;
  late var lang;

  //dropdown
  List<CoolDropdownItem<String>> dropdownItemList = [];

  List<List> pokemons = [
    [" ", " "]
  ];

  List<CoolDropdownItem<String>> pokemonDropdownItems = [];
  final pokemonDropdownController = DropdownController();
  final listDropdownController = DropdownController();

  // late Future<DocumentSnapshot> onetimebuilder;
  late Future<DocumentSnapshot> List_Data;
  late List progress_list;

  //activity
  Activity online_offline = Activity();
  late StreamSubscription<FGBGType> subscription;

  @override
  void initState() {
    var box = Hive.box("LocalDB");
    int n = box.get("current_lang");
    lang = box.get("Lang")[n.toString()]["Selected_lang"];
    print(box.get("Lang"));
    for (var i = 1; i <= box.get("Lang")["count_lang"]; i++) {
      pokemons.add([i, box.get("Lang")[i.toString()]["Selected_lang"][2]]);
    }
    for (var i = 0; i < pokemons.length; i++) {
      pokemonDropdownItems.add(
        CoolDropdownItem<String>(
            label: '${pokemons[i][1]}',
            icon: Container(
              height: 25,
              width: 25,
              child: pokemons[i][1] != " "
                  ? SvgPicture.asset("assets/flag/${pokemons[i][1]}.svg")
                  : Icon(
                      Icons.add,
                      color: widget.dync.primary,
                    ),
            ),
            value: pokemons[i][0].toString()),
      );
    }
    online_offline.setstatus(true);
    progress prag = progress();

    //activity
    FGBGEvents.stream.listen((event) {
      print(event);
      if (event == FGBGType.background) {
        online_offline.setstatus(false);
      }
    });

    progress_list = prag.progress_get();
    _currentUser = widget.user;

    CollectionReference users = FirebaseFirestore.instance.collection('user');
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

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

    LangAvail.removeWhere((element) => element.toString() == lang.toString());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> GridNav = [
      Reading(
        dync: widget.dync,
      ),
      listening(
        dync: widget.dync,
      ),
      Speaking(
        dync: widget.dync,
      ),
      Writing(
        dync: widget.dync,
      )
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
            duration: Duration(milliseconds: 1000),
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
                print(box.get("Lang"));
                _index_body = value;
              });
            },
          ),
        ),
        body: Stack(
          children: [
            [
              SafeArea(
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
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
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 15,
                                    ),
                                    CoolDropdown(
                                      controller: listDropdownController,
                                      dropdownList: pokemonDropdownItems,
                                      onChange: (dropdownItem) {
                                        print(dropdownItem);
                                        if (dropdownItem == " ") {
                                          showCupertinoModalPopup(
                                              context: context,
                                              builder: (context) {
                                                return AdditionalLang(
                                                    user: widget.user,
                                                    dync: widget.dync,
                                                    langAvail: LangAvail);
                                              });
                                          listDropdownController.close();
                                        } else {
                                          print(dropdownItem);
                                          ResourceBrain resourcebrain =
                                              ResourceBrain();
                                          resourcebrain
                                              .additionalangdownloadlang(
                                                  int.parse(dropdownItem));
                                          listDropdownController.close();

                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ResourceDownloading(
                                                user: _currentUser,
                                                dync: widget.dync,
                                              ),
                                            ),
                                          );
                                          // }
                                        }
                                      },
                                      resultOptions: ResultOptions(
                                        width: 50,
                                        render: ResultRender.none,
                                        icon: Container(
                                          width: 28,
                                          height: 28,
                                          child: SvgPicture.asset(
                                            'assets/flag/${lang[2]}.svg',
                                          ),
                                        ),
                                      ),
                                      dropdownOptions: DropdownOptions(
                                        width: 70,
                                      ),
                                      dropdownItemOptions: DropdownItemOptions(
                                        textStyle: TextStyle(
                                            color: widget.dync.primary),
                                        render: DropdownItemRender.all,
                                        selectedPadding: EdgeInsets.zero,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        selectedBoxDecoration: BoxDecoration(
                                          color: widget.dync.primaryContainer,
                                          border: Border(
                                            left: BorderSide(
                                              color: widget.dync.primary,
                                              width: 3,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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

                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                GridNav[Index]));
                                  },
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 60),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(100),
                                                topRight: Radius.circular(100),
                                                bottomLeft: Radius.circular(30),
                                                bottomRight:
                                                    Radius.circular(30)),
                                            color: widget.dync.background,
                                          ),
                                          margin: EdgeInsets.all(8),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              5.5,
                                        ),
                                      ),
                                      Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30)),
                                            // color: widget.dync.primaryContainer,
                                          ),
                                          margin: EdgeInsets.all(8),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              4,
                                          child: Column(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Image.asset(
                                                      GridIcon[Index]),
                                                ),
                                                flex: 4,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      Gridhead[Index],
                                                      style: TextStyle(
                                                          color: widget
                                                              .dync.primary,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3.0),
                                                      child: Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      18),
                                                          child:
                                                              LinearPercentIndicator(
                                                            animation: true,
                                                            lineHeight: 4,
                                                            backgroundColor: widget
                                                                .dync
                                                                .primaryContainer,
                                                            barRadius:
                                                                Radius.circular(
                                                                    20),
                                                            progressColor:
                                                                widget.dync
                                                                    .primary,
                                                            percent:
                                                                (progress_list[
                                                                        Index]) /
                                                                    50,
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
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
              ),
              ImageUploads(
                dync: widget.dync,
                user: widget.user,
                dphoto: _dphoto,
                lang: lang[0],
              )
            ][_index_body],
          ],
        )
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
