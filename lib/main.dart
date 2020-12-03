import 'dart:async';
import 'package:flutter/material.dart';
import 'Config/config.dart';
import 'Store/storehome.dart';
import 'Authentication/authentication.dart';
import 'NewPost/UploadItems.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/' : (context) => SplashScreen(),
        '/newpost': (context) => UploadPage(),
      }
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    displaySplash();
  }

  displaySplash() {
    Timer(Duration(seconds: 5), () async {
      if(await HyperGarageApp.auth.currentUser() != null) {
        Route route = MaterialPageRoute(builder: (_) => StoreHome());
        Navigator.pushReplacement(context, route);
      } else {
        Route route = MaterialPageRoute(builder: (_) => AuthenticScreen());
        Navigator.pushReplacement(context, route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                "MM YQF Hyper Garage",
                style: TextStyle(color: Colors.deepPurple, fontSize: 30)

            ),
            Image.asset("images/welcome2.jpg"),
            SizedBox(height: 30.0,),
            FlatButton(
              onPressed: () {
                Navigator.pushNamed(context, '/newpost');
              },
              child: Text(
                "New Post"
              )
            )
          ]
        )
      )
    );
  }

}

