import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hive/hive.dart';
import 'package:langapp/progress_brain.dart/progress.dart';
import 'package:langapp/screens/profile_page.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

List list_data = [];
Map name_image = {};

class ResourceDownloading extends StatefulWidget {
  late User user;
  late ColorScheme dync;
  ResourceDownloading({required this.user, required this.dync});

  @override
  State<ResourceDownloading> createState() => _ResourceDownloadingState();
}

class _ResourceDownloadingState extends State<ResourceDownloading> {
  @override
  void initState() {
    // TODO: implement initState
    progress prog = progress();
    prog.get_firebase_progress();
    FirebaseFirestore.instance
        .collection('user')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) async {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        int sum = (data['Progress'])
            .fold(0, (previous, current) => previous + current);
        name_image[doc.reference.id.toLowerCase().toString()] =
            'https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/default-avatar.png';

        getFile(doc.reference.id.toLowerCase().toString());
        list_data.add(
            [doc.reference.id.toLowerCase().toString(), sum, data['name']]);
      });
    });

    print(list_data);
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ProfilePage(
              user: widget.user,
              dync: widget.dync,
              list_data: list_data,
              name_image: name_image),
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: widget.dync.primary,
      body: new Center(
          child: new LottieBuilder.asset("assets/animation_llgwflgi.json")),
    );
  }
}

Future<void> getFile(email) async {
  final destination = 'files/${email}';
  final ref = await firebase_storage.FirebaseStorage.instance
      .ref(destination)
      .child('file/');
  ref.getDownloadURL().then((url) {
    name_image[email] = url;
  }).catchError((error) {
    switch (error) {
      case 'storage/object-not-found':
        name_image[email] =
            'https://avatar-management--avatars.us-west-2.prod.public.atl-paas.net/default-avatar.png';
        break;
      case 'storage/unauthorized':
        break;
      case 'storage/canceled':
        break;

      case 'storage/unknown':
        break;
    }
  });
}
