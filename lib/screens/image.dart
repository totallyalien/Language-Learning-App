import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:langapp/screens/login_page.dart';
import 'package:langapp/update_profile_screen.dart';
import 'package:langapp/utils/fire_auth.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:get/get.dart';

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

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(_photo!);

      updateFile();
    } catch (e) {
      print('error occured');
    }
  }

  Future updateFile() async {
    final destination = 'files/${widget.user.email}';
    final ref = await firebase_storage.FirebaseStorage.instance
        .ref(destination)
        .child('file/');

    await ref.getDownloadURL().then((value) {
      FirebaseFirestore.instance
          .collection('user')
          .doc(widget.user.email)
          .update({"avtar_url": value.toString()});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.dync.primary,
      body: Container(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            SizedBox(
              height: 80,
            ),
            Stack(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: GestureDetector(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('user')
                              .doc(widget.user.email)
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: Text("Loading .."));
                            }

                            if (!snapshot.hasData) {
                              return Text("Error ..");
                            }

                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;

                            return data['avtar_url'] != null
                                ? Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(100)),
                                        child: Image.network(
                                          data['avtar_url'],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    height:
                                        MediaQuery.of(context).size.height / 6,
                                    width:
                                        MediaQuery.of(context).size.height / 6,
                                  )
                                : Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(100)),
                                          child: Container(
                                              color: widget.dync.primary,
                                              child: Icon(Icons.camera_alt))),
                                    ),
                                    height:
                                        MediaQuery.of(context).size.height / 6,
                                    width:
                                        MediaQuery.of(context).size.height / 6,
                                  );
                          })),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: widget.dync.primaryContainer,
                      ),
                      child: const Icon(
                        LineIcons.alternatePencil,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.user.displayName.toString(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              widget.user.email.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () => Get.to(() => const UpdateProfileScreen()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.dync.primaryContainer,
                  side: BorderSide.none,
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: widget.dync.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(),
            ProfileTile(
              dync: widget.dync,
              title: 'Settings',
              icon: LineIcons.cog,
              onPress: () {},
              endIcon: true,
            ),
            ProfileTile(
              dync: widget.dync,
              title: 'Billing Deatils',
              icon: LineIcons.wallet,
              onPress: () {},
              endIcon: true,
            ),
            ProfileTile(
              dync: widget.dync,
              title: 'Certification',
              icon: LineIcons.certificate,
              onPress: () {},
              endIcon: true,
            ),
            const Divider(),
            ProfileTile(
              dync: widget.dync,
              title: 'Information',
              icon: LineIcons.info,
              onPress: () {},
              endIcon: true,
            ),
            ProfileTile(
              dync: widget.dync,
              title: 'Logout',
              icon: LineIcons.alternateSignIn,
              onPress: () {},
              endIcon: false,
              textcolor: Colors.red,
            ),
          ],
        ),
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

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    required this.title,
    required this.icon,
    required this.onPress,
    required this.dync,
    this.endIcon = true,
    this.textcolor,
    super.key,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textcolor;
  final ColorScheme dync;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: this.dync.primaryContainer,
        ),
        child: Icon(
          icon,
          color: this.dync.primary,
        ),
      ),
      title: GestureDetector(
        onTap: () async {
          textcolor == null
              ? {}
              : {
                  await FirebaseAuth.instance.signOut(),

                  // box.deleteFromDisk(),

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LoginPage(
                        dync: this.dync,
                      ),
                    ),
                  )
                };
        },
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.apply(
                color:
                    textcolor == null ? this.dync.primaryContainer : textcolor,
              ),
        ),
      ),
      trailing: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: this.dync.inversePrimary,
              ),
              child: Icon(
                LineIcons.angleRight,
                color: this.dync.primary,
              ),
            )
          : null,
    );
  }
}

// Scaffold(
//       backgroundColor: widget.dync.primary,
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//           Container(
//             height: MediaQuery.of(context).size.height / 3.5,
//             width: double.infinity,
//             decoration: BoxDecoration(
//                 color: widget.dync.primaryContainer,
//                 borderRadius: BorderRadius.only(
//                     bottomLeft: Radius.circular(60),
//                     bottomRight: Radius.circular(60))),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 GestureDetector(
//                     onTap: () {
//                       _showPicker(context);
//                     },
//                     child: widget.dphoto != null
//                         ? Container(
//                             child: Padding(
//                               padding: const EdgeInsets.all(10),
//                               child: ClipRRect(
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(100)),
//                                 child: Image.memory(
//                                   widget.dphoto,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                             height: MediaQuery.of(context).size.height / 6,
//                             width: MediaQuery.of(context).size.height / 6,
//                           )
//                         : Container(
//                             child: Padding(
//                               padding: const EdgeInsets.all(10),
//                               child: ClipRRect(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(100)),
//                                   child: Container(
//                                       color: widget.dync.primary,
//                                       child: Icon(Icons.camera_alt))),
//                             ),
//                             height: MediaQuery.of(context).size.height / 6,
//                             width: MediaQuery.of(context).size.height / 6,
//                           )),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       widget.user.displayName.toString(),
//                       style: TextStyle(
//                           color: widget.dync.primary,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     Text(
//                       widget.lang,
//                       style: TextStyle(
//                           color: widget.dync.primary,
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),

//           // widget.user.emailVerified
//           //     ? Text(
//           //         'Email verified ',
//           //         style: TextStyle(color: Colors.green),
//           //       )
//           //     : GestureDetector(
//           //         onTap: () async {
//           //           setState(() {
//           //             _isSendingVerification = true;
//           //           });
//           //           await widget.user.sendEmailVerification();
//           //           setState(() {
//           //             _isSendingVerification = false;
//           //           });
//           //         },
//           //         child: Text(
//           //           'Email not verified ? Tap to verify',
//           //           style: TextStyle(color: Colors.red),
//           //         ),
//           //       ),

//           // SizedBox(height: 16.0),
//           // _isSendingVerification
//           //     ? CircularProgressIndicator()
//           //     : Row(
//           //         mainAxisSize: MainAxisSize.min,
//           //         children: [
//           //           SizedBox(width: 8.0),
//           //           IconButton(
//           //             icon: Icon(Icons.refresh),
//           //             onPressed: () async {
//           //               User? user = await FireAuth.refreshUser(widget.user);

//           //               if (user != null) {
//           //                 setState(() {
//           //                   widget.user = user;
//           //                 });
//           //               }
//           //             },
//           //           ),
//           //         ],
//           //       ),

//           SizedBox(height: 10.0),
//           _isSigningOut
//               ? CircularProgressIndicator()
//               : GestureDetector(
//                   onTap: () async {
//                     setState(() {
//                       _isSigningOut = true;
//                     });
//                     await FirebaseAuth.instance.signOut();

//                     setState(() {
//                       _isSigningOut = false;
//                     });
//                     Navigator.of(context).pushReplacement(
//                       MaterialPageRoute(
//                         builder: (context) => LoginPage(
//                           dync: widget.dync,
//                         ),
//                       ),
//                     );
//                   },
//                   child: Center(
//                     child: Container(
//                       child: Center(
//                         child: Text(
//                           'Sign out',
//                           style: TextStyle(color: widget.dync.inversePrimary),
//                         ),
//                       ),
//                       decoration: BoxDecoration(
//                           color: widget.dync.onTertiaryContainer,
//                           borderRadius: BorderRadius.all(Radius.circular(10))),
//                       height: 40,
//                       width: 150,
//                     ),
//                   ),
//                 ),
//         ],
//       ),
//     );
