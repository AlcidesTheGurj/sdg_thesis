import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectPool extends StatefulWidget {
  const SelectPool({super.key});

  @override
  State<SelectPool> createState() => _SelectPoolState();
}
final List<bool> _isSelected = [false, false, true];
//IconData userInput = Icons.ac_unit;
final List<IconData> poolIcon = [Icons.local_activity,Icons.label,Icons.abc];
final List<String> poolText = ["Environmental Sustainability", "Social Sustainability", "Economic Sustainability"];

class _SelectPoolState extends State<SelectPool> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(),body:
    SizedBox(
      // decoration: BoxDecoration(
      //   color: Colors.green.withOpacity(0.3)
      // ),
      height: 260,
      child: ListView.builder(
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(
                  bottom: 20.0, left: 5.0, right: 5.0, top: 10.0),
              child: SizedBox(
                height: 60,
                child: ListTile(
                  selectedTileColor: const Color(0xff00689d),
                  selected: _isSelected[index],
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                        color: Color(0xff00689d), width: 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  title: Text(
                    '${poolText[index]}',
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
                  leading: Icon(
                    poolIcon[index],
                  ),
                  onTap: () {
                    setState(() {
                      _isSelected[0] = false;
                      _isSelected[1] = false;
                      _isSelected[2] = false;
                      _isSelected[index] = true;
                      //userInput = poolIcon[index];
                      // print(userInput);
                    });
                  },
                ),
              ),
            );
          }),
    ),);
  }
}
