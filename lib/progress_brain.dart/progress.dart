import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

class progress {
  User? user = FirebaseAuth.instance.currentUser;
  var box = Hive.box("LocalDB");

  int progress_get() {
    int last_prog = box.get("Progress");
    return last_prog;
  }

  void progress_update() {
    int last_prog = box.get("Progress");
    last_prog += 1;
    box.put("Progress", last_prog);
    this.update_firebase();
  }

  void update_firebase() {
    int last_prog = box.get("Progress");
    CollectionReference userBase =
        FirebaseFirestore.instance.collection('user');
    userBase.doc(this.user!.email.toString()).set({
      'Progress': last_prog,
    });
  }

  void get_firebase_progress() {
    CollectionReference userBase =
        FirebaseFirestore.instance.collection('user');
    userBase
        .doc(this.user!.email.toString())
        .get()
        .then((value) => box.put("Lang", (value.data())));
  }
}
