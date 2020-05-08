import 'package:flutter/material.dart';
import 'create.dart';
import 'join.dart';

class LandingPage extends StatelessWidget {

  static const String route = '/';


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
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Text("Welcome to the Demo Countdown App!")
            ),
            RaisedButton.icon(
              textColor: Colors.white,
              color: Colors.purple,
              onPressed: () {
                  Navigator.of(context).pushNamed(JoinPage.route);
              },
              label: Text('Join Countdown'),
              icon: Icon(Icons.timer),
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
            ),
            RaisedButton.icon(
              textColor: Colors.white,
              color: Colors.purple,
              onPressed: () {
                  Navigator.of(context).pushNamed(CreatePage.route);
              },
              label: Text('Create New Countdown'),
              icon: Icon(Icons.control_point),
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
            ),
          ],
        ),
      )
    );
  }
}