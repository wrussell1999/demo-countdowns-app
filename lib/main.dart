import 'dart:async';

import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:quiver/async.dart';

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
      home: MyHomePage(title: 'Countdown Controller'),
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

  StreamSubscription _subscriptionTime;

  int _currentValue = 3;
  int _current = 10;
  bool _state = false;
  String _countdown = "0:00";
  CountdownTimer countdownTimer;

  void _startCountdown() {
    _state = true;
    updateCountdown();
    countdownTimer = new CountdownTimer(
      new Duration(minutes: _currentValue),
      new Duration(seconds: 1),
    );

    var sub = countdownTimer.listen(null);

    sub.onData((duration) {
      setState(() { 
        int minutes = duration.remaining.inMinutes;
        String seconds = (duration.remaining.inSeconds % 60).toString().padLeft(2, '0');
        _countdown = "$minutes:$seconds"; 
    });

    sub.onDone(() {
      print("Done");
      sub.cancel();
    });
  });
    
  }

  void _stopCountdown() {
    _state = false;
    updateCountdown();
    countdownTimer.cancel();
    _countdown = "0:00";
  }

  void _changeCountdown(_newTime) {
    _state = false;
    _currentValue = _newTime;
    updateCountdown();
    
  }
  void listenForChanges() {
    StreamSubscription<Event> subscription = database.onValue.listen((event) {print(event.snapshot.value.toString());});
  }

  void updateCountdown() {
    database
      .update({
        'start': _state,
        'time': _currentValue
      });
    if (!_state) {
      getCountdown();
    }
  }

  void getCountdown() {
    database.once().then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value}');
      Map<dynamic, dynamic> map = snapshot.value;
      _currentValue = map.values.toList()[1];
    });
  }

  @override
  void initState() {
    //listenForChanges();
    super.initState();
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
                "Set Minutes:",
                style: TextStyle(fontSize: 25),
            ),
            new NumberPicker.integer(
                initialValue: _currentValue,
                minValue: 1,
                maxValue: 9,
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

