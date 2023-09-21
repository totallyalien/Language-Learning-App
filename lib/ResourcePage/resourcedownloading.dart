import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:translator/translator.dart';

class ResourceBrain {
  var box = Hive.box("LocalDB");
  CollectionReference dataBase =
      FirebaseFirestore.instance.collection('DataBase');
  CollectionReference userBase = FirebaseFirestore.instance.collection('user');
  GoogleTranslator translator = GoogleTranslator();
  User? user = FirebaseAuth.instance.currentUser;

  late List<dynamic> Question;

  Future<void> initaldownloadlang() async {
    box.put("current_lang", 1);

    await userBase.doc(user!.email.toString()).get().then((value) async {
      await box.put("Lang", value.data());
      await box.put("count_lang", await box.get("Lang")["count_lang"]);
      print(await box.get("Lang")["count_lang"]);
    });

    dataBase
        .doc('English_Data')
        .get()
        .then((value) => box.put("Data_downloaded", value.data()));

    dataBase
        .doc('LISTENING')
        .get()
        .then((value) => box.put('SPEAKING', value.data()));


    var lang = await box.get("Lang")!["1"]['Selected_lang'];
    print(lang);

    Map<dynamic, dynamic> RawData = box.get("Data_downloaded");
    RawData.forEach((key, value) async {
      Question = await translatefunction(RawData, key, translator, lang[1]);
      box.put(key.toString(), Question);
    });

    Map<dynamic, dynamic> SpeakingRawData = box.get("SPEAKING");
    SpeakingRawData.forEach((key, value) async {
      Question =
          await translatefunction(SpeakingRawData, key, translator, lang[1]);
      box.put(key.toString(), Question);
    });
  }

  Future<void> additionalangdownloadlang(int n) async {
    userBase.doc(user!.email.toString()).get().then((value) {
      box.put("Lang", value.data());
      box.put("count_lang", box.get("Lang")["count_lang"]);
    });

    dataBase
        .doc('English_Data')
        .get()
        .then((value) => box.put("Data_downloaded", value.data()));

    dataBase
        .doc('LISTENING')
        .get()
        .then((value) => box.put('SPEAKING', value.data()));
    var lang = await box.get("Lang")[n.toString()]['Selected_lang'];
    box.put("current_lang", n);

    Map<dynamic, dynamic> RawData = box.get("Data_downloaded");
    RawData.forEach((key, value) async {
      Question = await translatefunction(RawData, key, translator, lang[1]);
      box.put(key.toString(), Question);
    });

    Map<dynamic, dynamic> SpeakingRawData = box.get("SPEAKING");
    SpeakingRawData.forEach((key, value) async {
      Question =
          await translatefunction(SpeakingRawData, key, translator, lang[1]);
      box.put(key.toString(), Question);
    });
  }

  Future addUserdetails(List selectedlang, String email) async {
    await FirebaseFirestore.instance.collection("user").doc(email).set({
      "1": {
        'Selected_lang': selectedlang,
        'Progress': [0, 0, 0, 0],
        'name': user?.displayName.toString()
      },
      "count_lang": 1,
      "leader_board": 0
    });
    box.put("current_lang", 1);
  }

  Future appendlang(List selectedlang, String email, String name) async {
    box.put("count_lang", (box.get("count_lang") + 1));
    await FirebaseFirestore.instance.collection("user").doc(email).update({
      (box.get("count_lang")).toString(): {
        'Selected_lang': selectedlang,
        'Progress': [0, 0, 0, 0],
        'name': name
      },
      "count_lang": (box.get("count_lang"))
    });

    userBase.doc(user!.email.toString()).get().then((value) {
      box.put("Lang", value.data());
      box.put("current_lang", box.get("count_lang"));
      additionalangdownloadlang(box.get("current_lang"));
    });
  }

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
}
