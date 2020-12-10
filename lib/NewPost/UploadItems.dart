
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hyper_garage/Widgets/loadingWidget.dart';
import 'package:hyper_garage/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadPage extends StatefulWidget{
  @override
  _UploadPageState createState() => _UploadPageState();

}

class _UploadPageState extends State<UploadPage> {
  File file;
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
    return ListView(
      children: [
        uploading ? circularProgress() : Text(""),
        Container(
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // _buildTextColumn("Product Name", "Please enter product name", 1),
                  // _buildTextColumn("Price", "Please enter a price", 1),
                  // _buildTextColumn("Description", "Please enter the description", 4),

                  Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular((9.0))),
                        child: Text("Add New Items", style: TextStyle(color: Colors.white),),
                        color: Colors.blueAccent,
                        onPressed: () => uploadImageAndSaveItemInfo(),
                      )
                  ),
                  IconButton(
                    icon: Icon(Icons.add_a_photo_outlined),
                    onPressed: () => takeImage(context),
                  ),
                  chooseImage()
                ]
            ),
          ),
        )
      ],
    );
  }

  testFun() {
    setState(() {
      uploading = true;
    });

    testFunTwo();
  }

  testFunTwo() {
    print("add clicked");
    uploading = false;
    Route route = MaterialPageRoute(builder: (_) => SplashScreen());
    Navigator.pushReplacement(context, route);
  }

//BoxDecoration(image: DecorationImage(image: FileImage(file), fit: BoxFit.cover))
  chooseImage() {
    return Column(
      children: <Widget>[
        Container(
            height: 50.0,
            width: MediaQuery.of(context).size.width * 0.5,
            child: Center(
                child: AspectRatio(
                  aspectRatio: 16/9,
                  child: Container(
                      decoration:
                      BoxDecoration(
                          border: Border.all(
                              color: Colors.black,
                              width: 1
                          )
                      )
                  ),
                )
            )
        ) ,
        Padding(padding: EdgeInsets.only(top: 12.0)),

        ListTile(
            leading: Icon(Icons.insert_emoticon, color: Colors.blue),
            title: Container(
                width: 250.0,
                child: TextField(
                  keyboardType: TextInputType.number,
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
    setState(() {
      uploading = true;
    });

    print("func1");
    String imageDownloadUrl = await uploadItemImage(file);
    print(imageDownloadUrl);
    saveItemInfo(imageDownloadUrl);
  }

  Future<String> uploadItemImage(mFileImage) async {
    setState(() {
      uploading = false;
    });
    print("func2");
    final StorageReference storageReference = FirebaseStorage.instance.ref().child("MM.YQF");
    print("func3");
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
                TextField(
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