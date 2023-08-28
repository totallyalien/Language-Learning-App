import 'dart:collection';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:translator/translator.dart';


class SpeakingLearning extends StatefulWidget {
  late String cat;
  late ColorScheme dync;
  SpeakingLearning({required this.cat, required this.dync});

  @override
  State<SpeakingLearning> createState() => _SpeakingLearningState();
}

class _SpeakingLearningState extends State<SpeakingLearning> {
  double Progress = 0;
  List Questions = [];
  FlutterTts flutterTts = FlutterTts();
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = "";
  final TextEditingController _textController = TextEditingController();
  final translator = GoogleTranslator();

  int x = 0;
  late String lang_code;

  @override
  void initState() {
    var box = Hive.box("LocalDB");
    lang_code = box.get("Lang")['Selected_lang'][1];
    List QuestionRawData = box.get(widget.cat);
    List QuestionRawDataUn = box.get('SPEAKING')[widget.cat];
    var pos = 0;

    QuestionRawDataUn.forEach((element) {
      Questions.add([element, QuestionRawData[pos++]]);
    });

    super.initState();
    listenForPermissions();
    if (!_speechEnabled) {
      _initSpeech();
    }
  }

  void listenForPermissions() async {
    final status = await Permission.microphone.status;
    switch (status) {
      case PermissionStatus.denied:
        print(status);
        requestForPermission();
        break;
      case PermissionStatus.granted:
        break;
      case PermissionStatus.limited:
        break;
      case PermissionStatus.permanentlyDenied:
        break;
      case PermissionStatus.restricted:
        break;
      case PermissionStatus.provisional:
        // TODO: Handle this case.
        print("default");
        break;
    }
  }

  Future<void> requestForPermission() async {
    PermissionStatus x = await Permission.microphone.request();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
  }

  void _startListening() async {
    _speechToText.initialize();
    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 10),
      localeId: trcode[lang_code].toString(),
      cancelOnError: false,
      partialResults: false,
      listenMode: ListenMode.dictation,
    );
    print(_speechToText.isListening);
  }

  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() async {
      _lastWords = "$_lastWords${result.recognizedWords} ";
      // Translation testext =
      //     await translator.translate(_lastWords, to: lang_code);
      print(_lastWords);
      print(Questions[x][1]);
      bool aa = custom_compare(Questions[x][1], _lastWords);
      print(aa);
      if (aa) {
        print("valid");
        setState(() {
          if (Progress == 1.0) {
            Navigator.pop(context);
          }
          x += 1;
          Progress += 0.2;
          _lastWords = "";
        });
      } else {
        _textController.text = _lastWords;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: widget.dync.primary,
        body: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back_ios_new_sharp)),
                      LinearPercentIndicator(
                        progressColor: Colors.black,
                        percent: Progress,
                        width: MediaQuery.of(context).size.width / 1.5,
                      ),
                      Icon(Icons.report)
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Column(
                  children: [
                    Text(
                      Questions[x][0],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: widget.dync.onPrimary),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      Questions[x][1],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: widget.dync.primaryContainer,
                          fontSize: 18,
                          fontWeight: FontWeight.normal),
                    )
                  ],
                ),
              ),
              Container(
                height: 150,
                color: widget.dync.primary,
                padding: EdgeInsets.all(16),
                child: TextField(
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, color: Colors.red),
                  controller: _textController,
                  minLines: 6,
                  maxLines: 10,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    filled: true,
                    fillColor: widget.dync.primary,
                  ),
                ),
              ),
              Container(
                  child: Text(Questions[x][0],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        flutterTts.setLanguage(trcode[lang_code].toString());
                        flutterTts.speak(Questions[x][1]);
                      },
                      child: Container(
                        margin: EdgeInsets.all(15),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: widget.dync.primaryContainer,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Icon(
                          Icons.speaker,
                          color: widget.dync.primary,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _textController.text = "";
                        _startListening();
                      },
                      child: Container(
                        margin: EdgeInsets.all(15),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: widget.dync.primaryContainer,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Icon(
                          Icons.mic,
                          color: widget.dync.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ]),
      ),
    );
  }
}

Map<String, String> trcode = {
  "hr": "hr-HR",
  "ko": "ko-KR",
  "mr": "mr-IN",
  "ru": "ru-RU",
  "zh": "zh-TW",
  "hu": "hu-HU",
  "sw": "sw-KE",
  "th": "th-TH",
  "en": "en-US",
  "hi": "hi-IN",
  "fr": "fr-FR",
  "ja": "ja-JP",
  "ta": "ta-IN",
  "ro": "ro-RO"
};

bool custom_compare(String ques, String ans) {
  print("compare");
  int count = 0;
  print(ques);
  bool con = false;
  for (int i = 0; i < ans.length; i++) {
    if (ques.contains(ans[i])) {
      count++;
    }
    if (count > ques.length - 4) {
      con = true;
    }
  }
  return con;
}
