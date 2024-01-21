import 'package:animate_gradient/animate_gradient.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermojiController.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sdg_thesis/customization_page.dart';
import 'package:sdg_thesis/home_page.dart';
import 'auth.dart';
import 'firebase_options.dart';
import 'Personal Page/personal_widget_tree.dart';

//name at the top right
String name = "Guest";

//uuid used for storing favorites/watchlist/completed for specific device
String v1 = "";

User? user = Auth().currentUser;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //firebase stores locally on the device
  FirebaseDatabase.instance.setPersistenceEnabled(true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
    const CustomizationPage(),
    const MyHomePage(),
    //const LoginScreen(),
    const WidgetTree()
  ];

  int _selectedIndex = 0;

  // List<Color> colors = [Colors.amber, Colors.blue, Colors.green, Colors.red];
  List<Color> colors = [Colors.amber, Colors.blue, Colors.green, Colors.red];
  List<String> titles = ["Home", "Avatar Palette", "Leaderboard", "Account"];
  List<IconData> icons = [
    Icons.home,
    Icons.palette,
    Icons.leaderboard,
    Icons.person
  ];

  List<Color> gradientColors = [
    const Color(0xff1f005c),
    const Color(0xff5b0060),
    const Color(0xff870160),
    const Color(0xffac255e),
    const Color(0xffca485c),
    const Color(0xffe16b5c),
    const Color(0xfff39060),
    const Color(0xffffb56b),
  ];

  @override
  void initState() {
    Get.put(FluttermojiController());
    super.initState();
  }

 // final _loggedIn = Auth().authStateChanges;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // used to hide keyboard on press
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: AnimateGradient(
        primaryColors: const [
          Color(0xff160041),
          Color(0xff410046),
          Color(0xff600145),
          Color(0xff7c1c43),
        ],
        secondaryColors: const [
          Color(0xff752933),
          Color(0xff803c36),
          Color(0xff5d3823),
          Color(0xff644525),
        ],
        child: Scaffold(
          //resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            // title: Text(
            //   titles[_selectedIndex],
            //   style: GoogleFonts.roboto(
            //       fontSize: 25.0, color: colors[_selectedIndex]),
            // ),
            title: Row(
              children: [
                Icon(
                  icons[_selectedIndex],
                  color: colors[_selectedIndex],
                  size: 25.0,
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Text(
                  titles[_selectedIndex],
                  style: GoogleFonts.roboto(fontSize: 25.0),
                )
              ],
            ),
            // actions: [
            //   // Text(
            //   //   user != null? name = user?.email! as String : name = name,
            //   //   style: GoogleFonts.roboto(fontSize: 20.0, color: Colors.white),
            //   // ),
            //   StreamBuilder(
            //     stream: _loggedIn,
            //     builder: (context, snapshot) {
            //       switch (snapshot.connectionState) {
            //         case ConnectionState.none:
            //           return const CircularProgressIndicator();
            //         case ConnectionState.waiting:
            //           return const Center(
            //             child: CircularProgressIndicator(),
            //           );
            //         case ConnectionState.active:
            //           if (snapshot.hasData) {
            //             return Text(
            //                 style: GoogleFonts.roboto(fontSize: 15.0),
            //                 "${user?.email}" ?? "Guest");
            //           } else {
            //             return Text(
            //                 style: GoogleFonts.roboto(fontSize: 15.0), "Guest");
            //           }
            //         case ConnectionState.done:
            //           if (snapshot.hasData) {
            //             return Text(
            //                 style: GoogleFonts.roboto(fontSize: 15.0),
            //                 "${user?.email}" ?? "Guest");
            //           } else {
            //             return const Text("Guest");
            //           }
            //       }
            //     },
            //   ),
            //   //IconButton(onPressed: (){}, icon: const Icon(Icons.person,size: 25,))
            // ],
          ),
          //iterating body
          body: views[_selectedIndex],

          //bottom navigation that controls iteration of body
          bottomNavigationBar: Container(
            color: Colors.transparent,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: GNav(
                backgroundColor: Colors.transparent,
                tabBackgroundColor: Colors.grey
                    .withOpacity(0.1), // selected tab background color
                padding: const EdgeInsets.all(14),
                gap: 10,
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
                    hoverColor: colors[0],
                    icon: icons[0],
                    text: titles[0],
                    iconActiveColor: Colors.amber,
                  ),
                  GButton(
                    hoverColor: colors[1],
                    icon: icons[1],
                    text: titles[1],
                    iconActiveColor: Colors.blue,
                  ),
                  GButton(
                    hoverColor: colors[2],
                    icon: icons[2],
                    text: titles[2],
                    iconActiveColor: Colors.green,
                  ),
                  GButton(
                    hoverColor: colors[3],
                    icon: icons[3],
                    text: titles[3],
                    iconActiveColor: Colors.red,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
