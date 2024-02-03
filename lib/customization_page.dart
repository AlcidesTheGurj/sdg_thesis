import 'dart:math';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttermoji/fluttermojiCircleAvatar.dart';
import 'package:fluttermoji/fluttermojiCustomizer.dart';
import 'package:fluttermoji/fluttermojiFunctions.dart';
import 'package:fluttermoji/fluttermojiSaveWidget.dart';
import 'package:fluttermoji/fluttermojiThemeData.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'main.dart';
//import 'package:firebase_database/firebase_database.dart' as firedatabase;

String avatarData = "";
bool lock = true;

class CustomizationPage extends StatefulWidget {
  const CustomizationPage({super.key});

  @override
  State<CustomizationPage> createState() => _CustomizationPageState();
}

class _CustomizationPageState extends State<CustomizationPage> {
  Future<void> _saveAvatar(BuildContext context) async {
    final value = await FluttermojiFunctions().encodeMySVGtoString();
    if (context.mounted && user != null) {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref('Players/${user?.uid}');
      await ref.update({
        "avatar": value,
      });
      //var dataSnapshot = await ref.get();
      //var userObject = dataSnapshot.value!;
      // print(userObject);
      // print(user?.uid as String);

      setState(() {
        avatarData = value;
      });
    }
  }

  Future<void> _loadAvatar(BuildContext context) async {
    if (context.mounted && user != null) {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref('Players/${user?.uid}/avatar');
      var dataSnapshot = await ref.get();
      var userObject = dataSnapshot.value!;
      //print(userObject);
      //print(user?.uid as String);

      //final value = FluttermojiFunctions().decodeFluttermojifromString(userObject as String);
      //print("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF");
      //print(userObject as String);

      setState(() {
        avatarData = userObject as String;
      });
    }
  }

  //firedatabase.Query dbRef = firedatabase.FirebaseDatabase.instance.ref().child('user');

  @override
  void initState() {
    _loadAvatar(context);
    if (user == null) {
      lock = true;
    }
    if (googleUser == true){
      lock = true;
    }
    super.initState();
  }

  Widget circleAvatarWidget() {
    return CircleAvatar(
      radius: 90,
      backgroundColor: const Color(0xffa21942).withOpacity(0.65),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(
            90,
          ),
        ),
        child: SvgPicture.string(
          FluttermojiFunctions().decodeFluttermojifromString(avatarData),
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
    var width = MediaQuery.of(context).size.width;
    return Stack(children: [
      Center(
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
                  const Icon(Icons.arrow_right, size: 25),
                  AvatarGlow(
                      startDelay: const Duration(milliseconds: 1000),
                      glowColor: Color(0xffa21942),
                      glowShape: BoxShape.circle,
                      glowRadiusFactor: 0.2,
                      curve: Curves.fastOutSlowIn,
                      child: circleAvatarWidget()),
                ],
              ),
              SizedBox(
                width: min(600, width * 0.85),
                child: Row(
                  children: [
                    Text(
                      "Customize:",
                      // style: Theme.of(context).textTheme.titleLarge,
                      style: GoogleFonts.roboto(fontSize: 20.0),
                    ),
                    const Spacer(),
                    // FluttermojiSaveWidget(
                    //   onTap: ()  {
                    //     _saveAvatar(context);
                    //   },
                    // ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 20),
                child: FluttermojiCustomizer(
                  scaffoldWidth: width,
                  autosave: false,
                  theme: FluttermojiThemeData(
                      boxDecoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.6),
                          spreadRadius: 6,
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        )
                      ]),
                      primaryBgColor: Colors.black,
                    secondaryBgColor: Colors.transparent,
                    iconColor: const Color(0xffdd1367),
                    labelTextStyle: GoogleFonts.roboto(fontSize: 20),
                    unselectedIconColor: Colors.white,
                    selectedIconColor: const Color(0xffdd1367),
                  ),
                ),
              ),
              Container(
                width: 110,
                height: 40,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: FluttermojiSaveWidget(
                  onTap: () {
                    _saveAvatar(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Icon(
                          Icons.save,
                          size: 25,
                        ),
                      ),
                      const SizedBox(
                        width: 3.0,
                      ),
                      Text(
                        "Save",
                        style: GoogleFonts.roboto(fontSize: 25.0),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Visibility(
        visible: lock,
        child: FractionallySizedBox(
            alignment: Alignment.center,
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.black.withOpacity(0.9)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  const Icon(
                    Icons.lock,
                    size: 70,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (user != null) {
                        Alert(
                          context: context,
                          style: AlertStyle(
                              backgroundColor: Colors.black,
                              animationDuration:
                                  const Duration(milliseconds: 300),
                              animationType: AnimationType.fromBottom,
                              descStyle:
                                  GoogleFonts.roboto(color: Colors.white)),
                          image: const Icon(
                            Icons.lock_open,
                            color: Color(0xff00689d),
                            size: 75,
                          ),
                          desc:
                              "Would you like Avatar Customization for 500 points?",
                          buttons: [
                            DialogButton(
                              onPressed: () => Navigator.pop(context),
                              width: 120,
                              color: Colors.red,
                              child: Text(
                                "No",
                                style: GoogleFonts.roboto(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ),
                            DialogButton(
                              onPressed: () {
                                setState(() {
                                  lock = false;
                                  Navigator.pop(context);
                                });
                              },
                              width: 120,
                              color: const Color(0xff00689d),
                              child: Text(
                                "Yes",
                                style: GoogleFonts.roboto(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ),
                          ],
                        ).show();
                      } else {
                        Alert(
                          context: context,
                          style: AlertStyle(
                              backgroundColor: Colors.black,
                              animationDuration:
                                  const Duration(milliseconds: 300),
                              animationType: AnimationType.fromBottom,
                              descStyle:
                                  GoogleFonts.roboto(color: Colors.white)),
                          image: const Icon(
                            Icons.info_outline,
                            color: Colors.red,
                            size: 75,
                          ),
                          desc:
                              "You need to Log In and earn 500 points to unlock this feature",
                          buttons: [
                            DialogButton(
                              onPressed: () => Navigator.pop(context),
                              width: 120,
                              color: Colors.red,
                              child: Text(
                                "OK",
                                style: GoogleFonts.roboto(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ),
                          ],
                        ).show();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff00689d),
                    ),
                    child: Text(
                      "Unlock",
                      style: GoogleFonts.roboto(fontSize: 25.0),
                    ),
                  )
                ],
              ),
            )),
      ),
    ]);
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
