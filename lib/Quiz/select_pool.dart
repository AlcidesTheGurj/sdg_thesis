import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdg_thesis/Quiz/questions.dart';

class SelectPool extends StatefulWidget {
  const SelectPool(
      {super.key, required this.listOfQuestions, required this.poolText});
  final List<dynamic> listOfQuestions;
  final List<dynamic> poolText;

  @override
  State<SelectPool> createState() => _SelectPoolState();
}

class _SelectPoolState extends State<SelectPool> {
  //int poolSize = 0;
  //late List<bool> _isSelected; // Declare _isSelected without initialization

  List<IconData> poolIcon = [Icons.local_activity, Icons.label, Icons.abc];

  //int poolIndex = 2; // Initializing with the last index

  @override
  void initState() {
    // poolSize = widget.poolText.length;
    // _isSelected = List.generate(poolSize, (index) => index == 2); // Initialize with the last item selected
    super.initState();
  }

  Widget poolWidget({required String poolText, required int index}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 30, 10, 0),
      padding: const EdgeInsets.all(10),
      height: 120,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: Colors.black, // Set the color of the border
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ListTile(
            leading: Text(
              poolText,
              style: GoogleFonts.roboto(fontSize: 16.0, color: Colors.white),
            ),
            trailing: Image.asset(
              "images/$index.png",
              fit: BoxFit.fill,
            ),
            onTap: () {
              Navigator.push(
                context,
                // MaterialPageRoute(
                //   builder: (context) => Questions(
                //     listOfQuestions: gamemode['questions'],
                //   ),
                // ),
                MaterialPageRoute(
                  builder: (context) => Questions(
                    listOfQuestions: widget.listOfQuestions[index],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        const SliverAppBar(
          floating: false,
          backgroundColor: Colors.transparent,
          flexibleSpace: FlexibleSpaceBar(
            background: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                width: 180,
                child: Icon(Icons.construction,size: 140,)
              ),
            ),
          ),
          expandedHeight: 220,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) =>
                poolWidget(poolText: widget.poolText[index], index: index),
            childCount: widget.poolText.length,
          ),
        ),
      ],
    ));
  }
}
