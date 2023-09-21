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

import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';

import '../../writingbrain/writingbrain.dart';

class Writing extends StatefulWidget {
  late ColorScheme dync;
  Writing({required this.dync, super.key});

  @override
  State<Writing> createState() => _WritingState();
}

class _WritingState extends State<Writing> {
  String headingcheck = "🐧🐧🐧🐧🐧";

  WritingBrain _writingBrain = WritingBrain();

  @override
  Widget build(BuildContext context) {
    GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();

    return Scaffold(
      backgroundColor: widget.dync.primary,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(8),
            color: widget.dync.primary,
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
                  color: widget.dync.primaryContainer,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: SfSignaturePad(
                minimumStrokeWidth: 5,
                maximumStrokeWidth: 5,
                strokeColor: widget.dync.primary,
                key: _signaturePadKey,
                backgroundColor: widget.dync.primaryContainer,
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

                _writingBrain.extractTextFromImage(
                    filePath);
              },
              child: Expanded(
                  child: Container(
                margin: EdgeInsets.all(20),
                height: MediaQuery.of(context).size.height / 11,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: widget.dync.inversePrimary),
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

