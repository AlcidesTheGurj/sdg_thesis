import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:sdg_thesis/main.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    String? userUuid = _firebaseAuth.currentUser?.uid;
    if (userUuid != null){
      DatabaseReference ref = FirebaseDatabase.instance.ref(userUuid);
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
        'log': true,
      });
    }
    user = Auth().currentUser;
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    String? userUuid = _firebaseAuth.currentUser?.uid;
    if (userUuid != null){
      DatabaseReference ref = FirebaseDatabase.instance.ref("Players/$userUuid");
      await ref.set({
        "points": 0,
      });
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    user = Auth().currentUser;
  }
}
