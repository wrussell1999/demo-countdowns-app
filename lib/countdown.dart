import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiver/async.dart';

class CountdownPage extends StatefulWidget {
  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage> {
  var database = Firestore.instance.collection('countdown');

  int _countdownTime = 1;
  bool _state = false;
  int _secondsSinceEpoch = DateTime.now().toUtc().millisecondsSinceEpoch;
  CountdownTimer countdownTimer;
  String _countdownText = "0:00";

  void _startCountdown() {
    _state = true;
    // Work out in milliseconds how long left
    var now = DateTime.now().toUtc().millisecondsSinceEpoch;
    _secondsSinceEpoch = DateTime.now().add(Duration(minutes: _countdownTime)).millisecondsSinceEpoch;
    var diff =  _secondsSinceEpoch - now;
    updateCountdown();
    _doCountdown(diff);
  }

  void _overrideCountdown() {
    _state = true;

    var now = DateTime.now().toUtc().millisecondsSinceEpoch;
    var diff = _secondsSinceEpoch - now;
    updateCountdown();
    _doCountdown(diff);
  }

  void _stopCountdown() {
    _state = false;
    updateCountdown();
    _countdownText = "0:00";
    countdownTimer.cancel();
  }

  void _changeCountdown(_newTime) {
    _countdownTime = _newTime;
    _secondsSinceEpoch = DateTime.now().toUtc().add(Duration(minutes: _newTime)).millisecondsSinceEpoch;
    updateCountdown();
  }

  void updateCountdown() {
    try {
      database..document('1').updateData({
          'start': _state,
          'time': _countdownTime,
          'epoch': _secondsSinceEpoch
        });
    } catch (e) {
      print(e.toString());
    }
  }

  void _doCountdown(var length) {
    // Start Countdown
    countdownTimer = new CountdownTimer(
      new Duration(milliseconds: length + 1000),
      new Duration(seconds: 1),
    );

    var sub = countdownTimer.listen(null);

    sub.onData((duration) {
      setState(() {

        int minutes = duration.remaining.inMinutes;
        String seconds = (duration.remaining.inSeconds % 60).toString().padLeft(2, '0');
        _countdownText = "$minutes:$seconds"; 
      });

      sub.onDone(() {
        _state = false;
        updateCountdown();
        //showAlertDialog(context);
        sub.cancel();
      });
    }); 
  }

  // Alert user that countdown has finished
  showAlertDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () { Navigator.of(context).pop();},
    );
    AlertDialog alert = AlertDialog(
      title: Text("Demo finished"),
      content: Text("Please get the next team ready for demoing!"),
      actions: [
        okButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Countdown Controls"),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder(
              stream: database.document('1').snapshots(),
              builder: (context,snapshot) {
                if (snapshot.hasData && !snapshot.hasError && snapshot.data.data.values != null) {
                
                  if (_state == false) {
                    Map data = snapshot.data.data;
                    _countdownTime = data['time'];
                    _countdownText = "$_countdownTime:00";
                  } 
                  return Column (
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("$_countdownText",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 100),
                      ),
                    ]
                  );
                }
                else
                  return Text("Error: No Time");
              },
            ),
            SizedBox(height: 80),
            new Text(
                "Set Minutes:",
                style: TextStyle(fontSize: 15),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
              child:
                TextField(
                  onSubmitted: (value) {_changeCountdown(int.parse(value));},
                  textInputAction: TextInputAction.done,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center
                )
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new RaisedButton.icon(
                  textColor: Colors.white,
                  color: Colors.green,
                  onPressed: _startCountdown,
                  label: Text("Start"),
                  icon: Icon(Icons.play_arrow),
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                ),
                new RaisedButton.icon(
                  textColor: Colors.white,
                  color: Colors.red,
                  onPressed: _stopCountdown,
                  label: Text("Stop"),
                  icon: Icon(Icons.stop),
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
                ),
              ]),
            StreamBuilder(
              stream: database.document('1').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && !snapshot.hasError && snapshot.data.data.values != null) {
                  
                  Map data = snapshot.data.data;
                  _state = data['start'];
                  _countdownTime = data['time'];
                  _secondsSinceEpoch = data['epoch'];

                  // Check if another device has triggered the countdown
                  if (_state == true && countdownTimer != null && countdownTimer.isRunning) {
                    var now = DateTime.now().toUtc().millisecondsSinceEpoch;
                    var diff = _secondsSinceEpoch - now;
                    _doCountdown(diff);
                  }
                  String endTime = DateTime.fromMillisecondsSinceEpoch(_secondsSinceEpoch).toString();
                  return Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Column (
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        RaisedButton.icon(
                          textColor: Colors.white,
                          color: Colors.orange,
                          onPressed: _overrideCountdown,
                          label: Text("Remote Override"),
                          icon: Icon(Icons.publish),
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),),
                        Text("Firestore", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                        Text("start: $_state", style: TextStyle(fontSize: 16)),
                        Text("time: $_countdownTime", style: TextStyle(fontSize: 16)),
                        Text("epoch: $_secondsSinceEpoch", style: TextStyle(fontSize: 16)),
                        Text("time stamp: $endTime", style: TextStyle(fontSize: 16))
                    ])
                  );
                }
                else
                  return Text("No data from Firestore");
                },
            ),
          ],
        ),
      ),
    );
  }
}

