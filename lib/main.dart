import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:firebase_database/firebase_database.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Countdown Controller',
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
  final database = FirebaseDatabase.instance.reference().child('countdown');
  int _currentValue = 1;
  bool _state = false;
  String _countdown = "0:00";

  void _startCountdown() {
    _state = true;
    updateCountdown();
  }

  void _stopCountdown() {
    _state = false;
    updateCountdown();
  }

  void _changeCountdown(_newTime) {
    _state = false;
    _currentValue = _newTime;
    updateCountdown();
    
  }

  void updateCountdown() {
    database
      .update({
        'start': _state,
        'time': _currentValue
      });
    getCountdown();
    _countdown = "$_currentValue:00";
  }

  void getCountdown(){
    database.once().then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value}');
      Map<dynamic, dynamic> map = snapshot.value;
      var minutes = map.values.toList()[1];
      _countdown = "$minutes:00";
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
              "$_countdown",
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
                maxValue: 15,
                onChanged: (newValue) =>
                    setState(() => _changeCountdown(newValue))),
            new RaisedButton(
              padding: const EdgeInsets.all(8.0),
              textColor: Colors.white,
              color: Colors.pink,
              onPressed: _startCountdown,
              child: new Text("Start"),
            ),
            new RaisedButton(
              padding: const EdgeInsets.all(8.0),
              textColor: Colors.white,
              color: Colors.pink,
              onPressed: _stopCountdown,
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