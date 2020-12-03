import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hyper_garage/main.dart';

class UploadPage extends StatefulWidget{
  @override
  _UploadPageState createState() => _UploadPageState();

}

class _UploadPageState extends State<UploadPage> {
  @override
  Widget build(BuildContext context) {
    return displayNewPostScreen();
  }

  displayNewPostScreen() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.border_color, color: Colors.white),
          onPressed: () {
            // Route route = MaterialPageRoute(builder: (c) => HomePage());
            // Navigator.pushReplacement(context, route);
          }
        ),
        actions: [
          FlatButton(
            child: Text("Logout",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                )),
            onPressed: () {
              Route route = MaterialPageRoute(builder: (c) => SplashScreen());
              Navigator.pushReplacement(context, route);
            }
          )
        ]
      ),
      body: getNewPostBody()
    );
  }

  getNewPostBody() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildTextColumn("Product Name", "Please enter product name", 1),
            _buildTextColumn("Price", "Please enter a price", 1),
            _buildTextColumn("Description", "Please enter the description", 4),

            Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular((9.0))),
                  child: Text("Add New Items", style: TextStyle(color: Colors.white),),
                  color: Colors.blueAccent,
                  onPressed: () => print("click new post button"),
                )
            ),
          ]
        ),
      ),
    );
  }
}

Column _buildTextColumn(String title, String text, int maxLines) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  maxLines: maxLines,
                  decoration: InputDecoration(
                    labelText: text,
                    border: OutlineInputBorder()
                  ),
                )
              ]
          )
      ),
    ],
  );
}