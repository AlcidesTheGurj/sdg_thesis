import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';
import 'package:fluttermoji/fluttermojiCustomizer.dart';
import 'package:fluttermoji/fluttermojiFunctions.dart';
import 'package:fluttermoji/fluttermojiSaveWidget.dart';
import 'package:fluttermoji/fluttermojiThemeData.dart';
import 'main.dart';
import 'package:firebase_database/firebase_database.dart' as firedatabase;

String avatarData = "";

class BlankPage extends StatefulWidget {
  BlankPage({Key? key}) : super(key: key);

  @override
  State<BlankPage> createState() => _BlankPageState();
}

class _BlankPageState extends State<BlankPage> {
  Future<void> _saveAvatar(BuildContext context) async {
    final value = await FluttermojiFunctions().encodeMySVGtoString();
    if (context.mounted && user!= null) {
      DatabaseReference ref = FirebaseDatabase.instance.ref('${user?.uid}');
      await ref.update({
        "avatar": value,
      });
      var dataSnapshot = await ref.get();
      var userObject = dataSnapshot.value!;
      print(userObject);
      print(user?.uid as String);

      setState(() {
        avatarData = value;
      });
    }
  }

  Future<void> _loadAvatar(BuildContext context) async {
    if (context.mounted && user!= null) {
      DatabaseReference ref = FirebaseDatabase.instance.ref('${user?.uid}/avatar');
      var dataSnapshot = await ref.get();
      var userObject = dataSnapshot.value!;
      //print(userObject);
      //print(user?.uid as String);

      //final value = FluttermojiFunctions().decodeFluttermojifromString(userObject as String);
      //print("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF");
      print(userObject as String);

      setState(() {
        avatarData = userObject;
      });
    }
  }

  //firedatabase.Query dbRef = firedatabase.FirebaseDatabase.instance.ref().child('user');

  @override
  void initState() {
    _loadAvatar(context);
    super.initState();
  }

  Widget circleAvatarWidget() {
    return
      CircleAvatar(
        radius: 90,
        backgroundColor: Colors.white70.withOpacity(0.9),
        child:
        ClipRRect(
          borderRadius: const BorderRadius.all(
            Radius.circular(
              90,
            ),
          ),
          child: SvgPicture.string(
            FluttermojiFunctions()
                .decodeFluttermojifromString(avatarData),
            height: 150,
            width: 100,
          ),
        ),
      );
      // FluttermojiCircleAvatar(
      //   backgroundColor: Colors.grey[200],
      //   radius: 100,
      // ));
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    return Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FluttermojiCircleAvatar(
                  backgroundColor: Colors.white70.withOpacity(0.25),
                  radius: 70,
                ),
                const Icon(Icons.arrow_right,size: 25),
                circleAvatarWidget(),
              ],
            ),
            SizedBox(
              width: min(600, _width * 0.85),
              child: Row(
                children: [
                  Text(
                    "Customize:",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  FluttermojiSaveWidget(
                    onTap: ()  {
                      _saveAvatar(context);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 30),
              child: FluttermojiCustomizer(
                scaffoldWidth: min(600, _width * 0.85),
                autosave: false,
                theme: FluttermojiThemeData(
                    boxDecoration: const BoxDecoration(boxShadow: [BoxShadow()])),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// class NewPage extends StatelessWidget {
//   const NewPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     var _width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 30),
//                 child: FluttermojiCircleAvatar(
//                   radius: 100,
//                   backgroundColor: Colors.grey[200],
//                 ),
//               ),
//               SizedBox(
//                 width: min(600, _width * 0.85),
//                 child: Row(
//                   children: [
//                     Text(
//                       "Customize:",
//                       style: Theme.of(context).textTheme.titleLarge,
//                     ),
//                     Spacer(),
//                     FluttermojiSaveWidget(),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 8.0, vertical: 30),
//                 child: FluttermojiCustomizer(
//                   scaffoldWidth: min(600, _width * 0.85),
//                   autosave: false,
//                   theme: FluttermojiThemeData(
//                       boxDecoration: BoxDecoration(boxShadow: [BoxShadow()])),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
