import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:translator/translator.dart';

class ResourceBrain {
  late List<dynamic> Question;
  late Future<DocumentSnapshot> List_Data;

  var box = Hive.box("LocalDB");
  CollectionReference dataBase =
      FirebaseFirestore.instance.collection('DataBase');
  GoogleTranslator translator = GoogleTranslator();

  Future download(var langsel) async {
    if (box.isOpen) {
      List_Data = dataBase.doc('English_Data').get();
      List_Data.then((value) => box.put("Data_downloaded", value.data()));
      dataBase
          .doc('LISTENING')
          .get()
          .then((value) => box.put('SPEAKING', value.data()));
      Map<dynamic, dynamic> SpeakingRawData = box.get("SPEAKING");

      Map<dynamic, dynamic> RawData = box.get("Data_downloaded");
      box.put("Progress", [0, 0, 0, 0]);
      box.put("Lang", {
        'Selected_lang': [langsel],
        'Progress': [0, 0, 0, 0]
      });

      RawData.forEach((key, value) async {
        Question = await translatefunction(
            RawData, key, translator, langsel[1].toString());
        box.put(key.toString(), Question);
      });

      SpeakingRawData.forEach((key, value) async {
        Question = await translatefunction(
            SpeakingRawData, key, translator, langsel[1].toString());
        box.put(key.toString(), Question);
      });
    }
  }

  Future addUserdetails(List selectedlang, String email, String name) async {
    await FirebaseFirestore.instance.collection("user").doc(email).set({
      'Selected_lang': {"lang1": selectedlang},
      'Progress': [0, 0, 0, 0],
      'name': name
    }).then((value) => printInfo());
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
}

class ResourceBrainLogin {
  var box = Hive.box("LocalDB");
  CollectionReference dataBase =
      FirebaseFirestore.instance.collection('DataBase');
  CollectionReference userBase = FirebaseFirestore.instance.collection('user');
  GoogleTranslator translator = GoogleTranslator();
  User? user = FirebaseAuth.instance.currentUser;

  late List<dynamic> Question;
  late Future<DocumentSnapshot> List_Data;

  void Googledownload(var value) {
    if (box.isOpen) {
      userBase
          .doc(value.user!.email.toString())
          .get()
          .then((value) => box.put("Lang", value.data()));
      List_Data = dataBase.doc('English_Data').get();
      List_Data.then((value) => box.put("Data_downloaded", value.data()));

      dataBase
          .doc('LISTENING')
          .get()
          .then((value) => box.put('SPEAKING', value.data()));
      Map<dynamic, dynamic> SpeakingRawData = box.get("SPEAKING");

      box.put("Data_downloaded_check", "true");
      box.put("Progress", box.get('Lang')['Progress']);
      Map<dynamic, dynamic> RawData = box.get("Data_downloaded");
      var lang = box.get("Lang")['Selected_lang'][1];
      RawData.forEach((key, value) async {
        Question = await translatefunction(RawData, key, translator, lang[1]);
        box.put(key.toString(), Question);
      });

      SpeakingRawData.forEach((key, value) async {
        Question =
            await translatefunction(SpeakingRawData, key, translator, lang[1]);
        box.put(key.toString(), Question);
      });
    }
  }

  void signindownload() async {
    if (box.isOpen) {
      userBase
          .doc(user!.email.toString())
          .get()
          .then((value) => box.put("Lang", value.data()));
      List_Data = dataBase.doc('English_Data').get();
      List_Data.then((value) => box.put("Data_downloaded", value.data()));

      dataBase
          .doc('LISTENING')
          .get()
          .then((value) => box.put('SPEAKING', value.data()));
      Map<dynamic, dynamic> SpeakingRawData = box.get("SPEAKING");

      box.put("Data_downloaded_check", "true");
      box.put("Progress", box.get('Lang')['Progress']);
      Map<dynamic, dynamic> RawData = box.get("Data_downloaded");
      var lang = box.get("Lang")['Selected_lang'][1][0];
      RawData.forEach((key, value) async {
        Question = await translatefunction(RawData, key, translator, lang[1]);
        box.put(key.toString(), Question);
      });

      SpeakingRawData.forEach((key, value) async {
        Question =
            await translatefunction(SpeakingRawData, key, translator, lang[1]);
        box.put(key.toString(), Question);
      });
    }
  }

  void initadownload() {
    if (box.isOpen) {
      userBase
          .doc(user!.email.toString())
          .get()
          .then((value) => box.put("Lang", value.data()));
      List_Data = dataBase.doc('English_Data').get();
      List_Data.then((value) => box.put("Data_downloaded", value.data()));

      dataBase
          .doc('LISTENING')
          .get()
          .then((value) => box.put('SPEAKING', value.data()));
      Map<dynamic, dynamic> SpeakingRawData = box.get("SPEAKING");
      box.put("Progress", box.get('Lang')['Progress']);
      var lang = box.get("Lang")['Selected_lang']['lang1'];
      print(lang);

      Map<dynamic, dynamic> RawData = box.get("Data_downloaded");
      RawData.forEach((key, value) async {
        Question = await translatefunction(RawData, key, translator, lang[1]);
        box.put(key.toString(), Question);
      });

      SpeakingRawData.forEach((key, value) async {
        Question =
            await translatefunction(SpeakingRawData, key, translator, lang[1]);
        box.put(key.toString(), Question);
      });
    }
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
