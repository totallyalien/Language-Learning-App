import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:langapp/learning/learning.dart';
import 'package:langapp/progress_brain.dart/progress.dart';

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

class IndProgress extends StatefulWidget {
  late String data;
  late ColorScheme dync;
  IndProgress({required this.dync, required this.data});
  @override
  State<IndProgress> createState() => _IndProgressState();
}

class _IndProgressState extends State<IndProgress> {
  progress prog = progress();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: widget.dync.onSecondaryContainer,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: Center(
                child: Text(
                  widget.data,
                  style:
                      TextStyle(color: widget.dync.onSecondary, fontSize: 25),
                ),
              ),
              height: MediaQuery.of(context).size.height / 4,
              color: widget.dync.primary,
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
                        prog.progress_get()[0] <= Index
                            ? {print("nothing")}
                            : {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => questionsUi(
                                          topic: Vocabulary_Key[Index],
                                          dync: widget.dync,
                                        )))
                              };
                      },
                      child: prog.progress_get()[0] <= Index
                          ? Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(10),
                                  height:
                                      MediaQuery.of(context).size.height / 5,
                                  decoration: BoxDecoration(
                                      color: widget.dync.primaryContainer,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Center(
                                    child: Text(
                                      Vocabulary[Index],
                                      style: TextStyle(
                                          color: widget.dync.secondary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                Opacity(
                                  opacity: 0.9,
                                  child: Container(
                                    margin: EdgeInsets.all(10),
                                    height:
                                        MediaQuery.of(context).size.height / 5,
                                    decoration: BoxDecoration(
                                        color: widget.dync.tertiary,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Center(
                                        child: Icon(
                                      Icons.lock,
                                      size: 30,
                                      color: widget.dync.primaryContainer,
                                    )),
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              margin: EdgeInsets.all(10),
                              height: MediaQuery.of(context).size.height / 5,
                              decoration: BoxDecoration(
                                  color: widget.dync.primaryContainer,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Center(
                                child: Text(
                                  Vocabulary[Index],
                                  style: TextStyle(
                                      color: widget.dync.secondary,
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
