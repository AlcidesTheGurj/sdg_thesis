import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttermoji/fluttermoji.dart';
//import 'package:firebase_database/firebase_database.dart' as firedatabase;
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

import 'completed_quiz.dart';
import '../customization_page.dart';
import '../main.dart';

class Questions extends StatefulWidget {
  const Questions({super.key, required this.listOfQuestions});
  //final String competitionId;
  final List listOfQuestions;

  @override
  State<Questions> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
  Widget circleAvatarWidget() {
    return CircleAvatar(
      radius: 90,
      // backgroundColor: const Color(0xff7c1c43).withOpacity(0.65),
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(
            90,
          ),
        ),
        child: SvgPicture.string(
          FluttermojiFunctions().decodeFluttermojifromString(avatarData),
          height: 150,
          width: 100,
        ),
      ),
    );
    // FluttermojiCircleAvatar(
    //   backgroundColor: Colors.grey[200],
    //   radius: 100,
    // ));
  }

  String status = '';

  late DatabaseReference dbRef;
  var points = "points";
  var index = 0;
  late int score = 0;
  bool submit = false;

  final List<bool> _isSelected = [false, false, true];
  final List<String> alphabetSelections = ["A", "B", "C"];
  String userInput = "none";

  late int playerScore;

  final myController = TextEditingController();

  String title = "";

  int totalPoints = 0;

  Future<void> _loadAvatar(BuildContext context) async {
    if (context.mounted && user != null) {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref('Players/${user?.uid}/avatar');
      var dataSnapshot = await ref.get();
      var userObject = dataSnapshot.value!;
      //print(userObject);
      //print(user?.uid as String);

      //final value = FluttermojiFunctions().decodeFluttermojifromString(userObject as String);
      //print("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF");
      //print(userObject as String);

      setState(() {
        avatarData = userObject as String;
      });
    }
  }

  @override
  void initState() {
    _loadAvatar(context);
    // print(widget.listOfQuestions);
    // print(widget.listOfQuestions[index]['answer'].length);
    // print(widget.listOfQuestions[1]['answer'].length);

    super.initState();
    // firedatabase.Query dbRef =
    //     firedatabase.FirebaseDatabase.instance.ref().child('Gamemodes');
    //print(widget.listOfQuestions);
  }

  @override
  Widget build(BuildContext context) {
    Route createRoute(int totalPoints) {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            CompletedPage(totalPoints),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(onPressed: () {

            }, icon: const Icon(Icons.lightbulb))
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text(
              //   "Question ${index + 1} of ${widget.listOfQuestions.length}",
              //   style: const TextStyle(fontSize: 22.0),
              // ),
              const SizedBox(
                height: 20,
              ),
              Align(
                child: LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width,
                  lineHeight: 14.0,
                  percent: (index + 1) / widget.listOfQuestions.length,
                  backgroundColor: Colors.grey,
                  progressColor: const Color(0xff00689d),
                  animation: true,
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      circleAvatarWidget(),
                      BubbleSpecialTwo(
                        text: widget.listOfQuestions[index]['question']
                            .toString(),
                        isSender: false,
                        color: const Color(0xff3f7e44),
                        tail: true,
                        textStyle: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //circleAvatarWidget(),
              // Align(
              //   alignment: Alignment.center,
              //   child: SingleChildScrollView(
              //     scrollDirection: Axis.horizontal,
              //     child: Row(
              //       mainAxisSize: MainAxisSize.max,
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         // SizedBox(width:MediaQuery.of(context).size.width * 0.30),
              //
              //         BubbleSpecialOne(
              //           text: widget.listOfQuestions[index]['question']
              //               .toString(),
              //           isSender: false,
              //           color: const Color(0xff3f7e44),
              //           tail: false,
              //           textStyle: const TextStyle(
              //             fontSize: 20,
              //             color: Colors.white,
              //             fontStyle: FontStyle.italic,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // Text(
              //   widget.listOfQuestions[index]['question'].toString(),
              //   style: const TextStyle(
              //     fontSize: 20.0,
              //   ),
              // ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                // decoration: BoxDecoration(
                //   color: Colors.green.withOpacity(0.3)
                // ),
                height: 260,
                child: ListView.builder(
                    itemCount: widget.listOfQuestions[index]['answer'].length,
                    itemBuilder: (BuildContext context, int answerIndex) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20.0, left: 5.0, right: 5.0, top: 10.0),
                        child: SizedBox(
                          height: 60,
                          child: ListTile(
                            selectedTileColor: const Color(0xff00689d),
                            selected: _isSelected[answerIndex],
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Color(0xff00689d), width: 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            title: Text(
                              '${widget.listOfQuestions[index]['answer'][answerIndex]}',
                              style: GoogleFonts.roboto(
                                  fontSize: 20.0, color: Colors.white),
                            ),
                            // subtitle: Text(
                            //     "None",
                            //     style: GoogleFonts.roboto(
                            //         fontSize: 16.0,
                            //         color: Colors.white70
                            //     )
                            // ),
                            leading: Text(
                              alphabetSelections[answerIndex],
                              style: GoogleFonts.roboto(
                                  fontSize: 30.0, color: Colors.white),
                            ),
                            onTap: () {
                              setState(() {
                                _isSelected[0] = false;
                                _isSelected[1] = false;
                                _isSelected[2] = false;
                                _isSelected[answerIndex] = true;
                                userInput = alphabetSelections[answerIndex];
                                // print(userInput);
                              });
                            },
                          ),
                        ),
                      );
                    }),
              ),
              ElevatedButton(
                  onPressed: () {
                    if (index < widget.listOfQuestions.length - 1) {
                      if (widget.listOfQuestions[index]['correct_answer'] ==
                          userInput) {
                        // print("YAYYYY");
                        setState(() {
                          totalPoints +=
                              widget.listOfQuestions[index]['point'] as int;
                          //print(totalPoints);
                          index++;
                        });
                      } else {
                        setState(() {
                          index++;
                        });
                      }
                    } else {
                      //Navigator.pop(context);
                      totalPoints +=
                          widget.listOfQuestions[index]['point'] as int;
                      Navigator.of(context)
                          .pushReplacement(createRoute(totalPoints));
                    }
                    // setState(() {
                    //   totalPoints += widget.listOfQuestions[index]['point'] as int;
                    //   print(totalPoints);
                    //   index++;
                    // });
                    // print(index);
                  },
                  child: const Text("submit"))
            ],
          ),
        ),
      ),
    );
  }
}
