import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
//import 'package:firebase_database/firebase_database.dart' as firedatabase;
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class Questions extends StatefulWidget {
  const Questions(
      {Key? key, required this.competitionId, required this.listOfQuestions})
      : super(key: key);
  final String competitionId;
  final List listOfQuestions;

  @override
  State<Questions> createState() => _QuestionsState();
}

class _QuestionsState extends State<Questions> {
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

  @override
  void initState() {
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
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                progressColor: Colors.blue,
                animation: true,
              ),
            ),
            Row(
              children: [Text("data"),
                BubbleSpecialTwo(
                  text: widget.listOfQuestions[index]['question'].toString(),
                  isSender: false,
                  color: Colors.purple.shade100,
                  tail: true,
                  textStyle: const TextStyle(
                    fontSize: 20,
                    color: Colors.purple,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              widget.listOfQuestions[index]['question'].toString(),
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
            const SizedBox(
              height: 200,
            ),
            SizedBox(
              // decoration: BoxDecoration(
              //   color: Colors.green.withOpacity(0.3)
              // ),
              height: 300,
              child: ListView.builder(
                  itemCount: widget.listOfQuestions[index]['answer'].length,
                  itemBuilder: (BuildContext context, int answerIndex) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          bottom: 20.0, left: 5.0, right: 5.0, top: 10.0),
                      child: SizedBox(
                        height: 60,
                        child: ListTile(
                          selectedTileColor:
                              Colors.greenAccent.withOpacity(0.5),
                          selected: _isSelected[answerIndex],
                          shape: RoundedRectangleBorder(
                            side:
                                const BorderSide(color: Colors.green, width: 1),
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
                  if (widget.listOfQuestions[index]['correct_answer'] ==
                      userInput) {
                    print("YAYYYY");
                  }
                  setState(() {
                    index++;
                  });
                  print(index);
                },
                child: const Text("submit"))
          ],
        ),
      ),
    );
  }
}
