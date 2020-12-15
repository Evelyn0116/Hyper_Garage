import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hyper_garage/Config/config.dart';
import 'package:hyper_garage/DialogBox/errorDialog.dart';
import 'package:hyper_garage/DialogBox/loadingDialog.dart';
import 'package:hyper_garage/Store/storehome.dart';
import 'package:hyper_garage/Widgets/customTextField.dart';
import '../NewPost/UploadItems.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width,
        _screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 10.0,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "images/welcome.png",
                height: 240.0,
                width: 240.0,
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _emailTextEditingController,
                    data: Icons.email,
                    hintText: "Email",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _passwordTextEditingController,
                    data: Icons.person,
                    hintText: "Password",
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            RaisedButton(
              onPressed: () {
                _emailTextEditingController.text.isNotEmpty &&
                        _passwordTextEditingController.text.isNotEmpty
                    ? loginUser()
                    : showDialog(
                        context: context,
                        builder: (c) {
                          return ErrorAlertDialog(
                            message: "please fill in the form",
                          );
                        });
              },
              color: Colors.cyanAccent[700],
              child: Text(
                "Log in",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "IndieFlower",
                    fontSize: 25),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  void loginUser() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: "Authenticating, Please wait..",
          );
        });

    FirebaseUser firebaseUser;
    await _auth
        .signInWithEmailAndPassword(
      email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),
    )
        .then((authUser) {
      firebaseUser = authUser.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });

    if (firebaseUser != null) {
      readData(firebaseUser).then((s) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future readData(FirebaseUser fUser) async {
    Firestore.instance
        .collection("MFUser")
        .document(fUser.uid)
        .get()
        .then((dataSnapshot) async {
      await HyperGarageApp.sharedPreferences
          .setString("uid", dataSnapshot.data[HyperGarageApp.userUID]);
      await HyperGarageApp.sharedPreferences.setString(HyperGarageApp.userEmail,
          dataSnapshot.data[HyperGarageApp.userEmail]);
      await HyperGarageApp.sharedPreferences.setString(
          HyperGarageApp.userName, dataSnapshot.data[HyperGarageApp.userName]);
      await HyperGarageApp.sharedPreferences.setString(
          HyperGarageApp.userAvatarUrl,
          dataSnapshot.data[HyperGarageApp.userAvatarUrl]);
      List<String> cartList =
          dataSnapshot.data[HyperGarageApp.userCartList].cast<String>();
      await HyperGarageApp.sharedPreferences
          .setStringList(HyperGarageApp.userCartList, cartList);
    });
  }
}
