import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hyper_garage/NewPost/UploadItems.dart';
import 'package:hyper_garage/Store/product_page.dart';
import 'package:hyper_garage/Widgets/loadingWidget.dart';
import '../Models/item.dart';
import '../NewPost/UploadItems.dart';

double width;
final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  final _auth = FirebaseAuth.instance;
  String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              "🐱find your lovely cat🐱",
            ),
            centerTitle: true,
          ),
          body:  ShowPosts(),
          floatingActionButton: FloatingActionButton(
            //  icon: Icon(Icons.add, color: Colors.blue,),
            onPressed: () {
              Route route = MaterialPageRoute(builder: (_) => UploadPage());
              Navigator.pushReplacement(context, route);
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.orange,
          )),
    );
  }
}

class ShowPosts extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _ShowPostsState();
  }
}

class _ShowPostsState extends State<ShowPosts> {
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection("MFItems").snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        }
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return new ListView(
      padding: const EdgeInsets.all(16.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot dataSnapshot) {
    final model = ItemModel.fromJson(dataSnapshot.data);
    // PostDetail postItem = new PostDetail(
    //     record.title, record.price, record.description, record.photos);
  //  MyTextStyle textStyle = new MyTextStyle();

    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            GestureDetector(
              child: ListTile(
                leading:
                Image.network(model.thumbnailUrl),
                /*Text(
                  '\$${record.price}',
                  style: textStyle.get('price'),
                ),*/

                title: Row(
                  children: <Widget>[
                    Text(
                      '${model.title}',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    Text(
                      '💰\$${model.price}',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500
                      ),
                    )
                  ],
                ),
                subtitle: Text(
                  '${model.description}',
                  maxLines: 3,
                //  style: textStyle.get('description'),
                ),
              ),
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (BuildContext context) {
                      return ProductPage(itemModel: model,);
                    }));
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container();
}
