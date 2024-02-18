import 'package:animate_gradient/animate_gradient.dart';
import 'package:avatar_glow/avatar_glow.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

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
      radius: 80,
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
          height: 140,
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

  List<Color> primaryGradientColors = [
    const Color(0xff160041),
    const Color(0xff410046),
    const Color(0xff600145),
    const Color(0xff7c1c43),
  ];

  List<Color> secondaryGradientColors = [
    const Color(0xff752933),
    const Color(0xff803c36),
    const Color(0xff5d3823),
    const Color(0xff644525),
  ];

  Widget answersWidget({required int answerIndex}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 30, 10, 0),
      padding: const EdgeInsets.all(8),
      height: 100,
      decoration: BoxDecoration(
        color: _isSelected[answerIndex]?Colors.purple:Colors.transparent,
        border: Border.all(
          color: Colors.black, // Set the color of the border
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: InkWell(
        child: Row(
          children: [
            SizedBox(
              width: 80,
              child: Text(alphabetSelections[answerIndex],style: GoogleFonts.roboto(fontSize:30,fontWeight:FontWeight.bold),),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Text(
                widget.listOfQuestions[index]['answer'][answerIndex],
                style: GoogleFonts.roboto(fontSize: 18.0, color: Colors.white),
              ),
            ),
          ],
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
    );
  }

  Widget questionsWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AvatarGlow(
          startDelay: const Duration(milliseconds: 1000),
          glowColor: const Color(0xffa21942),
          glowShape: BoxShape.circle,
          glowRadiusFactor: 0.2,
          curve: Curves.fastOutSlowIn,
          child: circleAvatarWidget(),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black, // Choose the border color
                  width: 2.0, // Choose the border width
                ),
                borderRadius: BorderRadius.circular(
                    10.0), // Adjust the radius for a circular border
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  widget.listOfQuestions[index]['question'].toString(),
                  style:
                      GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold),textAlign: TextAlign.justify,
                ),
              ),
            ),
          ),
        ),
      ],
    );
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
      child: AnimateGradient(
        primaryColors: primaryGradientColors,
        secondaryColors: secondaryGradientColors,
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Expanded(
                  child: LinearPercentIndicator(
                    lineHeight: 14.0,
                    percent: (index + 1) / widget.listOfQuestions.length,
                    backgroundColor: Colors.grey,
                    progressColor: const Color(0xff00689d),
                    animation: true,
                  ),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.lightbulb)),
              ],
            ),
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  floating: false,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: questionsWidget(),
                    ),
                  ),
                  expandedHeight: MediaQuery.sizeOf(context).height / 2,
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, listIndex) =>
                        answersWidget(answerIndex: listIndex),
                    childCount: 3,
                  ),
                ),
              ],
            ),
            bottomNavigationBar: BottomAppBar(
                color: Colors.transparent,
                child: InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black, // Set the color of the border
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0)),
                    child: const Center(
                      child: Text("Continue"),
                    ),
                  ),
                  onTap: () {
                    if (index < widget.listOfQuestions.length - 1) {
                      if (widget.listOfQuestions[index]['correct_answer'] ==
                          userInput) {
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
                  },
                ))),
      ),
    );
  }
}
