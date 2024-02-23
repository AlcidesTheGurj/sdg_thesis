import 'package:animate_gradient/animate_gradient.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sdg_thesis/Quiz/questions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  List<IconData> poolIcon = [
    FontAwesomeIcons.envira,
    FontAwesomeIcons.handshakeAngle,
    FontAwesomeIcons.dollarSign
  ];
  List<Color> poolColor = [
    const Color(0xff4c9f38),
    const Color(0xff19486a),
    const Color(0xffbf8b2e)
  ];
  //int poolIndex = 2; // Initializing with the last index

  @override
  void initState() {
    // poolSize = widget.poolText.length;
    // _isSelected = List.generate(poolSize, (index) => index == 2); // Initialize with the last item selected
    super.initState();
  }

  Widget poolWidget({required String poolText, required int index}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 15, 10, 15),
      padding: const EdgeInsets.all(8),
      height: 120,
      decoration: BoxDecoration(
        color:
            widget.poolText.length > 3 ? sdgColours[index] : poolColor[index],
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
                child: widget.poolText.length > 3
                    ? Image.asset(
                        "images/default/$index-web.png",
                        fit: BoxFit.fill,
                      )
                    : Center(
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.transparent)),
                            child: FaIcon(
                              poolIcon[index],
                              size: 35,
                            )))),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Text(
                poolText,
                style: GoogleFonts.roboto(fontSize: 18.0, color: Colors.white),
              ),
            ),
          ],
        ),
        onTap: () {
          //Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            // MaterialPageRoute(
            //   builder: (context) => Questions(
            //     listOfQuestions: gamemode['questions'],
            //   ),
            // ),
            MaterialPageRoute(
              builder: (context) => Questions(
                listOfQuestions: widget.listOfQuestions[index],
                index: index,
                gameMode: widget.poolText.length,
              ),
            ),
          );
        },
      ),
    );
  }

  List<Color> primaryGradientColors = [
    const Color(0xff212130),
    const Color(0xff212130),
    const Color(0xff212130),
    const Color(0xff212130),
  ];

  List<Color> secondaryGradientColors = [
    const Color(0xff39304a),
    const Color(0xff39304a),
    const Color(0xff39304a),
    const Color(0xff39304a),
  ];

  List<Color> sdgColours = [
    const Color(0xffe5243b),
    const Color(0xffdda63a),
    const Color(0xff4c9f38),
    const Color(0xffc5192d),
    const Color(0xffff3a21),
    const Color(0xff26bde2),
    const Color(0xfffcc30b),
    const Color(0xffa21942),
    const Color(0xfffd6925),
    const Color(0xffdd1367),
    const Color(0xfffd9d24),
    const Color(0xffbf8b2e),
    const Color(0xff3f7e44),
    const Color(0xff0a97d9),
    const Color(0xff56c02b),
    const Color(0xff00689d),
    const Color(0xff19486a),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimateGradient(
      primaryColors: primaryGradientColors,
      secondaryColors: secondaryGradientColors,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text("Standard"),
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
                    child: SizedBox(
                      width: 120,
                      height: 120,
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://firebasestorage.googleapis.com/v0/b/sdg-thesis.appspot.com/o/images%2FE_SDG_logo_without_UN_emblem_square_CMYK_Transparent.png?alt=media&token=83f19ed2-3a7c-458b-8698-7136559ab3af",
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                expandedHeight: 200,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => poolWidget(
                      poolText: widget.poolText[index], index: index),
                  childCount: widget.poolText.length,
                ),
              ),
            ],
          )),
    );
  }
}
