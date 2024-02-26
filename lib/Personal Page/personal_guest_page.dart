import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttermoji/fluttermojiFunctions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../main.dart';
import 'mobile.dart';

import '../auth.dart';
import '../customization_page.dart';

class GuestPage extends StatefulWidget {
  const GuestPage({super.key});

  @override
  State<GuestPage> createState() => _GuestPageState();
}

class _GuestPageState extends State<GuestPage> {
  final User? user = Auth().currentUser;

  double playerPoints = 0;

  List<IconData> poolIcon = [
    FontAwesomeIcons.envira,
    FontAwesomeIcons.handshakeAngle,
    FontAwesomeIcons.dollarSign
  ];
  List<Color> poolColor = [
    const Color(0xff4c9f38),
    const Color(0xff19486a),
    const Color(0xffbf8b2e)
  ];
  Future<void> getUserScore() async {
    if (user != null) {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref().child("Players/${user?.uid}");
      final snapshot = await ref.get();

      double existingPoints = 0.0; // Declare as double

      final Object? existingPointsObj = snapshot.value;
      if (existingPointsObj != null && existingPointsObj is Map) {
        // If 'total_points' exists in the snapshot, retrieve its value
        existingPoints = (existingPointsObj['total_points'] ?? 0)
            .toDouble(); // Convert to double
      }

      setState(() {
        playerPoints = existingPoints;
      });
    }
  }

  Future<void> getUserBadges() async {
    if (user != null) {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref().child("Players/${user?.uid}");
      final snapshot = await ref.get();

      List<bool> existingBadges =
          List<bool>.filled(18, true); // Default to 20 false values

      Map<dynamic, dynamic>? snapshotValueMap =
          snapshot.value as Map<dynamic, dynamic>?;

      if (snapshotValueMap != null) {
        // If 'badge_progress' exists in the snapshot and is a list, retrieve its values
        List<dynamic>? badgeProgressList =
            snapshotValueMap['badge_progress'] as List<dynamic>?;

        if (badgeProgressList != null) {
          // Cast the values to bool
          existingBadges =
              badgeProgressList.map((value) => value as bool).toList();
        }
      }

      // print(
      //     "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
      // print(existingBadges);
      setState(() {
        badgeProgress = existingBadges;
      });

      if (snapshotValueMap?['badge_progress'] == null) {
        // If 'badge_progress' doesn't exist, add it with default false values
        await ref.update({
          'badge_progress': existingBadges,
        });
      }
    }
  }

  Future<void> getUserMilestones() async {
    if (user != null) {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref().child("Players/${user?.uid}");
      final snapshot = await ref.get();

      List<bool> existingMilestones =
          List<bool>.filled(3, true); // Default to 20 false values

      Map<dynamic, dynamic>? snapshotValueMap =
          snapshot.value as Map<dynamic, dynamic>?;

      if (snapshotValueMap != null) {
        // If 'badge_progress' exists in the snapshot and is a list, retrieve its values
        List<dynamic>? milestoneProgressList =
            snapshotValueMap['milestone_progress'] as List<dynamic>?;

        if (milestoneProgressList != null) {
          // Cast the values to bool
          existingMilestones =
              milestoneProgressList.map((value) => value as bool).toList();
        }
      }

      // print(
      //     "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
      // print(existingBadges);
      setState(() {
        milestoneProgress = existingMilestones;
      });

      if (snapshotValueMap?['milestone_progress'] == null) {
        // If 'badge_progress' doesn't exist, add it with default false values
        await ref.update({
          'milestone_progress': existingMilestones,
        });
      }
    }
  }

  @override
  void initState() {
    _loadAvatar(context);
    getUserScore();
    getUserBadges();
    getUserMilestones();
    //print(user);
    super.initState();
  }

  Widget circleAvatarWidget() {
    return CircleAvatar(
      radius: 110,
      // backgroundColor: const Color(0xff7c1c43).withOpacity(0.65),
      backgroundColor: Colors.black.withOpacity(0.4),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(
            90,
          ),
        ),
        child: SvgPicture.string(
          FluttermojiFunctions().decodeFluttermojifromString(avatarData),
          height: 190,
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
    await Auth().signOutFromGoogle();
  }

  // true is locked
  // false i unlocked
  List<bool> badgeProgress = List<bool>.filled(18, true);
  List<bool> milestoneProgress = List<bool>.filled(3, true);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 6,
                      blurRadius: 7, // changes position of shadow
                    ),
                  ],
                ),
                child: Stack(alignment: Alignment.center, children: [
                  circleAvatarWidget(),
                  CircularPercentIndicator(
                    radius: 110.0,
                    lineWidth: 16.0,
                    percent: (playerPoints % 100) / 100,
                    progressColor: const Color(0xffe5243b),
                    backgroundColor: Colors.black,
                  ),
                  Positioned(
                    bottom: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffe5243b),
                        borderRadius: BorderRadius.circular(
                            8.0), // Replace with your desired color
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 1.0),
                        child: Text('${(playerPoints / 100).floor()}',
                            style: GoogleFonts.roboto(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Badges", style: GoogleFonts.roboto(fontSize: 24.0)),
                ],
              ),
            ),
            /*Image.asset("images/test.png"),
                    SizedBox(
                      width: 10,
                    ),*/
            Container(
              margin: const EdgeInsets.all(6),
              height: 200,
              child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: badgeProgress.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6),
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
                              ? "Unlock all badges related to SDG completion"
                              : "Correctly answer all questions related to SDG ${index + 1}.",
                          //title: "Badge no. ${index + 1}",
                          image: Stack(children: [
                            Image.asset(
                              "images/$index.png",
                              fit: BoxFit.fill,
                            ),
                            Positioned(
                              left: 0.0,
                              right: 0.0,
                              top: 0.0,
                              bottom: 0.0,
                              child: Visibility(
                                visible: badgeProgress[index],
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.95)),
                                  child: const Icon(
                                    Icons.lock,
                                    size: 80,
                                  ),
                                ),
                              ),
                            ),
                          ]),
                          buttons: [
                            DialogButton(
                              onPressed: () {
                                setState(() {
                                  lock = false;
                                  Navigator.pop(context);
                                });
                              },
                              width: 120,
                              color: const Color(0xffe5243b),
                              child: Text(
                                "OK",
                                style: GoogleFonts.roboto(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ),
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
                                visible: badgeProgress[index],
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
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Milestones",
                      style: GoogleFonts.roboto(fontSize: 24.0)),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: 180,
              child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: milestoneProgress.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1),
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
                              ? "Unlock all badges related to SDG completion"
                              : "Correctly answer all questions related to SDG ${index + 1}.",
                          //title: "Badge no. ${index + 1}",
                          image: Stack(children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Icon(
                                poolIcon[index],
                                size: 80,
                                color: poolColor[index],
                              ),
                            ),
                            Positioned(
                              left: 0.0,
                              right: 0.0,
                              top: 0.0,
                              bottom: 0.0,
                              child: Visibility(
                                visible: milestoneProgress[index],
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.95)),
                                  child: const Icon(
                                    Icons.lock,
                                    size: 80,
                                  ),
                                ),
                              ),
                            ),
                          ]),
                          buttons: [
                            DialogButton(
                              onPressed: () {
                                setState(() {
                                  lock = false;
                                  Navigator.pop(context);
                                });
                              },
                              width: 120,
                              color: const Color(0xffe5243b),
                              child: Text(
                                "OK",
                                style: GoogleFonts.roboto(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ),
                          ],
                        ).show();
                      },
                      child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Stack(children: [
                              Center(
                                  child: Icon(
                                poolIcon[index],
                                size: 65,
                                color: poolColor[index],
                              )),
                              Visibility(
                                visible: milestoneProgress[index],
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Certificate",
                      style: GoogleFonts.roboto(fontSize: 24.0)),
                ],
              ),
            ),
            const SizedBox(height: 40,),

            ElevatedButton(
              onPressed: () async {
                _createPDF();
              },
              child: const Text("Generate"),
            ),
            const SizedBox(height: 80,),
            Text(user?.email ?? 'user email',
                style: GoogleFonts.roboto(fontSize: 16.0)),
            ElevatedButton(
              onPressed: signOut,
              child: Text(
                "Sign Out",
                style: GoogleFonts.roboto(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _createPDF() async {
  PdfDocument document = PdfDocument();
  final page = document.pages.add();

  // Add title
  page.graphics.drawString('Certificate of Achievement',
      PdfStandardFont(PdfFontFamily.helvetica, 30),
      bounds: const Rect.fromLTWH(50, 50, 500, 50));

  // Handle user display name
  final userName = user?.displayName ?? 'User';

  // Add text with user's display name
  page.graphics.drawString(
      'This is to certify that $userName has successfully completed the quiz on SDGs.',
      PdfStandardFont(PdfFontFamily.courier, 16),
      bounds: const Rect.fromLTWH(50, 120, 500, 200));

  List<int> bytes = await document.save();
  document.dispose();

  saveAndLaunchFile(bytes, 'Certificate.pdf');
}

/*
* SizedBox(
              height: 125,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white.withOpacity(0.6)),
                      ),
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
                            buttons: [ DialogButton(
                              onPressed: () {
                                setState(() {
                                  lock = false;
                                  Navigator.pop(context);
                                });
                              },
                              width: 120,
                              color: const Color(0xffe5243b),
                              child: Text(
                                "OK",
                                style: GoogleFonts.roboto(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ),],
                          ).show();
                        },
                        child: Stack(
                          children: [
                            Center(
                              child: Image.asset(
                                "images/1.png",
                                fit: BoxFit.fill,
                              ),
                            ),
                            Visibility(
                              visible: false,
                              child: FractionallySizedBox(
                                  widthFactor: 1.0,
                                  heightFactor: 1.0,
                                  alignment: Alignment.center,
                                  child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.9)),
                                      child: const Icon(Icons.lock))),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white.withOpacity(0.6)),
                      ),
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
                            buttons: [ DialogButton(
                              onPressed: () {
                                setState(() {
                                  lock = false;
                                  Navigator.pop(context);
                                });
                              },
                              width: 120,
                              color: const Color(0xffe5243b),
                              child: Text(
                                "OK",
                                style: GoogleFonts.roboto(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ),],
                          ).show();
                        },
                        child: Stack(
                          children: [
                            Center(
                              child: Image.asset(
                                "images/14.png",
                                fit: BoxFit.fill,
                              ),
                            ),
                            Visibility(
                              visible: false,
                              child: FractionallySizedBox(
                                  widthFactor: 1.0,
                                  heightFactor: 1.0,
                                  alignment: Alignment.center,
                                  child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.9)),
                                      child: const Icon(Icons.lock))),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white.withOpacity(0.6)),
                      ),
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
                            buttons: [ DialogButton(
                              onPressed: () {
                                setState(() {
                                  lock = false;
                                  Navigator.pop(context);
                                });
                              },
                              width: 120,
                              color: const Color(0xffe5243b),
                              child: Text(
                                "OK",
                                style: GoogleFonts.roboto(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ),],
                          ).show();
                        },
                        child: Stack(
                          children: [
                            Center(
                              child: Image.asset(
                                "images/17.png",
                                fit: BoxFit.fill,
                              ),
                            ),
                            Visibility(
                              visible: false,
                              child: FractionallySizedBox(
                                  widthFactor: 1.0,
                                  heightFactor: 1.0,
                                  alignment: Alignment.center,
                                  child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.9)),
                                      child: const Icon(Icons.lock))),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),*/
