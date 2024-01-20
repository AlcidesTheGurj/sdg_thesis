import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart' as firedatabase;

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

  late int playerScore;

  final myController = TextEditingController();

  String title = "";

  @override
  void initState() {
    super.initState();
    firedatabase.Query dbRef =
        firedatabase.FirebaseDatabase.instance.ref().child('Gamemodes');
    print(widget.listOfQuestions);
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
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                    "Question ${index + 1} of ${widget.listOfQuestions.length}",
                    style: const TextStyle(fontSize: 22.0)),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  widget.listOfQuestions[index]['question'].toString(),
                  style: const TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                const Padding(padding: EdgeInsets.all(10.0)),
                TextFormField(
                  controller: myController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Enter Answer',
                      labelStyle: const TextStyle(fontSize: 18)),
                ),
                MaterialButton(
                    minWidth: 240.0,
                    height: 30.0,
                    color: Colors.blue,
                    onPressed: () {
                      if (myController.text ==
                          widget.listOfQuestions[index]['answer'].toString()) {
                        setState(() {
                          index++;
                        });
                        //debugPrint("snapshot key-------------------> ${widget.competitionId}");
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
