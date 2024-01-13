import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth.dart';
import '../main.dart';

class TestPage extends StatefulWidget {
  //final User? user;
   TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  String errorMsg = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword()async{
    try {
      await Auth().signInWithEmailAndPassword(email: _controllerEmail.text,
          password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMsg = e.message!;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword()async{
    try {
      await Auth().createUserWithEmailAndPassword(email: _controllerEmail.text,
          password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMsg = e.message!;
      });
    }
  }

  Widget _title(){
    return const Text("Title");
  }

  Widget _entryField(String title,
      TextEditingController controller,){
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
      ),
    );
  }

  Widget _errorMsg(){
    return Text(errorMsg == '' ? '' : 'ERROR: $errorMsg');
  }

  Widget _submitButton(){
    return ElevatedButton(onPressed: isLogin? signInWithEmailAndPassword : createUserWithEmailAndPassword, child: Text(isLogin ? 'Login' : 'Register'),);
  }

  Widget _loginOrRegisterButton(){
    return TextButton(onPressed: (){
      setState(() {
        isLogin = !isLogin;
      });
    }, child: Text(isLogin ? 'Register instead' : 'Login instead'),);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
        child: Column(
        children: <Widget>[
          _entryField('email', _controllerEmail),
          _entryField('password', _controllerPassword),
          _errorMsg(),
          _submitButton(),
          _loginOrRegisterButton()
        ],
    ),
    );
  }
}