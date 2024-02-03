//import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_database/firebase_database.dart' as firedatabase;
import 'package:sdg_thesis/Quiz/questions.dart';

import 'main.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  final String title = 'Flutter Demo Home Page';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  // final firestore.FirebaseFirestore _firestore = firestore.FirebaseFirestore.instance;
  firedatabase.Query dbRef =
      firedatabase.FirebaseDatabase.instance.ref().child('Gamemodes');
  final storage = FirebaseStorage.instance;
  final storageRef = FirebaseStorage.instance.ref();
  final imagesRef = FirebaseStorage.instance.ref().child("images");
  //firedatabase.DatabaseReference reference = firedatabase.FirebaseDatabase.instance.ref().child('Gamemodes');

  final List<Icon> modeIcons = [
    const Icon(Icons.quiz, size: 40),
    const Icon(Icons.stars, size: 40),
    const Icon(Icons.auto_mode, size: 40),
    const Icon(Icons.auto_mode, size: 40),
    const Icon(Icons.auto_mode, size: 40),
    const Icon(Icons.auto_mode, size: 40),
  ];

  //0.5 opacity
  final List<Color> modeColors = [
    const Color(0xff00689d),
    const Color(0xff3f7e44),
    const Color(0xffe5243b),
    Colors.grey,
    Colors.grey,
    Colors.grey,
  ];

  var gameData;

  Future<void> _loadGamemodes(BuildContext context) async {
    if (context.mounted) {
      DatabaseReference ref =
      FirebaseDatabase.instance.ref('Gamemodes');
      var dataSnapshot = await ref.get();
      var gameObject = dataSnapshot.value!;
      //print(dataSnapshot.value!.runtimeType);
     // print(gameObject.runtimeType);

      setState(() {
        gameData = gameObject;
         print(gameData);
       //print(gameData.runtimeType);
      });
    }
  }

  @override
  void initState() {
    _loadGamemodes(context);
    print(googleUser);
    super.initState();
  }

  Widget myWidget({required Map gamemode}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 30, 10, 0),
      padding: const EdgeInsets.all(10),
      height: 95,
      decoration: BoxDecoration(
        color: modeColors[gamemode['index']],
        borderRadius: BorderRadius.circular(30),
      ),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ListTile(
            title: Text(
              gamemode['name'],
              style: GoogleFonts.roboto(fontSize: 28.0, color: Colors.white),
            ),
            subtitle: Text("${gamemode['description'] ?? 'None'}",
                style:
                    GoogleFonts.roboto(fontSize: 16.0, color: Colors.white70)),
            trailing: modeIcons[gamemode['index']],
            onTap: () {
              // on tap enter to the competition if questions list it's not null
              if (gamemode['questions'] != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Questions(
                      listOfQuestions: gamemode['questions'],
                    ),
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) => const AlertDialog(
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
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: false,
          backgroundColor: Colors.transparent,
          flexibleSpace: FlexibleSpaceBar(
            background: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: 180,
                child: CachedNetworkImage(
                  imageUrl:
                      "https://firebasestorage.googleapis.com/v0/b/sdg-thesis.appspot.com/o/images%2FSDG%20Wheel_PRINT_Transparent.png?alt=media&token=f9775cca-96fe-4b1a-8427-3a52567ae8c2",
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          ),
          expandedHeight: 220,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) =>
              myWidget(gamemode: gameData[index]),
            childCount: gameData?.length ?? 0,
          ),
        ),
      ],
    );
    // Expanded(
    //   child: FirebaseAnimatedList(
    //     query: dbRef,
    //     itemBuilder: (BuildContext context, DataSnapshot snapshot,
    //         Animation<double> animation, int index) {
    //       // itemBuilder must return something
    //       Map gamemode = snapshot.value as Map;
    //       gamemode['key'] = snapshot.key;
    //       //print(gamemode);
    //       return myWidget(gamemode: gamemode);
    //     },
    //   ),
    // ),
  }
}
