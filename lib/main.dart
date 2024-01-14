import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sdg_thesis/blank_page.dart';
import 'package:sdg_thesis/home_page.dart';
import 'package:sdg_thesis/Personal%20Page/personal_user_page.dart';
import 'auth.dart';
import 'firebase_options.dart';
import 'Personal Page/personal_widget_tree.dart';
import 'login_page.dart';

//name at the top right
String name = "Guest";

//uuid used for storing favorites/watchlist/completed for specific device
String v1 = "";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //firebase stores locally on the device
  FirebaseDatabase.instance.setPersistenceEnabled(true);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);

  //final User? user = Auth().currentUser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //list used to iterate through views
  final List<Widget> views = [
    const MyHomePage(),
     const BlankPage(),
    const LoginScreen(),
     const WidgetTree()
  ];

  int _selectedIndex = 0;

 // List<Color> colors = [Colors.amber, Colors.blue, Colors.green, Colors.red];
  List<Color> colors = [Colors.amber, Colors.amber, Colors.amber, Colors.amber];
  List<String> titles = ["Home","Points Shop","Leaderboard","Account"];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // used to hide keyboard on press
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              titles[_selectedIndex],
              style: GoogleFonts.roboto(
                  fontSize: 25.0, color: colors[_selectedIndex]),
            ),
            actions: [
              Text(
                name,
                style: GoogleFonts.roboto(fontSize: 20.0, color: Colors.white),
              ),
            ]),
        //iterating body
        body: views[_selectedIndex],

        //bottom navigation that controls iteration of body
        bottomNavigationBar: Container(
          color: Colors.black,
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: GNav(
              backgroundColor: Colors.black,
              tabBackgroundColor:
              Colors.grey.withOpacity(0.1), // selected tab background color
              padding: const EdgeInsets.all(14),
              gap: 8,
              haptic: true,
              iconSize: 26, // tab button icon size
              curve: Curves.bounceIn,
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              tabs: [
                GButton(
                  hoverColor: Colors.amber,
                  icon: Icons.home,
                  text: titles[0],
                  iconActiveColor: Colors.amber,
                ),
                GButton(
                  hoverColor: Colors.blue,
                  icon: Icons.shopping_cart_sharp,
                  text: titles[1],
                  iconActiveColor: Colors.blue,
                ),
                GButton(
                  hoverColor: Colors.green,
                  icon: Icons.leaderboard_sharp,
                  text: titles[2],
                  iconActiveColor: Colors.green,
                ),
                GButton(
                  hoverColor: Colors.red,
                  icon: Icons.person,
                  text: titles[3],
                  iconActiveColor: Colors.red,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}