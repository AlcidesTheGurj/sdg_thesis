import 'package:animated_background/animated_background.dart';
import 'package:animated_background/particles.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdg_thesis/Personal%20Page/personal_user_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart' as firedatabase;
import 'package:firebase_database/ui/firebase_animated_list.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  final String title = 'Flutter Demo Home Page';


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{
  final firestore.FirebaseFirestore _firestore = firestore.FirebaseFirestore.instance;
  firedatabase.Query dbRef = firedatabase.FirebaseDatabase.instance.ref().child('Gamemodes');
  firedatabase.DatabaseReference reference = firedatabase.FirebaseDatabase.instance.ref().child('Gamemodes');

  final List<Icon> modeIcons = [
    const Icon(Icons.quiz,size: 40),
    const Icon(Icons.stars,size: 40),
    const Icon(Icons.auto_mode,size: 40),
  ];

  Widget myWidget({required Map competition}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 30, 10, 0),
      padding: const EdgeInsets.all(10),
      height: 95,
      decoration: BoxDecoration(
        color: Colors.amber.withOpacity(0.3),
        borderRadius: BorderRadius.circular(30),
      ),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ListTile(
            title: Text(
              competition['name'],
              style: GoogleFonts.roboto(
                  fontSize: 28.0,
              color: Colors.white),
            ),
            subtitle: Text(
              "${competition['description'] ?? 'None'}",
              style: GoogleFonts.roboto(
                fontSize: 16.0,
                color: Colors.white70
              )
            ),
            trailing: modeIcons[competition['index']],
            onTap: () {
              // on tap enter to the competition if questions list it's not null
              if (competition['questions'] != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        UserPage(
                        ),
                  ),
                );
              } else {
                // show msg when competition is not open
                showDialog(
                  context: context,
                  builder: (context) =>
                  const AlertDialog(
                    title: Center(
                      child: Text(
                        'Please selected the competition that have status open, touch unfocused area to dismiss.',
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
    @override
    Widget build(BuildContext context) {
      return
        Container(
          height: double.infinity,
          child: FirebaseAnimatedList(
            query: dbRef,
            itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) { // itemBuilder must return something
              Map competition = snapshot.value as Map;
              competition['key'] = snapshot.key;
              return myWidget(competition:competition);
            },
          ),
        );

    }
  }

