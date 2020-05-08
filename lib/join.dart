import 'package:flutter/material.dart';
import 'live.dart';
import 'countdown.dart';

class JoinPage extends StatelessWidget {
  
  static const String route = '/join';

  String name = "";
  String secret = "";
  Color warningColour = Colors.green;
  String warningMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join a Countdown'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Enter the Countdown name to join"),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
              child:
                TextField(
                onChanged: (value) {
                  print("Name: $value");

                  // query database

                  if (value == "") {
                    warningMessage = "Error!";
                    warningColour = Colors.red;
                  } else {
                    name = value;
                  }

                },
                textInputAction: TextInputAction.done,
                autofocus: true,
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                decoration: new InputDecoration(
                  hintText: 'Name'
                ),
              ),
            ),
            Text("Enter the secret to gain admin controls"),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
              child:
                TextField(
                onChanged: (value) {
                  print("Secret: $value");

                  // query database

                  if (value == "") {
                    warningMessage = "Error!";
                    warningColour = Colors.red;
                  } else {
                    name = value;
                  }

                },
                textInputAction: TextInputAction.done,
                autofocus: true,
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                decoration: new InputDecoration(
                  hintText: 'Secret'
                ),
              ),
            ),
            RaisedButton.icon(
              textColor: Colors.white,
              color: Colors.purple,
              onPressed: () {

                if (name != "" && secret != "") {
                  // add to firestore
                } else if (name != "" && secret == "") { 
                  warningMessage = "All good!";
                  warningColour = Colors.green;
                  Navigator.of(context).pushNamed(
                    LivePage.route,
                    arguments: CountdownLiveInfo(name));
                } else {
                  warningMessage = "Error!";
                  warningColour = Colors.red;
                }
              },
              label: Text('Join!'),
              icon: Icon(Icons.timer),
              shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
            ),
            Text(
              "$warningMessage",
              style: TextStyle(
                color: warningColour
              ),
            ),
          ],
        ),
      )
    );
  }
}