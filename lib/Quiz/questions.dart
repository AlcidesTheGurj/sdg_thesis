import 'package:animate_gradient/animate_gradient.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import 'completed_quiz.dart';
import '../customization_page.dart';
import '../main.dart';

class Questions extends StatefulWidget {
  const Questions(
      {super.key,
      required this.listOfQuestions,
      required this.index,
      required this.gameMode});
  //final String competitionId;
  final List listOfQuestions;
  final int index;
  final int gameMode;

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
  //var points = "points";
  var index = 0;
  late int score = 0;
  bool submit = false;

  final List<bool> _isSelected = [false, false, false];
  final List<String> alphabetSelections = ["A", "B", "C"];
  String userInput = "none";

  String userSubmission = 'none';

  late int playerScore;

  final myController = TextEditingController();

  String title = "";

  int totalPoints = 0;

  int correctCount = 0;

  bool isButtonPressed = false;

  // Define a variable to track whether continue button is tapped
  bool continueButtonTapped = false;

// Variable to control whether to show the shadow during the delay
  bool showShadow = false;

  bool showEye = false;

  int streakCounter = 0;

  int revealCounter = 0;

  bool revealUsed = false;

  int revealTotal = 0;

  IconData shadowIcon = FontAwesomeIcons.question;

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
    if (widget.gameMode > 5) {
        revealCounter = 1;
        revealTotal = 1;
    }
    else if (widget.gameMode > 2) {
      revealCounter = 3;
      revealTotal = 3;
    }
    else {
      revealCounter = 0;
      revealTotal = 0;
    }
    super.initState();
    // firedatabase.Query dbRef =
    //     firedatabase.FirebaseDatabase.instance.ref().child('Gamemodes');
    //print(widget.listOfQuestions);
  }

  List<Color> primaryGradientColors = [
    const Color(0xff1c1c28),
    const Color(0xff212130),
    const Color(0xff28283a),
    const Color(0xff2a2a3d),
  ];

  List<Color> secondaryGradientColors = [
    const Color(0xff473d5e),
    const Color(0xff3b314b),
    const Color(0xff362d46),
    const Color(0xff342b42),
  ];
  Widget answersWidget({required int answerIndex}) {
    bool isCorrectAnswer = widget.listOfQuestions[index]['correct_answer'] ==
        alphabetSelections[answerIndex];

    Color containerColor = _isSelected[answerIndex]
        ? const Color(0xff1c1c28).withOpacity(0.8)
        : const Color(0xff1c1c28).withOpacity(0.4);

    Color shadowColor =
        isCorrectAnswer ? const Color(0xff00689d) : Colors.transparent;

    if (isCorrectAnswer) {
      showEye ?shadowColor = Colors.grey : shadowColor = const Color(0xff00689d);
      showEye ?shadowIcon = FontAwesomeIcons.eye : shadowIcon = Icons.check;
    } else if (userSubmission == alphabetSelections[answerIndex]) {
      shadowColor = const Color(0xffe5243b);
    }

    // if (userSubmission == 'none' || userSubmission == 'E'){
    //   isCorrectAnswer? shadowColor = const Color(0xff00689d) : shadowColor = const Color(0xffe5243b);
    // }

    // Color checkmarkColor = isCorrectAnswer
    //     ? const Color(0xff3f7e44)
    //     : const Color(0xffe5243b);

    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
          padding: const EdgeInsets.fromLTRB(
            10,
            0,
            0,
            0,
          ),
          height: 85,
          decoration: BoxDecoration(
            color: containerColor,
            border: Border.all(
              color: Colors.transparent,
              width: 2.0,
            ),
            boxShadow: showShadow
                ? [
                    BoxShadow(
                      color: shadowColor,
                      offset: const Offset(0.0, 0.0),
                      blurRadius: 15.0,
                    ),
                  ]
                : const [],
            borderRadius: BorderRadius.circular(30),
          ),
          child: InkWell(
            splashFactory: NoSplash.splashFactory,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 40,
                  child: _isSelected[answerIndex]
                      ? AnimatedTextKit(
                          repeatForever: true,
                          animatedTexts: [
                            ScaleAnimatedText(alphabetSelections[answerIndex],
                                textStyle: GoogleFonts.roboto(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                                duration: const Duration(seconds: 1)),
                          ],
                        )
                      : Text(
                          alphabetSelections[answerIndex],
                          style: GoogleFonts.roboto(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                ),
                Flexible(
                    child: _isSelected[answerIndex]
                        ? AnimatedTextKit(
                            key: ValueKey(answerIndex),
                            animatedTexts: [
                              TypewriterAnimatedText(
                                widget.listOfQuestions[index]['answer']
                                    [answerIndex],
                                textStyle: GoogleFonts.roboto(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                            isRepeatingAnimation: true,
                            repeatForever: true,
                          )
                        : Text(
                            widget.listOfQuestions[index]['answer']
                                [answerIndex],
                            style: GoogleFonts.roboto(fontSize: 16),
                          )),
                Visibility(
                  visible: showShadow,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Icon(
                        isCorrectAnswer ? shadowIcon : Icons.close,
                        color: shadowColor,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              setState(() {
                _isSelected[0] = false;
                _isSelected[1] = false;
                _isSelected[2] = false;
                if (!continueButtonTapped) {
                  _isSelected[answerIndex] = true;
                }
                userInput = alphabetSelections[answerIndex];
              });
            },
          ),
        ),
        Positioned(
          top: 0,
          child: Visibility(
            visible: answerIndex == 0 ? true : false,
            child: const Icon(
              Icons.keyboard_arrow_up,
              color: Colors.white,
              size: 25,
            ),
          ),
        ),
      ],
    );
  }

  Widget questionsWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        streakCounter < 3
            ? AvatarGlow(
                startDelay: const Duration(milliseconds: 500),
                glowColor: Colors.grey,
                glowShape: BoxShape.circle,
                glowRadiusFactor: 0.2,
                curve: Curves.fastOutSlowIn,
                child: circleAvatarWidget(),
              )
            : AvatarGlow(
                startDelay: const Duration(milliseconds: 500),
                glowColor: const Color(0xffa21942),
                glowShape: BoxShape.circle,
                glowRadiusFactor: 0.5,
                curve: Curves.slowMiddle,
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
                  color: Colors.transparent,
                  width: 2.0, //
                ),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xff28283a),
                    offset: Offset(0.0, 2.0),
                    blurRadius: 3.0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: AnimatedTextKit(
                  key: ValueKey(index),
                  isRepeatingAnimation: false,
                  displayFullTextOnTap: true,
                  animatedTexts: [
                    TypewriterAnimatedText(
                        widget.listOfQuestions[index]['question'],
                        textStyle: GoogleFonts.roboto(
                            fontSize: 20, fontWeight: FontWeight.bold))
                  ],
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
    Route createRoute(int totalPoints, int correctCount, int questionCount) {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => CompletedPage(
          totalPoints,
          correctCount,
          questionCount,
          gameMode: widget.gameMode,
          index: widget.index,
        ),
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
                    Alert(
                      context: context,
                      style: AlertStyle(
                        backgroundColor: Colors.black,
                        animationDuration: const Duration(milliseconds: 300),
                        animationType: AnimationType.fromTop,
                        descStyle: GoogleFonts.roboto(color: Colors.white),
                      ),
                      image: const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Icon(
                          FontAwesomeIcons.exclamation,
                          color: Colors.red,
                          size: 80,
                        ),
                      ),
                      desc:
                          "Return to Home page? Tracked progress will be lost!",
                      buttons: [
                        DialogButton(
                          onPressed: () {
                            Navigator.pop(
                                context, false); // Passing false means "No"
                          },
                          width: 120,
                          color: Colors.red,
                          child: Text(
                            "No",
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                        ),
                        DialogButton(
                          onPressed: () {
                            Navigator.pop(
                                context, true); // Passing true means "Yes"
                          },
                          width: 120,
                          color: Colors.blue,
                          child: Text(
                            "Yes",
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ],
                    ).show().then((value) {
                      // This block will be executed after the dialog is closed
                      if (value == true) {
                        Navigator.of(context).pop(); // Pop the current screen
                      }
                    });
                  },
                ),
                Expanded(
                  child: LinearPercentIndicator(
                    lineHeight: 20.0,
                    percent: (index + 1) / widget.listOfQuestions.length,
                    backgroundColor: Colors.grey,
                    progressColor: streakCounter < 3
                        ? const Color(0xff00689d)
                        : const Color(0xffa21942), // const Color(0xffa21942)
                    animation: true,
                    center: Text(
                      "${(((index + 1) / widget.listOfQuestions.length) * 100).truncate()}%",
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Alert(
                      context: context,
                      style: AlertStyle(
                        backgroundColor: Colors.black,
                        animationDuration: const Duration(milliseconds: 300),
                        animationType: AnimationType.fromTop,
                        descStyle: GoogleFonts.roboto(color: Colors.white),
                      ),
                      image: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.lightbulb_sharp,
                          color: Colors.yellow,
                          size: 90,
                        ),
                      ),
                      desc: "You can find the answer to this question",
                      content: InkWell(
                        onTap: () {
                          launchUrl(Uri.parse(
                              widget.listOfQuestions[index]['source']));
                        },
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Here!",
                              style: TextStyle(
                                color: Colors.yellow,
                                fontSize:
                                    28, // You can use any color you prefer
                              ),
                            ),
                          ),
                        ),
                      ),
                      buttons: [
                        DialogButton(
                          onPressed: () => Navigator.pop(context),
                          width: 120,
                          color: const Color(0xff00689d),
                          child: Text(
                            "OK",
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ],
                    ).show();
                  },
                  icon: const Icon(Icons.lightbulb),
                ),
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
                  expandedHeight: MediaQuery.sizeOf(context).height / 2 + 20,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 3,
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: streakCounter < 3
                              ? const Color(0xff00689d)
                              : const Color(0xffa21942),
                          side: const BorderSide(
                              color:
                                  Colors.transparent), // Set your border color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20), // Set your border radius
                          ),
                          padding:
                              const EdgeInsets.all(12), // Set padding as needed
                        ),
                        onPressed: continueButtonTapped
                            ? () {
                                setState(() {
                                  userSubmission = "E";
                                  showShadow = false;
                                  showEye = false;
                                  if (index <
                                      widget.listOfQuestions.length - 1) {
                                    index++;
                                    continueButtonTapped = false;
                                  } else {
                                    Navigator.of(context).pushReplacement(
                                        createRoute(totalPoints, correctCount,
                                            widget.listOfQuestions.length));
                                  }
                                });
                              }
                            : () {
                                if (userInput == 'none' || userInput == 'E') {
                                  Flushbar(
                                    flushbarPosition: FlushbarPosition.TOP,
                                    flushbarStyle: FlushbarStyle.FLOATING,
                                    margin: const EdgeInsets.all(8),
                                    borderRadius: BorderRadius.circular(8),
                                    backgroundColor: const Color(0xffcc1414)
                                        .withOpacity(0.5),
                                    boxShadows: const [
                                      BoxShadow(
                                          color: Colors.black,
                                          offset: Offset(0.0, 2.0),
                                          blurRadius: 3.0)
                                    ],
                                    backgroundGradient:
                                        const LinearGradient(colors: [
                                      Color(0xffa40606),
                                      Color(0xffce0b0b),
                                    ]),
                                    title: "Oops!",
                                    message: "You forgot to choose an answer!",
                                    duration: const Duration(seconds: 1),
                                    icon: const Icon(Icons.info_outline),
                                  ).show(context);
                                } else {
                                  setState(() {
                                    continueButtonTapped = true;
                                    userSubmission = userInput;
                                  });
                                  if (index <
                                      widget.listOfQuestions.length - 1) {
                                    if (widget.listOfQuestions[index]
                                            ['correct_answer'] ==
                                        userInput) {
                                      Flushbar(
                                        flushbarPosition: FlushbarPosition.TOP,
                                        flushbarStyle: FlushbarStyle.FLOATING,
                                        margin: const EdgeInsets.all(8),
                                        borderRadius: BorderRadius.circular(8),
                                        backgroundColor: const Color(0xff00689d)
                                            .withOpacity(0.5),
                                        boxShadows: const [
                                          BoxShadow(
                                              color: Colors.black,
                                              offset: Offset(0.0, 2.0),
                                              blurRadius: 3.0)
                                        ],
                                        backgroundGradient:
                                            const LinearGradient(colors: [
                                          Color(0xff00689d),
                                          Color(0xff00689d),
                                        ]),
                                        title: "Correct",
                                        message:
                                            "+${widget.listOfQuestions[index]['point']}",
                                        duration: const Duration(seconds: 1),
                                        icon: const Icon(Icons.check),
                                      ).show(context).then((result) {
                                        if (streakCounter > 2) {
                                          Flushbar(
                                            flushbarPosition:
                                                FlushbarPosition.TOP,
                                            flushbarStyle:
                                                FlushbarStyle.FLOATING,
                                            margin: const EdgeInsets.all(8),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            backgroundColor:
                                                const Color(0xff00689d)
                                                    .withOpacity(0.5),
                                            boxShadows: const [
                                              BoxShadow(
                                                  color: Colors.black,
                                                  offset: Offset(0.0, 2.0),
                                                  blurRadius: 3.0)
                                            ],
                                            backgroundGradient:
                                                const LinearGradient(colors: [
                                              Color(0xffa21942),
                                              Color(0xffb92653),
                                            ]),
                                            title: "Streak! x$streakCounter",
                                            message: "Keep going!",
                                            duration:
                                                const Duration(seconds: 1),
                                            icon:
                                                const Icon(Icons.airline_stops),
                                          ).show(context);
                                        }
                                      });
                                      setState(() {
                                        streakCounter++;
                                        showShadow = true;
                                        showEye = false;
                                        if(streakCounter > 2 ){
                                          totalPoints +=
                                          widget.listOfQuestions[index]
                                          ['point'] * streakCounter as int;
                                        }
                                        else {
                                          totalPoints +=
                                          widget.listOfQuestions[index]
                                          ['point'] as int;
                                        }
                                        correctCount++;
                                        _isSelected[0] = false;
                                        _isSelected[1] = false;
                                        _isSelected[2] = false;
                                        userInput = "E";
                                        //index++;
                                      });
                                    } else {
                                      Flushbar(
                                        flushbarPosition: FlushbarPosition.TOP,
                                        flushbarStyle: FlushbarStyle.FLOATING,
                                        margin: const EdgeInsets.all(8),
                                        borderRadius: BorderRadius.circular(8),
                                        backgroundColor: const Color(0xffa40606)
                                            .withOpacity(0.5),
                                        boxShadows: const [
                                          BoxShadow(
                                              color: Colors.black,
                                              offset: Offset(0.0, 2.0),
                                              blurRadius: 3.0)
                                        ],
                                        backgroundGradient:
                                            const LinearGradient(colors: [
                                          Color(0xffa40606),
                                          Color(0xffce0b0b),
                                        ]),
                                        title: "Wrong",
                                        message: "+0",
                                        duration: const Duration(seconds: 1),
                                        icon: const Icon(Icons.close),
                                      ).show(context);
                                      setState(() {
                                        showShadow = true;
                                        showEye = false;
                                        _isSelected[0] = false;
                                        _isSelected[1] = false;
                                        _isSelected[2] = false;
                                        userInput = "E";
                                        streakCounter = 0;
                                        // index++;
                                      });
                                    }
                                  } else {
                                    if (widget.listOfQuestions[index]
                                            ['correct_answer'] ==
                                        userInput) {
                                      Flushbar(
                                        flushbarPosition: FlushbarPosition.TOP,
                                        flushbarStyle: FlushbarStyle.FLOATING,
                                        margin: const EdgeInsets.all(8),
                                        borderRadius: BorderRadius.circular(8),
                                        backgroundColor: const Color(0xff00689d)
                                            .withOpacity(0.5),
                                        boxShadows: const [
                                          BoxShadow(
                                              color: Colors.black,
                                              offset: Offset(0.0, 2.0),
                                              blurRadius: 3.0)
                                        ],
                                        backgroundGradient:
                                            const LinearGradient(colors: [
                                          Color(0xff00689d),
                                          Color(0xff00689d),
                                        ]),
                                        title: "Correct",
                                        message:
                                            "+${widget.listOfQuestions[index]['point']}",
                                        duration: const Duration(seconds: 1),
                                        icon: const Icon(Icons.check),
                                      ).show(context);
                                      setState(() {
                                        if(streakCounter > 2 ){
                                          totalPoints +=
                                              widget.listOfQuestions[index]
                                              ['point'] * streakCounter as int;
                                        }
                                        else {
                                          totalPoints +=
                                          widget.listOfQuestions[index]
                                          ['point'] as int;
                                        }
                                        correctCount++;
                                        streakCounter++;
                                      });
                                    } else {
                                      Flushbar(
                                        flushbarPosition: FlushbarPosition.TOP,
                                        flushbarStyle: FlushbarStyle.FLOATING,
                                        margin: const EdgeInsets.all(8),
                                        borderRadius: BorderRadius.circular(8),
                                        backgroundColor: const Color(0xffa40606)
                                            .withOpacity(0.5),
                                        boxShadows: const [
                                          BoxShadow(
                                              color: Color(0xff1f261a),
                                              offset: Offset(0.0, 2.0),
                                              blurRadius: 3.0)
                                        ],
                                        backgroundGradient:
                                            const LinearGradient(colors: [
                                          Color(0xffa40606),
                                          Color(0xffce0b0b),
                                        ]),
                                        title: "Wrong",
                                        message: "+0",
                                        duration: const Duration(seconds: 1),
                                        icon: const Icon(Icons.close),
                                      ).show(context);
                                    }
                                    setState(() {
                                      showShadow = true;
                                      showEye = false;
                                    });
                                  }
                                }
                              },
                        child: Text(
                          continueButtonTapped ? 'Continue' : 'Answer',
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              color: Colors.white),
                        )),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                      flex: 1,
                      child: OutlinedButton(
                          onPressed: (continueButtonTapped || revealCounter < 1)
                              ? null
                              : () {
                            Alert(
                              context: context,
                              style: AlertStyle(
                                backgroundColor: Colors.black,
                                animationDuration:
                                const Duration(milliseconds: 300),
                                animationType: AnimationType.fromTop,
                                descStyle: GoogleFonts.roboto(
                                    color: Colors.white),
                              ),
                              image: const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Icon(
                                  FontAwesomeIcons.eye,
                                  color: Colors.blue,
                                  size: 80,
                                ),
                              ),
                              desc:
                              "Would you like to reveal the answer?",
                              content: Center(child: Text("${revealCounter} / ${revealTotal}",style: GoogleFonts.roboto(fontSize: 26,color:Colors.red))),
                              buttons: [
                                DialogButton(
                                  onPressed: () {
                                    Navigator.pop(context,
                                        false); // Passing false means "No"
                                  },
                                  width: 120,
                                  color: Colors.red,
                                  child: Text(
                                    "No",
                                    style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                                DialogButton(
                                  onPressed: () {
                                    setState(() {
                                      if (revealCounter > 0){
                                        showShadow = true;
                                        showEye = true;
                                        revealCounter--;
                                      }
                                    });
                                    print(revealCounter);
                                    Navigator.pop(context,
                                        true); // Passing true means "Yes"
                                  },
                                  width: 120,
                                  color: Colors.blue,
                                  child: Text(
                                    "Yes",
                                    style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              ],
                            ).show();
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: Colors
                                    .transparent), // Set your border color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20), // Set your border radius
                            ),
                            padding: const EdgeInsets.all(
                                12), // Set padding as needed
                            backgroundColor: const Color(0xff1c1c28),
                            foregroundColor: Colors.white,
                          ),
                          child: Icon(continueButtonTapped || revealCounter < 1
                              ? FontAwesomeIcons.eyeSlash
                              : FontAwesomeIcons.eye))),
                ],
              ),
            )),
      ),
    );
  }
}
