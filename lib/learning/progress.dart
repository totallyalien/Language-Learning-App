import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:langapp/learning/learning.dart';

class IndProgress extends StatelessWidget {
  late String data;
  late ColorScheme dync;
  IndProgress({required this.dync, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: this.dync.onSecondaryContainer,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: Center(
                child: Text(
                  data,
                  style: TextStyle(color: this.dync.onSecondary, fontSize: 25),
                ),
              ),
              height: MediaQuery.of(context).size.height / 4,
              color: this.dync.primary,
            ),
            Expanded(
              child: AlignedGridView.count(
                  padding: EdgeInsets.all(8),
                  crossAxisCount: 2,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                  itemCount: Vocabulary.length,
                  itemBuilder: (context, Index) {
                    return GestureDetector(
                      onTap: () {
                        String temp = Vocabulary_Key[Index];
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => questionsUi(topic: temp,dync: this.dync,)));
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        height: MediaQuery.of(context).size.height / 5,
                        decoration: BoxDecoration(
                            color: this.dync.primaryContainer,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Center(
                          child: Text(
                            Vocabulary[Index],
                            style: TextStyle(
                                color: this.dync.secondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }),
            )
          ],
        ));
  }
}

List<String> Vocabulary = [
  "Basic words",
  "Numbers",
  "Colors",
  "Food and drinks",
  "Animals",
  "Common objects"
];

List<String> Vocabulary_Key = [
  "Basic_Words",
  "Numbers",
  "Colors_Data",
  "Food_Data",
  "Animals_Data",
  "Animals_Data"
];
