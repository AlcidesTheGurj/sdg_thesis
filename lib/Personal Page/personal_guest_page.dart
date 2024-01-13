import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../auth.dart';

class GuestPage extends StatelessWidget {
  GuestPage({Key? key}) : super(key: key);

  final User? user = Auth().currentUser;

  Widget _title(){
    return const Text("Firebase Auth");
  }

  Widget _userUid(){
    return Text(user?.email ?? 'user email');
  }

  Widget _signOutButton(){
    return ElevatedButton(onPressed: signOut, child: const Text("Sign Out"));
  }

  Future<void> signOut() async{
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _userUid(),
        _signOutButton()
      ],
    );
  }
}
