import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:countdown_flutter/countdown_flutter.dart';

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

  int _currentValue = 1;
  bool _state = false;
  String _countdown;

  void _startCountdown() {
    _state = true;
    updateCountdown();
  }

  void _stopCountdown() {
    _state = false;
    updateCountdown();
  }

  void _changeTimer(_newTime) {
    _state = false;
    _currentValue = _newTime;
    updateCountdown();
    
  }

  void updateCountdown() {
    print(_currentValue);
    print(_state);
    print(_countdown);
    FirebaseDatabase.instance.reference().child('countdown')
      .update({
        'start': _state,
        'time': _currentValue
      });
  }

  void getCountdown(){
    FirebaseDatabase.instance.reference().once().then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: CountdownFormatted(
                duration: Duration(minutes: _currentValue),
                builder: (BuildContext ctx, String remaining) {
                  return Text(
                    remaining,
                    overflow: TextOverflow.ellipsis,
                    style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 100),
                  ); // 01:00:00
                },
              ),
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