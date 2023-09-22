import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:langapp/screens/login_page.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../screens/register_page.dart';
import 'package:animate_do/animate_do.dart';

class InitPage extends StatelessWidget {
  late ColorScheme dync;
  InitPage({required this.dync});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dync.primary,
      body: Stack(children: [
        ZoomIn(
          child: Align(
            alignment: Alignment(3, -1.3),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 3000),
              height: MediaQuery.of(context).size.height / 3.2,
              width: MediaQuery.of(context).size.height / 3.2,
              decoration: BoxDecoration(
                  color: dync.primaryContainer,
                  borderRadius: BorderRadius.all(Radius.circular(200))),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 8,
            ),
            Container(
              width: double.infinity,
              child: Container(
                padding: EdgeInsets.only(right: 40, left: 40),
                width: MediaQuery.of(context).size.width / 1.5,
                child: Text(
                  "To have another language is to possess a second soul"
                      .toUpperCase(),
                  style: TextStyle(
                      fontSize: 50, fontWeight: FontWeight.bold, height: 1.0),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 7,
                child: Container(
                  padding: EdgeInsets.only(right: 40, left: 40),
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Center(
                    child: AnimatedTextKit(repeatForever: true, animatedTexts: [
                      RotateAnimatedText(
                          "Try the Worlds leading online language tutorial center",
                          textStyle: TextStyle(fontSize: 15)),
                      RotateAnimatedText("世界をリードするオンライン言語チュートリアル センターを試してください",
                          textStyle: TextStyle(fontSize: 15)),
                      RotateAnimatedText(
                          "உலகின் முன்னணி ஆன்லைன் மொழி பயிற்சி மையத்தை முயற்சிக்கவும்",
                          textStyle: TextStyle(fontSize: 20))
                    ]),
                  ),
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height / 9,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RegisterPage(dync: this.dync),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: dync.onPrimary,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Center(
                  child: Text(
                    'Get started',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: dync.primary),
                  ),
                ),
                height: MediaQuery.of(context).size.height / 17,
              ),
            ),
          ],
        ),

        // ),
      ]),
    );
  }
}
