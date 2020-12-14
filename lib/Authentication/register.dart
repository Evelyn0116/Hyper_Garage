
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hyper_garage/Config/config.dart';
import 'package:hyper_garage/DialogBox/errorDialog.dart';
import 'package:hyper_garage/DialogBox/loadingDialog.dart';
import 'package:hyper_garage/Store/storehome.dart';
import 'package:hyper_garage/Widgets/customTextField.dart';
import 'package:image_picker/image_picker.dart';


class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}



class _RegisterState extends State<Register>
{
  final TextEditingController _nameTextEditingController = TextEditingController();
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final TextEditingController _cPasswordTextEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userImageUrl = "";
 // File _imageFile;

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery
        .of(context)
        .size
        .width,
        _screenHeight = MediaQuery
            .of(context)
            .size
            .height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 40.0,),
            // InkWell(
            //   onTap: _selectAndPickImage,
            //   child: CircleAvatar(
            //     radius: _screenWidth * 0.15,
            //     backgroundColor: Colors.white,
            //     backgroundImage: _imageFile == null ? null : FileImage(
            //         _imageFile),
            //     child: _imageFile == null
            //         ? Icon(Icons.add_photo_alternate, size: _screenWidth * 0.15,
            //       color: Colors.grey,)
            //         : null,
            //   ),
            // ),
            // SizedBox(height: 8.0,),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: _nameTextEditingController,
                    data: Icons.person,
                    hintText: "Name",
                    isObsecure: false,
                  ),
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
                  CustomTextField(
                    controller: _cPasswordTextEditingController,
                    data: Icons.person,
                    hintText: "Confirm Password",
                    isObsecure: true,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            RaisedButton(
              onPressed:(){uploadAndSaveImage();},
              color: Colors.cyanAccent[700],
              child: Text("Sign up", style: TextStyle(color: Colors.white, fontFamily:"IndieFlower", fontSize: 25),),
            ),
            SizedBox(
              height: 20.0,
            ),
            // Container(
            //   height: 4.0,
            //   width: _screenWidth * 8.0,
            //   color: Colors.orange,
            // ),
            SizedBox(
              height: 15.0,
            ),
            Text(
              "💙 Welcome to cat world 💙"
            )
          ],
        ),
      ),
    );
  }


  // Future<void> _selectAndPickImage() async{
  //   _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  // }

  Future<void> uploadAndSaveImage() async{
    // if (_imageFile == null) {
    //   showDialog(
    //       context: context,
    //       builder: (c){
    //         return ErrorAlertDialog(message: "please select an image file", );
    //       }
    //   );
    // } else {
      _passwordTextEditingController.text == _cPasswordTextEditingController.text

          ? _emailTextEditingController.text.isNotEmpty &&
          _passwordTextEditingController.text.isNotEmpty &&
          _cPasswordTextEditingController.text.isNotEmpty &&
          _nameTextEditingController.text.isNotEmpty

          ? uploadToStorage()

          : displayDialog("Please fill up the registration form ")

          : displayDialog("Password do not match");
  // }
  }

  displayDialog(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(message: msg,);
        }
    );
  }

  uploadToStorage() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(message: "'Authenticating, Please wait...'",);
        }
    );

   // String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();

   //  StorageReference storageReference = FirebaseStorage.instance.ref().child(imageFileName);
   //
   // StorageUploadTask storageUploadTask = storageReference.putFile(_imageFile);
   //
   // StorageTaskSnapshot taskSnapshot = await storageUploadTask.onComplete;
   //
   //  await taskSnapshot.ref.getDownloadURL().then((urlImage){
   //   userImageUrl = urlImage;
       _registerUser();
   // });
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  void _registerUser() async {
    FirebaseUser firebaseUser;

    await _auth.createUserWithEmailAndPassword(
      email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),
    ).then((auth){
      firebaseUser = auth.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(message: error.message.toString(),);

          }
      );
    });

    if (firebaseUser != null) {
      saveUserInfoToFireStore(firebaseUser).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future saveUserInfoToFireStore(FirebaseUser fUser) async {
    Firestore.instance.collection("MFUsers").document(fUser.uid).setData({
      "uid":fUser.uid,
      "email": fUser.email,
      "name": _nameTextEditingController.text.trim(),
      "url":userImageUrl,
      HyperGarageApp.userCartList:["garbageValue"],
    });

    await HyperGarageApp.sharedPreferences.setString("uid", fUser.uid);
    await HyperGarageApp.sharedPreferences.setString(HyperGarageApp.userEmail, fUser.email);
    await HyperGarageApp.sharedPreferences.setString(HyperGarageApp.userName, _nameTextEditingController.text);
    await HyperGarageApp.sharedPreferences.setString(HyperGarageApp.userAvatarUrl, userImageUrl);
    await HyperGarageApp.sharedPreferences.setStringList(HyperGarageApp.userCartList, ["garbageValue"]);

  }
}