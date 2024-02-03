import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttermoji/fluttermojiFunctions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../auth.dart';
import '../customization_page.dart';

class GuestPage extends StatefulWidget {
  GuestPage({Key? key}) : super(key: key);

  @override
  State<GuestPage> createState() => _GuestPageState();
}

class _GuestPageState extends State<GuestPage> {
  final User? user = Auth().currentUser;

  @override
  void initState() {
    _loadAvatar(context);
    super.initState();
  }

  Widget circleAvatarWidget() {
    return CircleAvatar(
      radius: 90,
      // backgroundColor: const Color(0xff7c1c43).withOpacity(0.65),
      backgroundColor: Colors.white.withOpacity(0.4),
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

  // Widget _userUid() {
  Future<void> signOut() async {
    await Auth().signOut();
  }

  List<bool> hm = [
    false,
    false,
    true,
    false,
    true,
    true,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(alignment: Alignment.center, children: [
              circleAvatarWidget(),
              CircularPercentIndicator(
                radius: 90.0,
                lineWidth: 10.0,
                percent: 0.80,
                center: Text("test",
                    style: GoogleFonts.roboto(
                        fontSize: 15.5, color: Colors.white)),
                progressColor: Colors.purple,
                backgroundColor: Colors.black,
              ),
            ]),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Badges:", style: GoogleFonts.roboto(fontSize: 24.0)),
                ],
              ),
            ),
            /*Image.asset("images/test.png"),
                    SizedBox(
                      width: 10,
                    ),*/
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: 200,
              child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 18,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (_, int index) {
                    return InkWell(
                      onTap: () {
                        Alert(
                          context: context,
                          style: AlertStyle(
                              backgroundColor: Colors.black,
                              animationDuration:
                                  const Duration(milliseconds: 200),
                              animationType: AnimationType.fromTop,
                              descStyle: GoogleFonts.roboto(
                                  color: Colors.white, fontSize: 22),
                              titleStyle: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24)),
                          desc: index == 17
                              ? "Answer all"
                              : "Correctly answer all questions related to SDG ${index + 1}.",
                          //title: "Badge no. ${index + 1}",
                          image: Image.asset(
                            "images/$index.png",
                            fit: BoxFit.fill,
                          ),
                          buttons: [
                            // DialogButton(
                            //   onPressed: () {
                            //     setState(() {
                            //       lock = false;
                            //       Navigator.pop(context);
                            //     });
                            //   },
                            //   width: 120,
                            //   color: Colors.transparent,
                            //   child: Text(
                            //     "OK",
                            //     style: GoogleFonts.roboto(
                            //         color: Colors.white, fontSize: 25),
                            //   ),
                            // ),
                          ],
                        ).show();
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Stack(children: [
                              Image.asset(
                                "images/$index.png",
                                fit: BoxFit.fill,
                              ),
                              Visibility(
                                visible: hm[index],
                                child: FractionallySizedBox(
                                    widthFactor: 1.0,
                                    heightFactor: 1.0,
                                    alignment: Alignment.center,
                                    child: DecoratedBox(
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.9)),
                                        child: const Icon(Icons.lock))),
                              ),
                            ]),
                          )),
                    );
                  }),
            ),
            const SizedBox(
              height: 25,
            ),
            SizedBox(
              height: 125,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)),
                      width: 150,
                      child: InkWell(
                        onTap: () {
                          Alert(
                            context: context,
                            style: AlertStyle(
                                backgroundColor: Colors.black,
                                animationDuration:
                                    const Duration(milliseconds: 200),
                                animationType: AnimationType.fromTop,
                                descStyle: GoogleFonts.roboto(
                                    color: Colors.white, fontSize: 22),
                                titleStyle: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24)),
                            desc: 17 == 17
                                ? "Answer all"
                                : "Correctly answer all questions related to SDG 17+ 1}.",
                            //title: "Badge no. ${index + 1}",
                            image: Image.asset(
                              "images/17.png",
                              fit: BoxFit.fill,
                            ),
                            buttons: [
                              // DialogButton(
                              //   onPressed: () {
                              //     setState(() {
                              //       lock = false;
                              //       Navigator.pop(context);
                              //     });
                              //   },
                              //   width: 120,
                              //   color: Colors.transparent,
                              //   child: Text(
                              //     "OK",
                              //     style: GoogleFonts.roboto(
                              //         color: Colors.white, fontSize: 25),
                              //   ),
                              // ),
                            ],
                          ).show();
                        },
                        child: Image.asset(
                          "images/1.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)),
                      width: 150,
                      child: InkWell(
                        onTap: () {
                          Alert(
                            context: context,
                            style: AlertStyle(
                                backgroundColor: Colors.black,
                                animationDuration:
                                    const Duration(milliseconds: 200),
                                animationType: AnimationType.fromTop,
                                descStyle: GoogleFonts.roboto(
                                    color: Colors.white, fontSize: 22),
                                titleStyle: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24)),
                            desc: 17 == 17
                                ? "Answer all"
                                : "Correctly answer all questions related to SDG 17+ 1}.",
                            //title: "Badge no. ${index + 1}",
                            image: Image.asset(
                              "images/17.png",
                              fit: BoxFit.fill,
                            ),
                            buttons: [
                              // DialogButton(
                              //   onPressed: () {
                              //     setState(() {
                              //       lock = false;
                              //       Navigator.pop(context);
                              //     });
                              //   },
                              //   width: 120,
                              //   color: Colors.transparent,
                              //   child: Text(
                              //     "OK",
                              //     style: GoogleFonts.roboto(
                              //         color: Colors.white, fontSize: 25),
                              //   ),
                              // ),
                            ],
                          ).show();
                        },
                        child: Image.asset(
                          "images/1.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white)),
                      width: 150,
                      child: InkWell(
                        onTap: () {
                          Alert(
                            context: context,
                            style: AlertStyle(
                                backgroundColor: Colors.black,
                                animationDuration:
                                    const Duration(milliseconds: 200),
                                animationType: AnimationType.fromTop,
                                descStyle: GoogleFonts.roboto(
                                    color: Colors.white, fontSize: 22),
                                titleStyle: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24)),
                            desc: 17 == 17
                                ? "Answer all"
                                : "Correctly answer all questions related to SDG 17+ 1}.",
                            //title: "Badge no. ${index + 1}",
                            image: Image.asset(
                              "images/17.png",
                              fit: BoxFit.fill,
                            ),
                            buttons: [
                              // DialogButton(
                              //   onPressed: () {
                              //     setState(() {
                              //       lock = false;
                              //       Navigator.pop(context);
                              //     });
                              //   },
                              //   width: 120,
                              //   color: Colors.transparent,
                              //   child: Text(
                              //     "OK",
                              //     style: GoogleFonts.roboto(
                              //         color: Colors.white, fontSize: 25),
                              //   ),
                              // ),
                            ],
                          ).show();
                        },
                        child: Image.asset(
                          "images/1.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(user?.email ?? 'user email',
                style: GoogleFonts.roboto(fontSize: 16.0)),
            ElevatedButton(
              onPressed: signOut,
              child: Text(
                "Sign Out",
                style: GoogleFonts.roboto(fontSize: 16.0),
              ),
            ),
            InkWell(
              onTap: () {},
              child: Ink(
                color: Color(0xFF397AF3),
                child: Padding(
                  padding: EdgeInsets.all(6),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Image.asset("images/google-square.png"), // <-- Use 'Image.asset(...)' here
                      SizedBox(width: 12),
                      Text('Sign in with Google'),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
