import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiver/async.dart';


class LivePage extends StatefulWidget {

  @override
  _LivePageState createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  final database = Firestore.instance.collection('countdown');
  
  int _countdownTime = 1;
  bool _state = false;
  int _secondsSinceEpoch = DateTime.now().toUtc().millisecondsSinceEpoch;
  CountdownTimer countdownTimer;
  String _countdownText = "0:00";
  Color backgroundColour = Colors.white;
  Color textColour = Colors.black;


  void _startCountdown(var length) {
    if (countdownTimer == null) {
      countdownTimer = new CountdownTimer(
        new Duration(milliseconds: length + 1000),
        new Duration(seconds: 1),
      );
      _runCountdown();
    } else if (countdownTimer.isRunning == false) {
      countdownTimer = new CountdownTimer(
        new Duration(milliseconds: length + 1000),
        new Duration(seconds: 1),
      );
      _runCountdown();
    }
  }

  void _runCountdown() {
    var sub = countdownTimer.listen(null);

    sub.onData((duration) {
      setState(() {
        int minutes = duration.remaining.inMinutes;
        String seconds = (duration.remaining.inSeconds % 60).toString().padLeft(2, '0');
        _countdownText = "$minutes:$seconds"; 

        if (duration.remaining.inSeconds < 20 && duration.remaining.inSeconds % 2 == 1) {
          backgroundColour = Colors.red;
          textColour = Colors.white; 
        } else {
          backgroundColour = Colors.white;
          textColour = Colors.black; 
        }
      });

      sub.onDone(() {
        _state = false;
        backgroundColour = Colors.white;
        textColour = Colors.black;
        sub.cancel();
      });
    }); 
  }

  void _stopCountdown() {
    _state = false;
    _countdownText = "0:00";
    if (countdownTimer != null) {
      countdownTimer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Countdown Live View"),
      ),
      body: Container(
        decoration: new BoxDecoration(color: backgroundColour),
        child: new Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Time Remaining:',
                style: new TextStyle(
                  color: textColour,
                  fontSize: 20
                )
              ),
              StreamBuilder(
                stream: database.document('1').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && !snapshot.hasError && snapshot.data.data.values != null) {
                    Map data = snapshot.data.data;
                    _state = data['start'];
                    _countdownTime = data['time'];
                    _secondsSinceEpoch = data['epoch'];
                    if (_state == false) {
                      _stopCountdown();
                      _countdownText = "$_countdownTime:00";
                    } else if (_state == true) {
                      var diff =  _secondsSinceEpoch - DateTime.now().toUtc().millisecondsSinceEpoch;
                      _startCountdown(diff);
                    }
                    return Text("$_countdownText",
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 150,
                          color: textColour)
                    );
                  }
                  else
                    return Text("Error: No Time");
                },
              ),
            ],
          ),
        ),
      )
    );
  }
}
