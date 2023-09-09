import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

var box = Hive.box("LocalDB");

class listening extends StatefulWidget {
  late ColorScheme dync;
  listening({required this.dync, super.key});

  @override
  State<listening> createState() => _listeningState();
}

class _listeningState extends State<listening> {
  late Future onetimebuilder;
  var lang = box.get("Lang")['Selected_lang']["lang1"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onetimebuilder = FirebaseFirestore.instance
        .collection('DataBase')
        .doc('Listening')
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          backgroundColor: widget.dync.primary,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                "Listening",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 1.28,
                child: FutureBuilder(
                  future: onetimebuilder,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Text("loading"));
                    } else {
                      if (snapshot.hasData && !snapshot.hasError) {
                        print(snapshot.data![lang[0]]);
                        return ListView.builder(
                            itemCount: snapshot.data![lang[0]].length,
                            itemBuilder: (context, Index) {
                              return GestureDetector(
                                onTap: () async {
                                  Uri url = Uri.parse(snapshot.data![lang[0]]
                                          [Index]
                                      .toString());
                                  print(url.toString());
                                  await launchUrl(url);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: widget.dync.primaryContainer,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  height:
                                      MediaQuery.of(context).size.height / 12,
                                  width: double.infinity,
                                  child: Center(
                                    child: Text(
                                      "Module " + (Index + 1).toString(),
                                      style: TextStyle(
                                          color: widget.dync.primary,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  // child: Text(snapshot.data![lang[0]][Index]),
                                ),
                              );
                            });
                      }
                    }
                    print(snapshot.data![lang[0]]);
                    return CircularProgressIndicator();
                  },
                ),
              ),
            ],
          )),
    );
  }
}
