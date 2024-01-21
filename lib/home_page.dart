
//import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_database/firebase_database.dart' as firedatabase;
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:sdg_thesis/Quiz/questions.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  final String title = 'Flutter Demo Home Page';


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{
 // final firestore.FirebaseFirestore _firestore = firestore.FirebaseFirestore.instance;
  firedatabase.Query dbRef = firedatabase.FirebaseDatabase.instance.ref().child('Gamemodes');
  //firedatabase.DatabaseReference reference = firedatabase.FirebaseDatabase.instance.ref().child('Gamemodes');

  final List<Icon> modeIcons = [
    const Icon(Icons.quiz,size: 40),
    const Icon(Icons.stars,size: 40),
    const Icon(Icons.auto_mode,size: 40),
  ];


    final List<Color> modeColors = [
      Colors.blueAccent.withOpacity(0.5),
      Colors.greenAccent.withOpacity(0.5),
      Colors.redAccent.withOpacity(0.5)
    ];

  Widget myWidget({required Map gamemode}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 30, 10, 0),
      padding: const EdgeInsets.all(10),
      height: 95,
      decoration: BoxDecoration(
        color:  modeColors[gamemode['index']],
        borderRadius: BorderRadius.circular(30),
      ),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ListTile(
            title: Text(
              gamemode['name'],
              style: GoogleFonts.roboto(
                  fontSize: 28.0,
              color: Colors.white),
            ),
            subtitle: Text(
              "${gamemode['description'] ?? 'None'}",
              style: GoogleFonts.roboto(
                fontSize: 16.0,
                color: Colors.white70
              )
            ),
            trailing: modeIcons[gamemode['index']],
            onTap: () {
              // on tap enter to the competition if questions list it's not null
              if (gamemode['questions'] != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Questions(
                          competitionId: gamemode['key'],
                          listOfQuestions: gamemode['questions'],
                        ),
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) =>
                  const AlertDialog(
                    title: Center(
                      child: Text(
                        'This Game mode is not ready yet, check back later!',
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
        SizedBox(
          height: double.infinity,
          child: FirebaseAnimatedList(
            query: dbRef,
            itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) { // itemBuilder must return something
              Map gamemode = snapshot.value as Map;
              gamemode['key'] = snapshot.key;
              return myWidget(gamemode:gamemode);
            },
          ),
        );

    }
  }

