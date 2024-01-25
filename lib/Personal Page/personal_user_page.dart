import 'package:fancy_password_field/fancy_password_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth.dart';
import '../main.dart';

class UserPage extends StatefulWidget {
  //final User? user;
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  String errorMsg = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirm = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMsg = e.message!;
      });
    }
    if(mounted){
      setState(() {
        if (user?.email != null){
          name = user?.email as String;
        }
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMsg = e.message!;
      });
    }
    if (mounted){
      setState(() {
        User? user = Auth().currentUser;
        if (user?.email != null){
          name = user?.email as String;
        }
      });
    }
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      obscureText: false,
      decoration: InputDecoration(
          labelText: title,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
      ),
    );
  }

  Widget _errorMsg() {
    return Text(errorMsg == '' ? '' : errorMsg);
  }

  Widget _submitButton() {
    return ElevatedButton(
      style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(
        Color(0xff410046),
      )),
      onPressed: () {
        print("object");
        print(isLogin);
        if (isLogin){
          signInWithEmailAndPassword();
        }
        else {
          if (_controllerPassword.text == _controllerConfirm.text){
           createUserWithEmailAndPassword();
           //  print("Password: ${_controllerPassword.text}");
           //  print("Confirm Password: ${_controllerConfirm.text}");
          }
          else{
            setState(() {
              errorMsg = "Passwords need to match";
            });
          }
        }

        //isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword;
      },child: Text(
        isLogin ? 'Login' : 'Register',
        style: GoogleFonts.roboto(fontSize: 16),
      ),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(isLogin ? 'Register instead' : 'Login instead',
          style: GoogleFonts.roboto(fontSize: 18,color:const Color(0xff00689d),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.only(right: 16.0, left: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            isLogin? "Sign In":"Register",
            style: GoogleFonts.roboto(fontSize: 40),
          ),
          SizedBox(height: 15.0),
          _entryField('email', _controllerEmail),
          SizedBox(
            height: 15,
          ),
          FancyPasswordField(
            hasStrengthIndicator: false,
            hasValidationRules: false,
            decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0))),
            controller: _controllerPassword,
          ),
          SizedBox(
            height: 15,
          ),
          Visibility(
            visible: !isLogin,
            child: FancyPasswordField(
              hasStrengthIndicator: false,
              hasValidationRules: false,
              decoration: InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0))),
              controller: _controllerConfirm,
            ),
            // child:  TextField(
            //   controller: _controllerPassword,
            //   obscureText: true,
            //   decoration: InputDecoration(
            //       labelText: 'Confirm Password',
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(12.0),
            //       ),
            //       suffix: Icon(Icons.remove_red_eye),),
            // ),
          ),
          _errorMsg(),
          _submitButton(),
          _loginOrRegisterButton()
        ],
      ),
    );
  }
}
