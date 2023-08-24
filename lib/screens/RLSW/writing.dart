import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class Writing extends StatefulWidget {
  const Writing({super.key});

  @override
  State<Writing> createState() => _WritingState();
}

class _WritingState extends State<Writing> {
  String headingcheck = "🐧🐧🐧🐧🐧";
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.japanese);

  @override
  Widget build(BuildContext context) {
    GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.white,
            child: Center(
                child: Text(
              headingcheck,
              style: TextStyle(fontSize: 20),
            )),
            height: MediaQuery.of(context).size.height / 10,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: SfSignaturePad(
                minimumStrokeWidth: 3,
                maximumStrokeWidth: 6,
                strokeColor: Colors.blue,
                key: _signaturePadKey,
                backgroundColor: Colors.white,
              ),
            ),
          ),
          GestureDetector(
              onTap: () async {
                final signatureImage =
                    await _signaturePadKey.currentState?.toImage();
                final ByteData? byteData = await signatureImage?.toByteData(
                    format: ui.ImageByteFormat.png);
                final Uint8List? signatureBytes =
                    byteData?.buffer.asUint8List();

                // Save the signature image to the device's local storage
                final directory = await getApplicationDocumentsDirectory();
                final filePath = '${directory.path}/signature.png';
                final File file = File(filePath);
                await file.writeAsBytes(signatureBytes!);

                InputImage img = InputImage.fromFilePath(file.path.toString());
                print(img.filePath);
                final RecognizedText recognizedText =
                    await textRecognizer.processImage(img);

                String text = recognizedText.text;
                for (TextBlock block in recognizedText.blocks) {
                  final Rect rect = block.boundingBox;
                  final List<Point<int>> cornerPoints = block.cornerPoints;
                  final String text = block.text;
                  final List<String> languages = block.recognizedLanguages;

                  for (TextLine line in block.lines) {
                    // Same getters as TextBlock
                    for (TextElement element in line.elements) {
                      // Same getters as TextBlock
                      print(element.text);
                    }
                  }
                }
                setState(() {});
              },
              child: Expanded(
                  child: Container(
                height: MediaQuery.of(context).size.height / 11,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.black),
                child: Center(
                  child: Text(
                    "Check",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              )))
        ],
      ),
    );
  }
}


