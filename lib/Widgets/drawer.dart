import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hyper_garage/Config/config.dart';
import 'package:hyper_garage/NewPost/UploadItems.dart';
import 'package:hyper_garage/Store/storehome.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 25.0, bottom: 10.0),
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: [Colors.amber[300], Colors.amber[200]],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
              ),
            ),
            child: Column(
              children: [
                // Material(
                //   borderRadius: BorderRadius.all(Radius.circular(80.0)),
                //   elevation: 8.0,
                //   child: Container(
                //     height: 160.0,
                //     width: 160.0,
                //     child: CircleAvatar(
                //       backgroundImage: NetworkImage(
                //         HyperGarageApp.sharedPreferences.getString(HyperGarageApp.userAvatarUrl),
                //       ),
                //     ),
                //   ),
                // ),
                Text(
                  "Dear " + HyperGarageApp.sharedPreferences
                      .getString(HyperGarageApp.userName),
                  style: TextStyle(fontFamily: "EastSeaDokdo", fontSize: 30),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.account_circle,
                    color: Colors.blue[400],
                  ),
                  title: Text(
                    "Account",
                    style: TextStyle(),
                  ),
                  onTap: () {
                    Route route =
                    MaterialPageRoute(builder: (c) => StoreHome());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.list_alt,
                    color: Colors.blue[400],
                  ),
                  title: Text(
                    "CatHome",
                    style: TextStyle(),
                  ),
                  onTap: () {
                    Route route =
                    MaterialPageRoute(builder: (c) => StoreHome());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.add,
                    color: Colors.blue[400],
                  ),
                  title: Text(
                    "Upload",
                    style: TextStyle(),
                  ),
                  onTap: () {
                    Route route =
                    MaterialPageRoute(builder: (c) => UploadPage());
                    Navigator.pushReplacement(context, route);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
