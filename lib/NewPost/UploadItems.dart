import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:hyper_garage/DialogBox/errorDialog.dart';
import 'package:hyper_garage/Store/storehome.dart';
import 'package:hyper_garage/Widgets/loadingWidget.dart';
import 'package:hyper_garage/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hyper_garage/DialogBox/loadingDialog.dart';
import 'package:image/image.dart' as ImD;

class UploadPage extends StatefulWidget{
  @override
  _UploadPageState createState() => _UploadPageState();

}

class _UploadPageState extends State<UploadPage> {
  // File file ;
  TextEditingController _descriptionTextEditingController = TextEditingController();
  TextEditingController _priceTextEditingController = TextEditingController();
  TextEditingController _titleTextEditingController = TextEditingController();
  String productId = DateTime.now().microsecondsSinceEpoch.toString();
  bool uploading = false;
  List<File> files = [];
  List<String> urls = [];

  @override
  Widget build(BuildContext context) {
    return displayNewPostScreen();
  }

  displayNewPostScreen() {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  Route route = MaterialPageRoute(builder: (c) => StoreHome());
                  Navigator.pushReplacement(context, route);
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
        body: getNewPostBody(),
      floatingActionButton: FloatingActionButton(
        //  icon: Icon(Icons.add, color: Colors.blue,),
        onPressed: () {
          Route route = MaterialPageRoute(builder: (_) => StoreHome());
          Navigator.pushReplacement(context, route);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }

  getNewPostBody() {
    return
      ListView(
        padding: EdgeInsets.only(left:10.0, right: 10.0),
        children: [
          uploading ? circularProgress() : Text(""),
          Container(
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    enterItemInfo(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width * 0.25,
                            height: MediaQuery.of(context).size.width * 0.25,

                            decoration: BoxDecoration(
                                border: files.length < 1 ? Border.all(color: Colors.blue) : null,
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
                                    child: files.length < 1 ? Icon(Icons.add_a_photo_rounded, size: 30, color: Colors.blue,) :
                                    new Image.file(files[0], fit: BoxFit.fitWidth)
                                )
                            )
                        ),

                        Container(
                            width: MediaQuery.of(context).size.width * 0.25,
                            height: MediaQuery.of(context).size.width * 0.25,

                            decoration: BoxDecoration(
                                border: files.length < 2 ? Border.all(color: Colors.blue) : null,
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
                                    child: files.length < 2 ? Icon(Icons.add_a_photo_rounded, size: 30, color: Colors.blue,) :
                                    new Image.file(files[1], fit: BoxFit.fitWidth)
                                )
                            )
                        ),

                        Container(
                            width: MediaQuery.of(context).size.width * 0.25,
                            height: MediaQuery.of(context).size.width * 0.25,

                            decoration: BoxDecoration(
                                border: files.length < 3 ? Border.all(color: Colors.blue) : null,
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
                                    child: files.length < 3 ? Icon(Icons.add_a_photo_rounded, size: 30, color: Colors.blue,) :
                                    new Image.file(files[2], fit: BoxFit.fitWidth)
                                )
                            )
                        ),
                      ],
                    ),
                    SizedBox(height: 5.0),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: MediaQuery.of(context).size.width * 0.25,

                        decoration: BoxDecoration(
                            border: files.length < 4 ? Border.all(color: Colors.blue) : null,
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
                                child: files.length < 4 ? Icon(Icons.add_a_photo_rounded, size: 30, color: Colors.blue,) :
                                new Image.file(files[3], fit: BoxFit.fitWidth)
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

  enterItemInfo() {
    return Container(
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
                        hintText: "Title",
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
                      maxLines: 6,
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
            title: Text("Choose Image", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
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

    // setState(() {
    //   file = imageFile;
    // });

    setState(() {
      files.add(imageFile);
    });
  }

  selectFromGallery() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    // setState(() {
    //   file = imageFile;
    // });

    setState(() {
      files.add(imageFile);
    });
  }

  clearFormInfo() {
    setState(() {
      files.clear();
      _titleTextEditingController.clear();
      _priceTextEditingController.clear();
      _descriptionTextEditingController.clear();
    });
  }

  uploadImageAndSaveItemInfo() async {

    if (files.length < 0) {
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

        for (int i = 0; i < files.length; i++) {
          String imageDownloadUrl = await uploadItemImage(files[i], i);
          urls.add(imageDownloadUrl);
        }


        saveItemInfo(urls);
        displayDialog("Upload successfully");
        //TODO: notification
        showSnackBar(context);
      } else {
        displayDialog("Please fill up the form ");
      }
    }
  }
  
  void showSnackBar(BuildContext context){
    Scaffold.of(context).showSnackBar(SnackBar(content: Text('A new item is posted')));
  }

  Future<String> uploadItemImage(mFileImage, i) async {
    setState(() {
      uploading = false;
    });

    final StorageReference storageReference = FirebaseStorage.instance.ref().child("MM.YQF");

    StorageUploadTask uploadTask = storageReference.child("product $productId $i.jpg").putFile(mFileImage);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  saveItemInfo(List<String> urls) {
    final itemsRef = Firestore.instance.collection("MFItems");
    itemsRef.document(productId).setData({
      "title": _titleTextEditingController.text.trim(),
      "price": _priceTextEditingController.text.trim(),
      "description": _descriptionTextEditingController.text.trim(),
      "thumbnailUrl": urls[0],
      "publishedDate": DateTime.now(),
      "image1": urls.length < 2 ? '' : urls[1],
      "image2": urls.length < 3 ? '' : urls[2],
      "image3": urls.length < 4 ? '' : urls[3],
    });

    setState(() {
      // file = null;
      files.clear();
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