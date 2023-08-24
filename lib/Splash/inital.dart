import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:langapp/screens/login_page.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../screens/register_page.dart';
import 'package:animate_do/animate_do.dart';

const Kbac = Color.fromARGB(255, 244, 244, 248);

class InitPage extends StatelessWidget {
  const InitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Kbac,
      body: Stack(children: [
        ZoomIn(
          child: Align(
            alignment: Alignment(3, -1.3),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 3000),
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                  // color: Color.fromRGBO(7, 248, 120, 0.004),
                  color: Color.fromARGB(146, 86, 230, 91),
                  borderRadius: BorderRadius.all(Radius.circular(200))),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 11,
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
                      fontSize: 30, fontWeight: FontWeight.bold, height: 1.3),
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
                          textStyle: TextStyle(fontSize: 15))
                    ]),
                  ),
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height / 5,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RegisterPage(),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                child: Center(
                  child: Text(
                    'Get started',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                ),
                width: MediaQuery.of(context).size.width / 3.5,
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
