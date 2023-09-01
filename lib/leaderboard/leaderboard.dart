import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:collection/collection.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class leaderboard extends StatefulWidget {
  late ColorScheme dync;
  late List list_data;
  late Map name_image;
  leaderboard(
      {required this.dync,
      required this.list_data,
      required this.name_image,
      super.key});

  @override
  State<leaderboard> createState() => _leaderboardState();
}

class _leaderboardState extends State<leaderboard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.name_image);
    print(widget.list_data);

    widget.list_data = sort_data(widget.list_data);

    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          child: Center(
              child: Text(
            "Leaderboard",
            style: TextStyle(fontSize: 30, color: Colors.white),
          )),
          height: MediaQuery.of(context).size.height / 10,
        ),
        Container(height: 600, child: lead_mem())
      ],
    );
  }

  List rank_colors = [
    Color.fromARGB(255, 241, 186, 20),
    Color.fromARGB(255, 231, 205, 205),
    Colors.brown
  ];

  ListView lead_mem() {
    return ListView.builder(
        itemCount: widget.list_data.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  index < 3
                      ? Container(
                          height: MediaQuery.of(context).size.height / 25,
                          width: MediaQuery.of(context).size.width / 13,
                          child: Icon(
                            Icons.shield,
                            color: rank_colors[index],
                          ),
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height / 25,
                          width: MediaQuery.of(context).size.width / 10,
                          child: Center(
                              child: Text(
                            (index + 1).toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: widget.dync.primary),
                          )),
                        ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      child: Image.network(widget
                          .name_image[widget.list_data[index][0].toString()]),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.6,
                    height: MediaQuery.of(context).size.width / 14,
                    child: Text(
                      widget.list_data[index][2],
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: widget.dync.primary,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    child: Text(
                      (widget.list_data[index][1].toString()),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: widget.dync.primary,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}

List sort_data(List liss) {
  for (int i = 0; i < liss.length; i++) {
    for (int j = 0; j <= i; j++) {
      if (liss[i][1] > liss[j][1]) {
        List temp = liss[j];
        liss[j] = liss[i];
        liss[i] = temp;
      }
    }
  }
  return (liss);
}
