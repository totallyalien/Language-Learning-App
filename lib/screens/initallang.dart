import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:langapp/ResourcePage/Resource.dart';
import 'package:langapp/screens/login_page.dart';
import 'package:langapp/utils/fire_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:langapp/screens/profile_page.dart';
import 'package:translator/translator.dart';

class RegisterLang extends StatefulWidget {
  final User user;

  const RegisterLang({required this.user});

  @override
  _RegisterLang createState() => _RegisterLang();
}

class _RegisterLang extends State<RegisterLang> {
  bool _isSendingVerification = false;
  bool _isSigningOut = false;

  late User _currentUser;
  List<dynamic> LangAvail = [
    ["German", "de"],
    ["Japanese", "ja"],
    ["Russian", "ru"],
    ["Korean", "ko"],
    ["French", "fr"],
    ["Malayalam", "ml"],
    ["Tamil", "ta"],
    ["Hindi", "hi"],
    ["Kannada", "kn"],
  ];

  bool selected_cond = false;
  int selected = 0;

  late Future<DocumentSnapshot> List_Data;
  GoogleTranslator translator = GoogleTranslator();
  late List<dynamic> Question;

  @override
  void initState() {
    _currentUser = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.only(left: 18),
          decoration: BoxDecoration(
              color: Colors.black,
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
          height: MediaQuery.of(context).size.height / 100,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 1.55,
          child: ListView.builder(
              itemCount: LangAvail.length - 1,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    print(index);
                    setState(() {
                      selected = index;
                      selected_cond = true;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(
                            width: 2,
                            color: Color.fromRGBO(31, 255, 134, 255))),
                    margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
                    height: MediaQuery.of(context).size.height / 15,
                    child: Center(
                        child: Text(
                      LangAvail[index][0],
                      style: TextStyle(color: Colors.white),
                    )),
                  ),
                );
              }),
        ),
        SizedBox(
          height: 10,
        ),
        Visibility(
          visible: selected_cond,
          child: GestureDetector(
            onTap: () async {
              addUserdetails(
                  LangAvail[selected], _currentUser.email.toString());
              if (_currentUser != null) {
                var box = Hive.box("LocalDB");
                CollectionReference dataBase =
                    FirebaseFirestore.instance.collection('DataBase');
                if (box.isOpen) {
                  List_Data = dataBase.doc('English_Data').get();
                  List_Data.then(
                      (value) => box.put("Data_downloaded", value.data()));
                  dataBase
                      .doc('LISTENING')
                      .get()
                      .then((value) => box.put('SPEAKING', value.data()));
                  Map<dynamic, dynamic> SpeakingRawData = box.get("SPEAKING");
                  print(SpeakingRawData);

                  Map<dynamic, dynamic> RawData = box.get("Data_downloaded");
                  box.put("Progress", 0);
                  box.put("Lang",
                      {'Selected_lang': LangAvail[selected], 'Progress': 0});

                  RawData.forEach((key, value) async {
                    Question = await translatefunction(RawData, key, translator,
                        LangAvail[selected][1].toString());
                    box.put(key.toString(), Question);
                  });

                  SpeakingRawData.forEach((key, value) async {
                    Question = await translatefunction(SpeakingRawData, key, translator,
                        LangAvail[selected][1].toString());
                    box.put(key.toString(), Question);

                  });
                }
                print(box.get("Numbers"));

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                        ResourceDownloading(user: _currentUser),
                  ),
                );
              }
            },
            child: Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height / 13,
                width: double.infinity,
                child: Center(
                  child: Text(
                    "You have selected " + LangAvail[selected][0],
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
              ),
            ),
          ),
        )
      ],
    ));
  }
}

Future addUserdetails(List selectedlang, String email) async {
  await FirebaseFirestore.instance.collection("user").doc(email).set({
    'Selected_lang': selectedlang,
    'Progress': 0,
  });
}

Future<List> translatefunction(RawData, key, translator, tolang) async {
  List TempQuestion = RawData[key];
  for (int i = 0; i < TempQuestion.length; i++) {
    await translator.translate(TempQuestion[i], to: tolang).then((value) {
      TempQuestion[i] = value.text;
    });
  }
  return TempQuestion;
}
