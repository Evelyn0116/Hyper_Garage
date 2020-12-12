import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:hyper_garage/DialogBox/errorDialog.dart';
import 'package:hyper_garage/Widgets/loadingWidget.dart';
import 'package:hyper_garage/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hyper_garage/DialogBox/loadingDialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ImD;
import 'package:hyper_garage/Widgets/customTextField.dart';

class UploadPage extends StatefulWidget{
  @override
  _UploadPageState createState() => _UploadPageState();

}

class _UploadPageState extends State<UploadPage> {
  File file ;
  TextEditingController _descriptionTextEditingController = TextEditingController();
  TextEditingController _priceTextEditingController = TextEditingController();
  TextEditingController _titleTextEditingController = TextEditingController();
  String productId = DateTime.now().microsecondsSinceEpoch.toString();
  bool uploading = false;

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
                        color: Colors.white,
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
    return
      ListView(
        children: [
          uploading ? circularProgress() : Text(""),
          Container(
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    enterItemInfo(),
                    // Padding(padding: EdgeInsets.only(top: 12.0)),

                    Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.5,
                        height: MediaQuery
                            .of(context)
                            .size
                            .width * 0.5,
                        decoration: BoxDecoration(
                            border: file == null ? Border.all(color: Colors.blue) : null,
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Material (
                            color: Colors.transparent,
                            child: InkWell(
                                onTap: () {
                                  setState(() {
                                    takeImage(context);
                                  });
                                },
                                child: file == null ? Icon(Icons.add_a_photo_rounded, size: 30, color: Colors.blue,) : new Image.file(file, fit: BoxFit.fitWidth)
                            )
                        )
                    ),

                    Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular((9.0))),
                          child: Text("Add New Items", style: TextStyle(color: Colors.white),),
                          color: Colors.blueAccent,
                          onPressed: () => uploadImageAndSaveItemInfo(),
                        )
                    ),

                  ]
              ),
            ),
          )
        ],
      );
  }

//BoxDecoration(image: DecorationImage(image: FileImage(file), fit: BoxFit.cover))
  enterItemInfo() {
    return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 12.0)),
            ListTile(
                leading: Icon(Icons.insert_emoticon, color: Colors.blue),
                title: Container(
                    width: 250.0,
                    child: TextField(
                      style: TextStyle(color: Colors.blue),
                      controller: _titleTextEditingController,
                      decoration: InputDecoration(
                        hintText: "Product Name",
                        hintStyle: TextStyle(color: Colors.blue),
                        border: InputBorder.none,
                      ),
                    )
                )
            ),
            Divider(color:Colors.blue),

            ListTile(

                leading: Icon(CupertinoIcons.money_dollar_circle, color: Colors.blue),
                title: Container(
                    width: 250.0,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Colors.blue),
                      controller: _priceTextEditingController,
                      decoration: InputDecoration(
                        hintText: "Price",
                        hintStyle: TextStyle(color: Colors.blue),
                        border: InputBorder.none,
                      ),
                    )
                )
            ),
            Divider(color:Colors.blue),

            ListTile(
                leading: Icon(Icons.info_rounded, color: Colors.blue),
                title: Container(
                    width: 250.0,
                    height: 150,
                    child: TextField(
                      style: TextStyle(color: Colors.blue),
                      controller: _descriptionTextEditingController,
                      decoration: InputDecoration(
                        hintText: "Description",
                        hintStyle: TextStyle(color: Colors.blue),
                        border: InputBorder.none,
                      ),
                    )
                )
            ),
            Divider(color:Colors.blue)
          ],
        )
    );

  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (con) {
          return SimpleDialog(
            title: Text("Item Image", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
            children: [
              SimpleDialogOption(
                child: Text("Capture with Camera", style: TextStyle(color: Colors.green)),
                onPressed: capturePhotoWithCamera,
              ),
              SimpleDialogOption(
                child: Text("Select from gallery", style: TextStyle(color: Colors.green)),
                onPressed: selectFromGallery,
              ),
              SimpleDialogOption(
                  child: Text("Cancel", style: TextStyle(color: Colors.green)),
                  onPressed: () {
                    Navigator.pop(context);
                  }
              )
            ],
          );
        }
    );
  }

  capturePhotoWithCamera() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.camera, maxHeight: 680.0, maxWidth: 970.0);

    setState(() {
      file = imageFile;
    });
  }

  selectFromGallery() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      file = imageFile;
    });
  }

  clearFormInfo() {
    setState(() {
      file = null;
      _titleTextEditingController.clear();
      _priceTextEditingController.clear();
      _descriptionTextEditingController.clear();
    });
  }

  uploadImageAndSaveItemInfo() async {

    if (file == null) {
      showDialog(
          context: context,
          builder: (c){
            return ErrorAlertDialog(message: "please select an image file", );
          }
      );
    } else {
      if( _titleTextEditingController.text.isNotEmpty &&
          _priceTextEditingController.text.isNotEmpty &&
          _descriptionTextEditingController.text.isNotEmpty ) {

        setState(() {
          uploading = true;
        });

        String imageDownloadUrl = await uploadItemImage(file);
        // showDialog(
        //     context: context,
        //     builder: (c) {
        //       return LoadingAlertDialog(message: "'Uploading, Please wait...'",);
        //     }
        // );
        saveItemInfo(imageDownloadUrl);
        displayDialog("Upload successfully");
      } else {
        displayDialog("Please fill up the form ");
      }
    }
  }

  Future<String> uploadItemImage(mFileImage) async {
    setState(() {
      uploading = false;
    });

    // showDialog(
    //     context: context,
    //     builder: (c) {
    //       return LoadingAlertDialog(message: "'Authenticating, Please wait...'",);
    //     }
    // );

    final StorageReference storageReference = FirebaseStorage.instance.ref().child("MM.YQF");

    StorageUploadTask uploadTask = storageReference.child("product $productId.jpg").putFile(mFileImage);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  saveItemInfo(String downloadUrl) {
    final itemsRef = Firestore.instance.collection("MFItems");
    itemsRef.document(productId).setData({
      "title": _titleTextEditingController.text.trim(),
      "price": _priceTextEditingController.text.trim(),
      "description": _descriptionTextEditingController.text.trim(),
      "thumbnailUrl": downloadUrl,
      "publishedDate": DateTime.now(),
    });

    setState(() {
      file = null;
      uploading = false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      _titleTextEditingController.clear();
      _priceTextEditingController.clear();
      _descriptionTextEditingController.clear();
    });
  }


  displayDialog(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(message: msg,);
        }
    );
  }
}