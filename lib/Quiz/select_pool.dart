import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdg_thesis/Quiz/questions.dart';

class SelectPool extends StatefulWidget {
  const SelectPool({super.key, required this.listOfQuestions, required this.poolText});
  final List<dynamic> listOfQuestions;
  final List<dynamic> poolText;

  @override
  State<SelectPool> createState() => _SelectPoolState();
}

class _SelectPoolState extends State<SelectPool> {
  List<bool> _isSelected = List.generate(3, (index) => index == 2); // Initializing with the last item selected
  List<IconData> poolIcon = [Icons.local_activity, Icons.label, Icons.abc];

  int poolIndex = 2; // Initializing with the last index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            height: 260,
            child: ListView.builder(
              itemCount: widget.poolText.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 20.0,
                    left: 5.0,
                    right: 5.0,
                    top: 10.0,
                  ),
                  child: SizedBox(
                    height: 60,
                    child: ListTile(
                      selectedTileColor: const Color(0xff00689d),
                      selected: _isSelected[index],
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Color(0xff00689d), width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      title: Text(
                        widget.poolText[index],
                        style: GoogleFonts.roboto(fontSize: 20.0, color: Colors.white),
                      ),
                      leading: Icon(poolIcon[index]),
                      onTap: () {
                        setState(() {
                          _isSelected = List.generate(widget.poolText.length, (i) => i == index);
                          poolIndex = index;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Questions(
                    listOfQuestions: widget.listOfQuestions[poolIndex] as List<dynamic>,
                  ),
                ),
              );
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }
}

