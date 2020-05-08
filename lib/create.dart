import 'package:flutter/material.dart';
import 'controls.dart';
import 'countdown.dart';

class CreatePage extends StatelessWidget {
  
  static const String route = '/create';

  String name = "";
  String secret = "";
  Color warningColour = Colors.green;
  String warningMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a Countdown'),
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
                textAlign: TextAlign.center,
                decoration: new InputDecoration(
                  hintText: 'Name'
                ),
              ),
            ),
            RaisedButton.icon(
              textColor: Colors.white,
              color: Colors.purple,
              onPressed: () {

                if (name != "") {
                  // add to firestore

                  secret = "Firebase";
                  warningMessage = "All good!";
                  warningColour = Colors.green;
                  Navigator.of(context).pushNamed(
                    ControlsPage.route,
                    arguments: CountdownControlsInfo(name, secret),
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