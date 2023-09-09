import 'package:cloud_firestore/cloud_firestore.dart';

class message {
  late String reciver;
  late String msg;
  late String sender;

  message({
    required this.sender,
    required this.reciver,
    required this.msg,
  });

  Map<String, dynamic> getFmsg() {
    return {
      "Sender": this.sender,
      "Reciver": this.reciver,
      "Message": this.msg,
      "TimeStamp": Timestamp.now()
    };
  }
}
