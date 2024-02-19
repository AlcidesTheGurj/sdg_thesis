import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'mobile.dart';
import 'auth.dart';
import 'main.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({super.key});

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  bool _changeColor = false;

  void _changeBackgroundColor() {
    setState(() => _changeColor = !_changeColor);
    Future.delayed(const Duration(seconds: 1),
        () => setState(() => _changeColor = !_changeColor));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ElevatedButton(onPressed: signInWithGoogle, child: Text("asd")),
        // ElevatedButton(onPressed: signOutWithGoogle, child: Text("asd")),
        GestureDetector(
          onTap: _changeBackgroundColor,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: 100,
            height: 100,
            color: _changeColor ? Colors.red : Colors.green,
            child: ElevatedButton(onPressed: () {}, child: const Text("asd")),
          ),
        ),
        ElevatedButton(
            onPressed: () async {
              _createPDF();
            },
            child: Text("generate pdf")),
      ],
    );
  }

  Future<void> signInWithGoogle() async {
    try {
      await Auth().signInWithGoogle();
    } on FirebaseAuthException catch (e) {
      debugPrint(e as String?);
    }
    if (mounted) {
      setState(() {
        if (user?.email != null) {
          name = user?.email as String;
        }
      });
    }
  }

  Future<void> signOutWithGoogle() async {
    try {
      await Auth().signOutFromGoogle();
    } on FirebaseAuthException catch (e) {
      debugPrint(e as String?);
    }
    if (mounted) {
      setState(() {
        if (user?.email != null) {
          name = user?.email as String;
        }
      });
    }
  }
}

Future<void> _createPDF() async {
  PdfDocument document = PdfDocument();
  final page = document.pages.add();

  //page.graphics.drawString('This is a test certificate if it works gg ez', PdfStandardFont(PdfFontFamily.courier, 26));
// Add title
  page.graphics.drawString('Certificate of Achievement',
      PdfStandardFont(PdfFontFamily.helvetica, 30),
      bounds: Rect.fromLTWH(50, 50, 500, 50));

  // Add text
  page.graphics.drawString(
      'This is to certify that [Student Name] has successfully completed the quiz on SDGs.',
      PdfStandardFont(PdfFontFamily.helvetica, 16),
      bounds: Rect.fromLTWH(50, 120, 500, 200));

  List<int> bytes = await document.save();
  document.dispose();

  saveAndLaunchFile(bytes, 'Certificate.pdf');
}
