import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _currentValue = 1;
  bool _state = false;

  void _startTimer() {
    _state = true;
    _setTimer();
  }

  void _stopTimer() {
    _state = false;
    _setTimer();
  }

  void _changeTimer(_newTime) {
    _state = false;
    _currentValue = _newTime;
    _setTimer();
    
  }

  void _setTimer() {
    print(_currentValue);
    print(_state);
    FirebaseDatabase.instance.reference().child('countdown')
      .set({
        'start': _state,
        'time': _currentValue
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
                  fontSize: 100),
            ),
            SizedBox(height: 80),
            new Text(
                "$_currentValue Minutes",
                style: TextStyle(fontSize: 30),
            ),
            new NumberPicker.integer(
                initialValue: _currentValue,
                minValue: 1,
                maxValue: 30,
                onChanged: (newValue) =>
                    setState(() => _changeTimer(newValue))),
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