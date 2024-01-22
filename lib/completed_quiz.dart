import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class CompletedPage extends StatefulWidget {
  final int totalPoints;
   const CompletedPage(this.totalPoints, {Key? key}) : super(key: key);

  @override
  State<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
  Future<void> updateUserScore() async {
    if (user != null){
      DatabaseReference ref = FirebaseDatabase.instance.ref("Players/${user?.uid}/points");
      final snapshot = await ref.get();
      final Map<Object?, Object?>? dataMap = snapshot.value as Map<Object?, Object?>?;

      print("VVVVVV");
      print(snapshot.value);
      print(dataMap!['points']);
      print("^^^^");

      int currentPoints = 0;
      if (dataMap['points'] != null){
        currentPoints += dataMap['points'] as int;
      }
      await ref.update({
        "points": widget.totalPoints + currentPoints,
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
      body: Column(children: [
        Center(child: Text(" you earned ${widget.totalPoints}")),
      ],),
    );
  }
}
