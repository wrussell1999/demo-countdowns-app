import 'package:flutter/material.dart';

import 'countdown.dart';


class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create / Join Countdown'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Welcome to the Demo Countdown App!"),
            Text("Please join an existing countdown, or create a new one!"),
            RaisedButton.icon(
              textColor: Colors.white,
              color: Colors.purple,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CountdownPage()),
                );
              },
              label: Text('Create New Countdown'),
              icon: Icon(Icons.control_point),
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
            ),
            RaisedButton.icon(
              textColor: Colors.white,
              color: Colors.purple,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CountdownPage()),
                );
              },
              label: Text('Join Countdown'),
              icon: Icon(Icons.timer),
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
            ),
          ],
        ),
      )
    );
  }
}