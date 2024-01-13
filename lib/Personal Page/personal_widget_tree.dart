import 'package:sdg_thesis/auth.dart';
import 'package:flutter/material.dart';
import 'personal_guest_page.dart';
import 'personal_user_page.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({Key? key}) : super(key: key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: Auth().authStateChanges,
    builder: (context,snapshot){
      if (snapshot.hasData){
        return GuestPage();
      }
      else {
        return UserPage();
      }
    },
    );
  }
}
