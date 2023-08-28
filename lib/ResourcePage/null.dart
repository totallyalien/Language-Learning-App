import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:langapp/learning/learning.dart';
import 'package:langapp/learning/speakinglearning.dart';

class FileDownloading extends StatefulWidget {
  const FileDownloading({super.key});

  @override
  State<FileDownloading> createState() => _FileDownloadingState();
}

class _FileDownloadingState extends State<FileDownloading> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => check());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Center(child: CircularProgressIndicator()),
          ),
          Center(
            child: Text("Downloading resource files"),
          )
        ],
      ),
    );
  }
}

void check() {
  if (!false) {
    print("NOT NULL");
  }
}
