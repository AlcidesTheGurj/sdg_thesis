import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'auth.dart';
import 'main.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({Key? key}) : super(key: key);

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(onPressed: signInWithGoogle, child: Text("asd")),
        ElevatedButton(onPressed: signOutWithGoogle, child: Text("asd")),
      ],
    );
  }

  Future<void> signInWithGoogle() async {
    try {
      await Auth().signInWithGoogle();
    } on FirebaseAuthException catch (e) {
      print("error");
    }
    if(mounted){
      setState(() {
        if (user?.email != null){
          name = user?.email as String;
        }
      });
    }
  }
  Future<void> signOutWithGoogle() async {
    try {
      await Auth().signOutFromGoogle();
    } on FirebaseAuthException catch (e) {
      print("error");
    }
    if(mounted){
      setState(() {
        if (user?.email != null){
          name = user?.email as String;
        }
      });
    }
  }
}
