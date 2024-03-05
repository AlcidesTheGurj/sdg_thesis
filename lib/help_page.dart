import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _markdownData = """
  ![](https://firebasestorage.googleapis.com/v0/b/sdg-thesis.appspot.com/o/images%2Flogo_transparent.png?alt=media&token=fb29f855-b79a-4952-9f33-c07d029c73ca)
  
  ### This page outlines all important information needed to enjoy SDG Quest.
  
  ## Purpose:
  #### 1. SDG Quest is an Educational Game with a triple goal: 
   * To raise awareness about the United Nations’ (UN) seventeen (17) Sustainable Development Goals (SDGs).
   * To help you gain new conceptual knowledge about social, environmental, and economic sustainability
   * To inspire you to reflect on your attitudes on social, environmental, and economic matters
   * To enable positive behavioural changes, contributing to a better world for all!
   * Therefore, it is important to make use of the "Hints" to explore the official United Nations (UN) resources to acquire key knowledge, attitudes, and skills!
   
  ## Game Mechanics:
  ### 1. Progression
   * “EXPERIENCE” and “POINTS” are used interchangeably to refer to the Rewards System of the SDG Quest game.
   * Points/Experience can be gained by selecting  Game-mode in the Home Page and answering the Quiz Questions.
   * Answering correctly awards points allocated to that question
   * Wrong answers have no impact on Points/Experience
   * Every 100 experience a "LEVEL" is gained
      * Eventually all content can be unlocked by leveling up
   
  ### 2. Quiz
  * Answering 3 questions correctly in a row enables "STREAK MODE"
  * Streak counter refers to the number of correct answers in a row
  * Questions answered under "STREAK MODE" provide the original point value MULTIPLIED by the streak counter
  * Answering incorrectly sets the streak counter to 0
      * Reveal Answer
      * The number of reveals depends on the size of the Quiz selected
      * Revealing an answer DOES NOT reset streak counter
      * Points gained for the revealed answer are NOT multiplied by streak counter
  ### 3. Certificate
  * The certificate of completion can ONLY be gained though Challenge mode
  * Challenge mode is unlocked at "LEVEL 10"
  * During challenge mode the "Reveal Answer" feature is disabled
  * During challenge mode the "Hint" feature is disabled
 
""";



    return Scaffold(backgroundColor: Color(0xff212130),
      appBar: AppBar(backgroundColor: Color(0xff212130),),
      body: Markdown(data: _markdownData,)
    );
  }
}
