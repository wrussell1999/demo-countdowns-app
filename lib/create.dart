import 'package:flutter/material.dart';

import 'controls.dart';

class CreatePage extends StatelessWidget {
  
  String name = "";
  String secret = "";
  Color warningColour = Colors.green;
  String warningMessage = "";

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
            Text("Enter a name for your Countdown"),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
              child:
                TextField(
                onChanged: (value) {
                  print(value);

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
                textAlign: TextAlign.center
              ),
            ),
            RaisedButton.icon(
              textColor: Colors.white,
              color: Colors.purple,
              onPressed: () {

                if (name != "") {
                  // add to firestore
                  warningMessage = "All good!";
                  warningColour = Colors.green;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ControlsPage()),
                  );
                } else {
                  warningMessage = "Error!";
                  warningColour = Colors.red;
                }
              },
              label: Text('Create!'),
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