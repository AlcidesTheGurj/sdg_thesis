import 'package:sdg_thesis/auth.dart';
import 'package:flutter/material.dart';
import 'user_page.dart';
import 'guest_page.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}


// * Future<void> UserSignedIn()async{
//   FirebaseAuth.instance
//       .authStateChanges()
//       .listen((User? user) {
//     if (user == null) {
//       print('User is currently signed out!');
//     } else {
//       print('User is signed in!');
//       print(user);
//     }
//   });
// }


class _WidgetTreeState extends State<WidgetTree> {

  final List<Widget> views = [
    const GuestPage(),
    const UserPage()
  ];

  final _loggedIn = Auth().authStateChanges;
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: _loggedIn,
    builder: (context,snapshot){
      switch (snapshot.connectionState){
        case ConnectionState.none:
        case ConnectionState.waiting:
          return const Center(child: CircularProgressIndicator(),);
        case ConnectionState.active:
          if (snapshot.hasData){
            return const GuestPage();
          }
          else {
            return const UserPage();
          }
        case ConnectionState.done:
          if (snapshot.hasData){
            return const GuestPage();
          }
          else {
            return const UserPage();
          }
      }
    },
    );
  }
}
