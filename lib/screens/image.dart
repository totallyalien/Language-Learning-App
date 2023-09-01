import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:langapp/screens/login_page.dart';
import 'package:langapp/utils/fire_auth.dart';
import 'package:path/path.dart';

class ImageUploads extends StatefulWidget {
  late ColorScheme dync;
  late final User user;
  late var dphoto;
  late var lang;

  ImageUploads(
      {Key? key,
      required this.dync,
      required this.user,
      required this.dphoto,
      required this.lang})
      : super(key: key);

  @override
  _ImageUploadsState createState() => _ImageUploadsState();
}

class _ImageUploadsState extends State<ImageUploads> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();
  bool _isSendingVerification = false;
  bool _isSigningOut = false;

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;
    final destination = 'files/${widget.user.email!.toLowerCase().toString()}';
    print("DESTTTTT" + destination);

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(_photo!);
      await getFile();
    } catch (e) {
      print('error occured');
    }
  }

  Future getFile() async {
    final destination = 'files/${widget.user.email}';
    final ref = await firebase_storage.FirebaseStorage.instance
        .ref(destination)
        .child('file/');
    await ref.getData().then((value) {
      print(value);
      setState(() {
        widget.dphoto = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.dync.primary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 3.5,
            width: double.infinity,
            decoration: BoxDecoration(
                color: widget.dync.primaryContainer,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    bottomRight: Radius.circular(60))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: widget.dphoto != null
                        ? Container(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100)),
                                child: Image.memory(
                                  widget.dphoto,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            height: MediaQuery.of(context).size.height / 6,
                            width: MediaQuery.of(context).size.height / 6,
                          )
                        : Container(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                  child: Container(
                                      color: widget.dync.primary,
                                      child: Icon(Icons.camera_alt))),
                            ),
                            height: MediaQuery.of(context).size.height / 6,
                            width: MediaQuery.of(context).size.height / 6,
                          )),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.user.displayName.toString(),
                      style: TextStyle(
                          color: widget.dync.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.lang,
                      style: TextStyle(
                          color: widget.dync.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          ),

          // widget.user.emailVerified
          //     ? Text(
          //         'Email verified ',
          //         style: TextStyle(color: Colors.green),
          //       )
          //     : GestureDetector(
          //         onTap: () async {
          //           setState(() {
          //             _isSendingVerification = true;
          //           });
          //           await widget.user.sendEmailVerification();
          //           setState(() {
          //             _isSendingVerification = false;
          //           });
          //         },
          //         child: Text(
          //           'Email not verified ? Tap to verify',
          //           style: TextStyle(color: Colors.red),
          //         ),
          //       ),

          // SizedBox(height: 16.0),
          // _isSendingVerification
          //     ? CircularProgressIndicator()
          //     : Row(
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           SizedBox(width: 8.0),
          //           IconButton(
          //             icon: Icon(Icons.refresh),
          //             onPressed: () async {
          //               User? user = await FireAuth.refreshUser(widget.user);

          //               if (user != null) {
          //                 setState(() {
          //                   widget.user = user;
          //                 });
          //               }
          //             },
          //           ),
          //         ],
          //       ),

          SizedBox(height: 10.0),
          _isSigningOut
              ? CircularProgressIndicator()
              : GestureDetector(
                  onTap: () async {
                    setState(() {
                      _isSigningOut = true;
                    });
                    await FirebaseAuth.instance.signOut();

                    setState(() {
                      _isSigningOut = false;
                    });
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => LoginPage(
                          dync: widget.dync,
                        ),
                      ),
                    );
                  },
                  child: Center(
                    child: Container(
                      child: Center(
                        child: Text(
                          'Sign out',
                          style: TextStyle(color: widget.dync.inversePrimary),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: widget.dync.onTertiaryContainer,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      height: 40,
                      width: 150,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
