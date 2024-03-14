import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart' as firedatabase;
import 'package:sdg_thesis/Quiz/select_pool.dart';
import 'auth.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  firedatabase.Query dbRef =
      firedatabase.FirebaseDatabase.instance.ref().child('Gamemodes');
  final storage = FirebaseStorage.instance;
  final storageRef = FirebaseStorage.instance.ref();
  final imagesRef = FirebaseStorage.instance.ref().child("images");

  final List<Icon> modeIcons = [
    const Icon(Icons.quiz, size: 40),
    const Icon(Icons.auto_awesome, size: 40),
    const Icon(Icons.stars, size: 40),
    const Icon(Icons.construction, size: 40),
  ];

  final List<Color> modeColors = [
    const Color(0xff00689d),
    const Color(0xff3f7e44),
    const Color(0xffe5243b),
    Colors.grey,
    Colors.grey,
    Colors.grey,
  ];

  var gameData;
  var userData;

  bool progress = false;
  bool challenge = false;

  @override
  void initState() {
    _loadGamemodes(context);
    getUserProgress();
   // getUserChallenge();
    super.initState();
  }

  Future<void> _loadGamemodes(BuildContext context) async {
    if (context.mounted) {
      DatabaseReference ref = FirebaseDatabase.instance.ref('Gamemodes');
      var dataSnapshot = await ref.get();
      var gameObject = dataSnapshot.value!;

      setState(() {
        gameData = gameObject;
      });
    }
  }

  Future<void> getUserProgress() async {
    final User? user = Auth().currentUser;
    int totalPoints = 0;
    if (user != null) {
      DatabaseReference ref =
      FirebaseDatabase.instance.ref().child("Players/${user.uid}");
      final snapshot = await ref.get();

      final Object? existingPointsObj = snapshot.value;

      setState(() {
        if (existingPointsObj != null && existingPointsObj is Map) {
          totalPoints = (existingPointsObj['total_points'] ?? 0);
          if (totalPoints >= 1000) {
            // Use a new variable for modification and trigger a rebuild
            Map<String, dynamic> updatedData = {
              ...existingPointsObj,
              'challenge': true,
              'individual' : true
            };
            ref.set(updatedData); // Update the data in the database
            progress = false;
            challenge = false;
          } else if (totalPoints >= 500) {
            // Use a new variable for modification and trigger a rebuild
            Map<String, dynamic> updatedData = {
              ...existingPointsObj,
              'individual': true
            };
            ref.set(updatedData); // Update the data in the database
            progress = false;
            challenge = true;
          }else {
            progress = true;
            challenge = true;
          }
        }
      });
    } else {
      setState(() {
        progress = true;
        challenge = true;
      });
    }
  }

  Widget myWidget({required Map gamemode}) {
    return Stack(children: [
      Container(
        margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
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
                  style: GoogleFonts.roboto(
                      fontSize: 16.0, color: Colors.white70)),
              trailing: modeIcons[gamemode['index']],
              onTap: () {
                // on tap enter to the competition if questions list it's not null
                if (gamemode['questions'] != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectPool(
                        listOfQuestions: gamemode['questions'],
                        poolText: gamemode['pool_text'],
                      ),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => const AlertDialog(
                      title: Center(
                        child: Text(
                          'This Game is constantly being updated, more features coming soon!',
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      Visibility(
          visible: (progress && gamemode['name'] == "Individual") || (challenge && gamemode['name'] == "Challenge"),
          child: Stack(
            children: [
              InkWell(
                splashFactory: NoSplash.splashFactory,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Center(
                        child: Text(
                          gamemode['name'] == 'Challenge' ? 'You need to reach level 10 to unlock Challenge mode!' : 'You need to reach level 5 to unlock Individual SDGs',
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                  padding: const EdgeInsets.all(10),
                  height: 95,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.lock,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          )),
    ]);
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
              padding: const EdgeInsets.all(2.0),
              child: SizedBox(
                child: Image.asset("images/SDG Quest Wheel.png")
                // CachedNetworkImage(
                //   imageUrl:
                //       "https://firebasestorage.googleapis.com/v0/b/sdg-thesis.appspot.com/o/images%2FSDG%20Wheel_PRINT_Transparent.png?alt=media&token=f9775cca-96fe-4b1a-8427-3a52567ae8c2",
                //   placeholder: (context, url) =>
                //       const Center(child: CircularProgressIndicator()),
                //   errorWidget: (context, url, error) => const Icon(Icons.error),
                // ),
              ),
            ),
          ),
          expandedHeight: 300,
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
  }
}
