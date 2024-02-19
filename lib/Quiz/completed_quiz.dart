import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../auth.dart';
import '../main.dart';

class CompletedPage extends StatefulWidget {
  final int totalPoints;
  const CompletedPage(this.totalPoints, {super.key});

  @override
  State<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
  final User? user = Auth().currentUser;
  Future<void> updateUserScore() async {
    print(user);
    if (user != null) {
      DatabaseReference ref = FirebaseDatabase.instance.ref().child("Players/${user?.uid}");
      final snapshot = await ref.get();

      int existingPoints = 0;

      final Object? existingPointsObj = snapshot.value;
      if (existingPointsObj != null && existingPointsObj is Map) {
        // If 'total_points' exists in the snapshot, retrieve its value
        existingPoints = existingPointsObj['total_points'] ?? 0;
      }

      await ref.update({
        "total_points": widget.totalPoints + existingPoints,
      });
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
      body: Column(
        children: [
          Center(child: Text(" you earned ${widget.totalPoints}")),
        ],
      ),
    );
  }
}
