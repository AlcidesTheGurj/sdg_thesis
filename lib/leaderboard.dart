import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({super.key});

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  DatabaseReference _playersRef =
  FirebaseDatabase.instance.ref().child('Leaderboard');

  @override void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FirebaseAnimatedList(
        query: _playersRef.orderByChild('order').limitToLast(50),
          itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          Map<dynamic, dynamic>? user = snapshot.value as Map<dynamic, dynamic>?;
          return _buildListItem(user, index);
        },
      ),
    );
  }

  Widget _buildListItem(Map? user, int index) {
    if (user == null) {
      // Handle the case where user is null (optional)
      return Container();
    }

    Color containerColor =
    Colors.grey;

    // if (index == 0 ){
    //    containerColor = Color(0xff1c1c28).withOpacity(0.8);
    // }
    // else if (index == 1) {
    //   containerColor = Color(0xff42424d).withOpacity(0.8);
    // }

    Color containerShadow = Colors.transparent;
    Color containerText = Colors.white;

    if (index == 0) {
      containerShadow = Colors.yellow;
      containerText = Colors.white;
      containerColor = Color(0xff160041);
    }
    else if (index == 1){
      containerShadow = Colors.yellow;
      containerText = Colors.white;
      containerColor =  Color(0xff7c1c43);
    }
    else if (index == 2){
      containerShadow = Colors.yellow;
      containerText = Colors.white;
      containerColor = Color(0xff5d3823);
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
      padding: const EdgeInsets.all(10),
      height: 95,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: containerShadow,
            offset: const Offset(0.0, 0.0),
            blurRadius: 15.0,
          ),
        ],
        color: containerColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          user['displayName'] ?? '',style: GoogleFonts.roboto(color:containerText,fontSize: 24)
        ),
        trailing: index < 3 ?  Icon(FontAwesomeIcons.crown) : null,
        subtitle: Text(
          "Lvl. ${(user['total_points'] / 100).floor()}",style: GoogleFonts.roboto(color:containerText,fontSize: 18),
        ),
        leading: Text("${index + 1}", style: GoogleFonts.roboto(fontSize: 24,fontWeight:FontWeight.bold,color:containerText),),
      ),
    );
  }

}
