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
          //SafeArea(
            // child:Column(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       crossAxisAlignment: CrossAxisAlignment.stretch,
            //       children: <Widget>[
            //         ItemStream(collection: "MFItems"),
         // CustomScrollView(
          //  slivers: [
            //         StreamBuilder<QuerySnapshot>(
            //           stream: Firestore.instance.collection("MFItems").orderBy("publishedDate", descending: true).snapshots(),
            //           builder: (context, dataSnapshot){
            //             return
            //               !dataSnapshot.hasData
            //                   ? SliverToBoxAdapter(child: Center(child:circularProgress(),),)
            //                   : SliverStaggeredGrid.countBuilder(
            //                   crossAxisCount: 1,
            //                   staggeredTileBuilder: (c) => StaggeredTile.fit(1),
            //                   itemBuilder: (context, index){
            //                     ItemModel model = ItemModel.fromJson(dataSnapshot.data.documents[index].data);
            //                     return sourceInfo(model, context);
            //                   },
            //                   itemCount: dataSnapshot.data.documents.length
            //               );
            //           },
            //         ),

         //   ],
         // ),
          // body: SafeArea(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     crossAxisAlignment: CrossAxisAlignment.stretch,
          //     children: <Widget>[
          //       ItemStream(collection: "MFItems"),
          //     ],
          //   ),
          // ),
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





    //     !dataSnapshot.hasData
    //         ? SliverToBoxAdapter(child: Center(child: circularProgress(),),)
    //         : SliverStaggeredGrid.countBuilder(
    //         crossAxisCount: 1,
    //         staggeredTileBuilder: (c) => StaggeredTile.fit(1),
    //         itemBuilder: (context, index) {
    //           ItemModel model = ItemModel.fromJson(
    //               dataSnapshot.data.documents[index].data);
    //           return sourceInfo(model, context);
    //         },
    //         itemCount: dataSnapshot.data.documents.length
    //     );
    // }
    // ,



    // return StreamBuilder<QuerySnapshot>(
    //     stream: _firestore.collection(collection).snapshots(),
    //     builder: (context, dataSnapshot){
    //           return
    //             !dataSnapshot.hasData
    //                 ? SliverToBoxAdapter(child: Center(child:circularProgress(),),)
    //                 : SliverStaggeredGrid.countBuilder(
    //                 crossAxisCount: 1,
    //                 staggeredTileBuilder: (c) => StaggeredTile.fit(1),
    //                 itemBuilder: (context, index){
    //                   ItemModel model = ItemModel.fromJson(dataSnapshot.data.documents[index].data);
    //                   return sourceInfo(model, context);
    //                 },
    //                 itemCount: dataSnapshot.data.documents.length
    //             );
    //         },

        //   final items = snapshot.data.documents.reversed;
        //   List<ItemBubble> ItemBubbles = [];
        //   for (var item in items) {
        //     final map = item.data;
        //     final itemBubble = ItemBubble(
        //       map: map,
        //     );
        //     ItemBubbles.add(itemBubble);
        //   }
        //   return Expanded(
        //     child: ListView(
        //       padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        //       children: ItemBubbles,
        //     ),
        //   );
        // }

//         );


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
                // subtitle: Text(
                //   '${record.description}',
                //   maxLines: 3,
                //   style: textStyle.get('description'),
                // ),
              ),
              // onTap: () {
              //   Navigator.push(context,
              //       new MaterialPageRoute(builder: (BuildContext context) {
              //         return DetailPage(
              //           postDetail: postItem,
              //         );
              //       }));
              // },
            ),

//            ButtonBarTheme(
//              data: ButtonBarThemeData(),
//              child: ButtonBar(
//                children: <Widget>[
//                  FlatButton(
//                    child: const Text('View Detial'),
//                    onPressed: (){
//                      Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
//                        return DetailPage(postDetail: postItem,);
//                      }));
//
//                    },
//                  ),
//                ],
//              ),
//            ),
          ],
        ),
      ),
    );
  }
}



// Widget sourceInfo(ItemModel model, BuildContext context,
//     {Color background, removeCartFunction}) {
//   return InkWell(
//     splashColor: Colors.blue,
//     child: Padding(
//       padding: EdgeInsets.all(6.0),
//       child: Container(
//         height: 190.0,
//         width: width,
//         child: Row(
//           children: [
//             Image.network(
//               model.thumbnailUrl,
//               width: 140.0,
//               height: 140.0,
//             ),
//             SizedBox(
//               width: 4.0,
//             ),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     height: 15.0,
//                   ),
//                   Container(
//                     child: Row(
//                       mainAxisSize: MainAxisSize.max,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             model.title,
//                             style:
//                                 TextStyle(color: Colors.black, fontSize: 14.0),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5.0,
//                   ),
//                   // Container(
//                   //   child: Row(
//                   //     mainAxisSize: MainAxisSize.max,
//                   //     children: [
//                   //       Expanded(
//                   //         child: Text(
//                   //           model.shortInfo,
//                   //           style: TextStyle(
//                   //               color: Colors.black54, fontSize: 12.0),
//                   //         ),
//                   //       ),
//                   //     ],
//                   //   ),
//                   // ),
//                   // SizedBox(height: 20.0,),
//                   // Row(
//                   //   children: [
//                   //     Container(
//                   //       decoration: BoxDecoration(
//                   //         shape: BoxShape.rectangle,
//                   //         color: Colors.orange,
//                   //       ),
//                   //       alignment: Alignment.topLeft,
//                   //       width: 40.0,
//                   //       height: 43.0,
//                   //       child: Center(
//                   //         child: Column(
//                   //           mainAxisAlignment: MainAxisAlignment.center,
//                   //           children: [
//                   //             Text(
//                   //               "50%",style:TextStyle(fontSize: 15.0,),
//                   //             ),
//                   //             Text(
//                   //               "OFF",style:TextStyle(fontSize: 15.0,),
//                   //             ),
//                   //           ],
//                   //         ),
//                   //       ),
//                   //     ),
//                   //     SizedBox(width: 10.0,),
//                   //     Column(
//                   //       crossAxisAlignment: CrossAxisAlignment.start,
//                   //       children: [
//                   //         Padding(
//                   //           padding: EdgeInsets.only(top: 0.0),
//                   //           child: Row(
//                   //             children: [
//                   //               Text(
//                   //                 "Origin"
//                   //               ),
//                   //               Text(
//                   //                 "cat"
//                   //               ),
//                   //             ],
//                   //           ),
//                   //         ),
//                   //       ],
//                   //     ),
//                   //   ],
//                   // ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }

Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container();
}
