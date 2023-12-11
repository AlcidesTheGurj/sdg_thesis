import 'package:animated_background/animated_background.dart';
import 'package:animated_background/particles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sdg_thesis/test_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  final String title = 'Flutter Demo Home Page';


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawer(children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              runSpacing: 16,
              children: [
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Option 1'),
                  onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyHomePage())),
                ),
                ListTile(
                  leading: Icon(Icons.update),
                  title: Text('Option 1'),
                  onTap: () { Navigator.pop(context);Navigator.of(context).push(MaterialPageRoute(builder: (context) => TestPage()));},
                ),
                ListTile(
                  leading: Icon(Icons.update),
                  title: Text('Option 1'),
                ),
                ListTile(
                  leading: Icon(Icons.update),
                  title: Text('Option 1'),
                )
              ],
            ),
          ),
        )
      ],),
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(widget.title),
        ),
        body: AnimatedBackground(
          behaviour: RandomParticleBehaviour(
            options: const ParticleOptions(
              spawnMaxRadius: 25,
              spawnMinSpeed: 10.00,
              particleCount: 20,
              spawnMaxSpeed: 100,
              minOpacity: 0.4,
              spawnOpacity: 0.9,
              baseColor: Colors.blue,
              image: Image(image: AssetImage('images/test.png')),

            ),
          ),
          vsync: this,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'TEST',
                ),
                Expanded(child: StreamBuilder(
                  stream: _firestore.collection("Test").snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Text('No data available');
                    }
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return CircularProgressIndicator();
                      default:
                        return buildListView(snapshot);
                    }
                  },
                ))
              ],
            ),
          ),
        )
    );
  }

  Widget buildListView(AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView(
      children: snapshot.data!.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        return ListTile(
          title: Text(data['data'] ?? 'No name'),
          subtitle: Text(data['data2'] ?? 'No description'),
        );
      }).toList(),
    );
  }
}

