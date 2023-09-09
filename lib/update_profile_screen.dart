import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:get/get.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA8DF8E),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            LineIcons.angleLeft,
            color: Colors.black,
          ),
        ),
        title: Text(
          'EDIT PROFILE',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: const Image(
                      image: AssetImage('assets/images/userprofile.jpg'),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: const Color(0xFFA8DF8E),
                    ),
                    child: const Icon(
                      LineIcons.camera,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
             Form(
              child: Column(
                children: [
                  TextField(
                    text: 'UserName',
                    icon: LineIcons.user,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextField(
                    text: 'E-Mail ID',
                    icon: LineIcons.user,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextField(
                    text: ' Phone Number',
                    icon: LineIcons.user,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA8DF8E),
                  side: BorderSide.none,
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextField extends StatelessWidget {
  const TextField({
    required this.text,
    required this.icon,
    super.key,
  });

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        label: Text(text),
        prefixIcon: Icon(icon),
        prefixIconColor: Colors.black,
        floatingLabelStyle: const TextStyle(
          color: Color.fromARGB(130, 0, 0, 0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(
            width: 2,
            color: Color.fromARGB(130, 0, 0, 0),
          ),
        ),
      ),
    );
  }
}