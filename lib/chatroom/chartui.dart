import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:langapp/chatroom/chatbrain.dart';
import 'package:langapp/chatroom/message.dart';
import 'package:timeago/timeago.dart' as timeago;

class chatUI extends StatefulWidget {
  late String reciver;
  late ColorScheme dync;
  late String reciver_name;

  chatUI(
      {required this.reciver,
      required this.dync,
      required this.reciver_name,
      super.key});

  @override
  State<chatUI> createState() => _chatUIState();
}

class _chatUIState extends State<chatUI> {
  late chatbrain brain;
  String? sender = FirebaseAuth.instance.currentUser!.displayName;

  TextEditingController messagefield = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    brain = chatbrain(reciver: widget.reciver);
    brain.chatroomid();
  }

  @override
  Widget build(BuildContext context) {
    return Placeholder(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: widget.dync.onPrimaryContainer,
          title: Text(widget.reciver_name),
        ),
        backgroundColor: widget.dync.primary,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                    stream: brain.recivemessage(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Loading ..");
                      }

                      if (snapshot.hasError) {
                        return Text("Error occured pls try later ..");
                      }
                      ScrollController scrollController = ScrollController();
                      if (snapshot.hasData) {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          scrollController.jumpTo(
                            scrollController.position.maxScrollExtent,
                          );
                        });
                      }


                      return ListView(
                        controller: scrollController,
                        shrinkWrap: true,
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          return Align(
                            alignment: data['Reciver'] != widget.reciver_name
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: Container(
                                margin: EdgeInsets.all(5),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    color:
                                        data['Reciver'] != widget.reciver_name
                                            ? widget.dync.primaryContainer
                                            : widget.dync.onPrimaryContainer),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "  " + data['Message'] + "  ",
                                      style: TextStyle(
                                          color: data['Reciver'] ==
                                                  widget.reciver_name
                                              ? widget.dync.primaryContainer
                                              : widget.dync.onPrimaryContainer),
                                    ),
                                    Text(
                                      timeago.format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              data['TimeStamp']
                                                  .millisecondsSinceEpoch),
                                          locale: 'en_short'),
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 8,
                                          color: data['Reciver'] ==
                                                  widget.reciver_name
                                              ? widget.dync.primaryContainer
                                              : widget.dync.onPrimaryContainer),
                                    )
                                  ],
                                )),
                          );
                        }).toList(),
                      );
                    }),
              ),
              Container(
                decoration: BoxDecoration(
                    color: widget.dync.onPrimaryContainer,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: widget.dync.inversePrimary,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        // width: MediaQuery.of(context).size.width / 1.3,
                        height: MediaQuery.of(context).size.width / 6.5,
                        child: TextField(
                          controller: messagefield,
                          cursorColor: widget.dync.primary,
                          style: TextStyle(color: widget.dync.primary),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(8)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                        decoration: BoxDecoration(
                            color: widget.dync.onPrimary,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: IconButton(
                            onPressed: () {
                              if (messagefield.text.isNotEmpty) {
                                message msg = message(
                                    sender: sender!,
                                    reciver: widget.reciver_name,
                                    msg: messagefield.text.toString());

                                messagefield.clear();

                                brain.sendmessage(msg.getFmsg());
                              }
                            },
                            icon: Icon(Icons.send))),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
