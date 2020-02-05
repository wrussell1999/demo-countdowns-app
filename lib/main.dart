import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hackathon Countdowns',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MyHomePage(title: 'Hackathon Demo Countdown Controller'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  //final databaseReference = FirebaseDatabase.instance.reference();


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _counter = 0;
  int _currentValue = 1;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });

  
  }



  void _startTimer() {
    FirebaseDatabase.instance.reference().child('countdown')
      .set({
      'start': true,
      'time': _currentValue,
    });
  }

  void _stopTimer() {
    FirebaseDatabase.instance.reference().child('countdown')
        .set({
      'start': false
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '0:00',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 80),
            ),
            new Text(
                "Minutes: $_currentValue",
                style: TextStyle(fontSize: 30),
            ),
            new NumberPicker.integer(
                initialValue: _currentValue,
                minValue: 1,
                maxValue: 30,
                onChanged: (newValue) =>
                    setState(() => _currentValue = newValue)),
            new RaisedButton(
              padding: const EdgeInsets.all(8.0),
              textColor: Colors.white,
              color: Colors.pink,
              onPressed: _startTimer,
              child: new Text("Start"),
            ),
            new RaisedButton(
              padding: const EdgeInsets.all(8.0),
              textColor: Colors.white,
              color: Colors.pink,
              onPressed: _stopTimer,
              child: new Text("Stop"),
             ),

          ],
        ),
      ),
      appBar: AppBar(
        title: Text(widget.title),
      ),
    );
  }
}