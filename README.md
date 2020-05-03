# Demo Countdown - Controls (Flutter)

Controller for the Hackathon Demo Countdown app to control the data inside of Firebase.

## Setup

This app uses a Firebase Firestore NoSQL Database

To get this to work with Firebase, you will need to setup 4 apps on Firebase:

1. iOS
2. Android
3. Web
4. macOS (use iOS instructions)

All the instructions can be found [here](https://firebase.google.com/docs/flutter/setup).

For Web, make a file inside `web` called `google-services.js` and paste the creds into it:

```javascript
var firebaseConfig = {
    apiKey: "CREDS",
    authDomain: "CREDS",
    databaseURL: "CREDS",
    projectId: "CREDS",
    storageBucket: "CREDS",
    messagingSenderId: "CREDS",
    appId: "CREDS",
    measurementId: "CREDS"
};
// Initialize Firebase
firebase.initializeApp(firebaseConfig);
```
