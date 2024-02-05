import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class CompletedPage extends StatefulWidget {
  final int totalPoints;
   const CompletedPage(this.totalPoints, {super.key});

  @override
  State<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
  Future<void> updateUserScore() async {
    if (user != null) {
      DatabaseReference ref = FirebaseDatabase.instance.ref("Players/${user?.uid}/points");
      final snapshot = await ref.get();

      final Map<dynamic, dynamic>? dataMap = snapshot.value as Map<dynamic, dynamic>?;

      if (dataMap != null) {
        // Accessing 'total_points' from the map
        dynamic totalPointsData = dataMap['total_points'];

        // Checking if 'total_points' is not null
        if (totalPointsData != null) {
          int totalPoints = totalPointsData as int;

          print("Total Points: $totalPoints");

          await ref.update({
            "total_points": widget.totalPoints + totalPoints,
          });
        }
      }
    }
  }


  @override
  void initState() {
    updateUserScore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        Center(child: Text(" you earned ${widget.totalPoints}")),
      ],),
    );
  }
}
