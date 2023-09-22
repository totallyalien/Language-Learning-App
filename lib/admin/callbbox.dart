import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class callbox extends StatefulWidget {
  late ColorScheme dync;
  callbox({required this.dync, super.key});

  @override
  State<callbox> createState() => _callboxState();
}

class _callboxState extends State<callbox> {
  @override
  Widget build(BuildContext context) {
    double kh = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Container(
          height: kh / 3,
          width: double.infinity,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(26.0),
              child: Row(
                children: [
                  Text(
                    "Hello \nAbilash",
                    style: TextStyle(
                        color: widget.dync.background,
                        fontSize: 50,
                        fontWeight: FontWeight.bold),
                  ),
                  Text("")
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 20),
          alignment: Alignment.centerLeft,
          child: Text(
            "Requested Students",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Divider(
            color: widget.dync.inversePrimary,
          ),
        ),
        SizedBox(
          height: kh / 3,
          child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Container(
                  color: widget.dync.,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                      ),
                      Column(
                        children: [Text("Name"), Text("Email")],
                      ),
                      Column(
                        children: [
                          Container(
                            child: Text("Accept"),
                          ),
                          Container(
                            child: Text("Decline"),
                          )
                        ],
                      )
                    ],
                  ),
                );
              }),
        )
      ],
    );
  }
}

List<String> data = [
  "Tamizh",
  "Tamizh",
  "Tamizh",
  "Tamizh",
  "Tamizh",
  "Tamizh",
  "Tamizh",
  "Tamizh"
];
