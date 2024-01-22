import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttermoji/fluttermojiFunctions.dart';
import 'package:google_fonts/google_fonts.dart';

import '../auth.dart';
import '../customization_page.dart';

class GuestPage extends StatefulWidget {
  GuestPage({Key? key}) : super(key: key);

  @override
  State<GuestPage> createState() => _GuestPageState();
}

class _GuestPageState extends State<GuestPage> {
  final User? user = Auth().currentUser;

  @override
  void initState() {
    _loadAvatar(context);
    super.initState();
  }

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

  // Widget _userUid() {
  Future<void> signOut() async {
    await Auth().signOut();
  }

  List<bool> hm = [false,false,true,false,true,true,true,true,true,false,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            circleAvatarWidget(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Badges:", style: GoogleFonts.roboto(fontSize: 20.0)),
                ],
              ),
            ),
            /*Image.asset("images/test.png"),
                    SizedBox(
                      width: 10,
                    ),*/
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              height: 150,
              child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 17,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (_, int index) {
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Stack(children: [
                            Image.asset("images/$index.jpg", fit: BoxFit.fill,),
                            Visibility(
                              visible: hm[index],
                              child: FractionallySizedBox(
                                  widthFactor: 1.0,
                                  heightFactor: 1.0,
                                  alignment: Alignment.center,
                                  child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.9)),
                                      child: Icon(Icons.lock))),
                            ),
                          ]),
                        ));
                  }),
            ),
            Text(user?.email ?? 'user email',
                style: GoogleFonts.roboto(fontSize: 16.0)),
            ElevatedButton(
              onPressed: signOut,
              child: Text(
                "Sign Out",
                style: GoogleFonts.roboto(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
