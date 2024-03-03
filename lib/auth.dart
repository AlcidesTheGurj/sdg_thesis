import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sdg_thesis/main.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    String? userUuid = _firebaseAuth.currentUser?.uid;
    if (userUuid != null){
      //DatabaseReference ref = FirebaseDatabase.instance.ref(userUuid);
      // await ref.set({
      //   "name": "test",
      //   "age": 18,
      //   "address": {
      //     "line1": "100 Mountain View"
      //   }
      // });
    }

    if (userUuid != null){
      DatabaseReference ref = FirebaseDatabase.instance.ref("Players/$userUuid");
      await ref.update({
        'email': email,
        'displayName': name,
      });
    }
    user = Auth().currentUser;
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    String? userUuid = _firebaseAuth.currentUser?.uid;
    if (userUuid != null){
      DatabaseReference ref = FirebaseDatabase.instance.ref("Players/$userUuid");
      await ref.set({
        "email": email,
        "total_points": 0,
        "displayName": name,
        "order": 9999999999
      });
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    user = null;
  }

  // GoogleSignIn _googleSignIn = GoogleSignIn(
  //     scopes: <String>[
  //       'email',
  //       'https://www.googleapis.com/auth/contacts.readonly',
  //     ]
  // );


  Future<dynamic> signInWithGoogle() async {
    try {
      // Sign in with Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Sign in with Firebase Authentication
      final UserCredential authResult =
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Get the authenticated user
      user = authResult.user;

      // Add the user to the Realtime Database under "Players"
      if (user != null) {
        DatabaseReference ref =
        FirebaseDatabase.instance.ref().child("Players").child(user!.uid);

        await ref.update({
          'displayName': user!.displayName,
          'email': user!.email,
        });

        DataSnapshot snapshot = await ref.get();
        Map<Object?, Object?>? userData = snapshot.value as Map<Object?, Object?>?;

        if (userData == null || !userData.containsKey('order')) {
          // 'order' doesn't exist, set the value
          await ref.update({
            'order': 9999999999
          });
        }
      }

      return authResult;
    } on Exception catch (e) {
      print('Exception: $e');
      // Handle exceptions as needed
    }
  }

  Future<bool> signOutFromGoogle() async {
    try {
      // Sign out from Firebase Authentication
      await FirebaseAuth.instance.signOut();

      // Sign out from Google Sign-In
      await GoogleSignIn().signOut();

      return true;
    } on Exception catch (_) {
      return false;
    }
  }
}
