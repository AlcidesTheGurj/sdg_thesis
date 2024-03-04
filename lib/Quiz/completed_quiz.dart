import 'package:animate_gradient/animate_gradient.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../auth.dart';

class CompletedPage extends StatefulWidget {
  final int totalPoints;
  final int correctCount;
  final int questionCount;
  final int index;
  final int gameMode;
  const CompletedPage(this.totalPoints, this.correctCount, this.questionCount,
      {super.key, required this.index, required this.gameMode});

  @override
  State<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
  final User? user = Auth().currentUser;
  Future<void> updateUserScore() async {
    // print(user);
    if (user != null) {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref().child("Players/${user?.uid}");
      final snapshot = await ref.get();

      int existingPoints = 0;

      final Object? existingPointsObj = snapshot.value;
      if (existingPointsObj != null && existingPointsObj is Map) {
        // If 'total_points' exists in the snapshot, retrieve its value
        existingPoints = existingPointsObj['total_points'] ?? 0;
      }

      await ref.update({
        "total_points": widget.totalPoints + existingPoints,
        "order": 9999999999 - (widget.totalPoints + existingPoints)
      });

    }
  }

  Future<void> updateUserBadges() async {
    if (user != null) {
      DatabaseReference ref = FirebaseDatabase.instance
          .ref()
          .child("Players/${user?.uid}/badge_progress");

      final snapshot = await ref.get();

      final List<dynamic>? badgeObj = snapshot.value as List<dynamic>?;

      if (badgeObj != null) {
        badgeObj[widget.index] = false;
      }

      DatabaseReference ref2 =
          FirebaseDatabase.instance.ref().child("Players/${user?.uid}");

      await ref2.update({
        "badge_progress": badgeObj,
      });
    }
  }

  Future<void> updateUserMilestones() async {
    if (user != null) {
      DatabaseReference ref = FirebaseDatabase.instance
          .ref()
          .child("Players/${user?.uid}/milestone_progress");

      final snapshot = await ref.get();

      final List<dynamic>? badgeObj = snapshot.value as List<dynamic>?;

      if (badgeObj != null) {
        badgeObj[widget.index] = false;
      }

      DatabaseReference ref2 =
          FirebaseDatabase.instance.ref().child("Players/${user?.uid}");

      await ref2.update({
        "milestone_progress": badgeObj,
      });
    }
  }

  Future<void> updateUserCertificate() async {
    if (user != null) {


      bool certificateObj = true;

      DatabaseReference ref2 =
      FirebaseDatabase.instance.ref().child("Players/${user?.uid}");

      await ref2.update({
        "certificate_unlock": certificateObj,
      });
    }
  }

  @override
  void initState() {
    print(widget.gameMode);

    if (widget.correctCount == widget.questionCount) {
      if (widget.gameMode == 17) {
        updateUserBadges();
      }
    }
    if (widget.correctCount >
        widget.questionCount - (widget.questionCount * 0.6)) {
      if (widget.gameMode == 3) {
        updateUserMilestones();
      }
    }
    if (widget.correctCount >
        widget.questionCount - (widget.questionCount * 0.75)) {
      if (widget.gameMode == 1) {
        updateUserCertificate();
      }
    }

    updateUserScore();
    super.initState();
  }

  List<Color> primaryGradientColors = [
    const Color(0xff1c1c28),
    const Color(0xff212130),
    const Color(0xff28283a),
    const Color(0xff2a2a3d),
  ];

  List<Color> secondaryGradientColors = [
    const Color(0xff473d5e),
    const Color(0xff3b314b),
    const Color(0xff362d46),
    const Color(0xff342b42),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimateGradient(
      primaryColors: primaryGradientColors,
      secondaryColors: secondaryGradientColors,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(automaticallyImplyLeading: false,backgroundColor: Colors.transparent,),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Quiz Completed",
                    style: GoogleFonts.roboto(fontSize: 38),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    "${widget.correctCount}/${widget.questionCount}",
                    style: GoogleFonts.roboto(fontSize: 38),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "+${widget.totalPoints} exp",
                    style: GoogleFonts.roboto(fontSize: 24),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text("Go back"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
