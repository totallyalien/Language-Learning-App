import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:langapp/translator/translatorbrain.dart';
import 'package:line_icons/line_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';
import 'package:translator/translator.dart';

class TranslatorScreen extends StatefulWidget {
  late ColorScheme dync;
  TranslatorScreen({required this.dync, super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  String dropdownvalue = 'Hindi';
  String dropdownvalue2 = 'Hindi';
  TextEditingController topfield = TextEditingController();
  TextEditingController bottomfield = TextEditingController();
  GoogleTranslator translator = GoogleTranslator();

  bool islist = false;
  var langItems = [
    'Hindi',
    'German',
    'French',
    'Japanese',
    'Tamil',
    'Korean',
    "English"
  ];

  Map LangAvail = {
    "German": "de",
    "Japanese": "ja",
    "Russian": "ru",
    "French": "fr",
    "Tamil": "ta",
    "Hindi": "hi",
    "Korean": "ko",
    "English": "en"
  };
  FlutterTts flutterTts_2 = FlutterTts();
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = "";

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

  TranslatorBrain() {
    listenForPermissions();
    if (!_speechEnabled) {
      _initSpeech();
    }
  }

  String result = " Translated Text ";
  String hintText = " Enter text to be translated ";

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

  void startListening(lang_code) async {
    _speechToText.initialize();
    await _speechToText.listen(
      onResult: _onSpeechResult,
      listenFor: const Duration(seconds: 10),
      localeId: trcode[lang_code].toString(),
      cancelOnError: false,
      partialResults: true,
      listenMode: ListenMode.dictation,
    );
    print(_speechToText.isListening);
  }

  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = " ";
      _lastWords = "$_lastWords${result.recognizedWords} ";
      topfield.text = _lastWords;
      print(_lastWords);
    });
    // Translation testext =
    //     await translator.translate(_lastWords, to: lang_code);
  }

  @override
  Widget build(BuildContext context) {
    final kHeight = MediaQuery.of(context).size.height;
    final kWidth = MediaQuery.of(context).size.width;

    var kTextColor = widget.dync.background;
    var kTileListBG = widget.dync.onPrimaryContainer;
    var kTableBorder = widget.dync.primaryContainer;
    return Scaffold(
      backgroundColor: widget.dync.primary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(kWidth * 0.1),
          // child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // SizedBox(
                //   child: Text(
                //     'Translation Made Easy',
                //     style: Theme.of(context)
                //         .textTheme
                //         .titleLarge!
                //         .copyWith(color: kTextColor, fontSize: 34),
                //     textAlign: TextAlign.end,
                //   ),
                // ),
                SizedBox(
                  height: 0.01 * kHeight,
                ),
                SizedBox(
                  child: Text(
                    'TRANSLATE TO LANGUAGE OF YOUR PREFERRED CHOICE',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: kTextColor, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                ),
                SizedBox(
                  height: 0.01 * kHeight,
                ),
                Divider(
                  color: kTextColor,
                ),
                SizedBox(
                  height: 0.01 * kHeight,
                ),
                Form(
                  child: Column(
                    children: [
                      DropdownButtonFormField(
                        value: dropdownvalue,
                        dropdownColor: kTileListBG,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: kTextColor),
                        items: langItems
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (String? newValue) {
                          print(newValue);
                          setState(() {
                            dropdownvalue = newValue!;
                          });
                        },
                      ),
                      SizedBox(
                        height: 0.02 * kHeight,
                      ),
                      TextFormField(
                        controller: topfield,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: kTextColor,
                            ),
                        maxLines: 6,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: kTileListBG),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: kTableBorder),
                          ),
                          hintText: hintText,
                          hintStyle:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: kTextColor,
                                  ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    flutterTts_2.setLanguage(
                                        trcode[LangAvail[dropdownvalue]]
                                            .toString());
                                    print(trcode[LangAvail[dropdownvalue]]);
                                    flutterTts_2
                                        .speak(topfield.text.toString());
                                  },
                                  icon: Icon(
                                    Icons.speaker,
                                    color: kTableBorder,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      hintText = !islist
                                          ? "Listening ..."
                                          : "Enter text to be translated";

                                      islist = islist ? false : true;
                                    });
                                    islist
                                        ? startListening(
                                            LangAvail[dropdownvalue])
                                        : _stopListening();
                                  },
                                  icon: Icon(
                                    islist ? Icons.cancel : Icons.mic,
                                    color: kTableBorder,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              translator
                                  .translate(topfield.text,
                                      to: LangAvail[dropdownvalue2].toString())
                                  .then((value) {
                                print(value.toString());
                                setState(() {
                                  result = value.toString();
                                });
                              });
                            },
                            icon: Icon(
                              Icons.translate,
                              color: kTableBorder,
                            ),
                          ),
                        ],
                      ),
                      DropdownButtonFormField(
                        value: dropdownvalue2,
                        dropdownColor: kTileListBG,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: kTextColor),
                        items: langItems
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Row(
                                    children: [
                                      Text(
                                        e,
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                        onChanged: (String? value) {
                          setState(() {
                            dropdownvalue2 = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 0.02 * kHeight,
                ),
                Container(
                  width: double.maxFinite,
                  height: kHeight * 0.18,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: kTileListBG,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(3)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      result,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: kTextColor),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    IconButton(
                      onPressed: () {
                        flutterTts_2.setLanguage(
                            trcode[LangAvail[dropdownvalue2]].toString());
                        print(trcode[LangAvail[dropdownvalue2]]);
                        flutterTts_2.speak(result.toString());
                      },
                      icon: Icon(
                        Icons.speaker,
                        color: kTableBorder,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          // ),
        ),
      ),
    );
  }
}
