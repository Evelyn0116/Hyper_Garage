import 'package:flutter/material.dart';
import '../Models/item.dart';

class ProductPage extends StatefulWidget {

  final ItemModel itemModel;
  ProductPage({this.itemModel});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  int quantityOfItems = 1;

  @override
  Widget build(BuildContext context)
  {
    Size screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              flexibleSpace: Container(
                  decoration: new BoxDecoration(
                    gradient: new LinearGradient(
                      colors: [Colors.blue, Colors.blueGrey],
                      begin: const FractionalOffset(0.0, 0.0 ),
                      end: const FractionalOffset(1.0, 0.0),
                      stops:[0.0, 1.0],
                    ),
                  ),
              ),
            centerTitle: true,
            title: Text(
              "🐱",
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
          ),
          // drawer: MyDrawer(), // 新的widget,没写
          body: ListView(
            children: [
              Container(
                  padding: EdgeInsets.all(20.0),
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Center(
                            child: SmallPicture(
                                  tag: 'thumbnailUrl', imagePath: widget.itemModel.thumbnailUrl
                                  ),
                              // width: screenSize.width * 0.85,
                              // height: 300.0,

                          ),
                          Container(
                              color: Colors.grey[300],
                              child: SizedBox(
                                height: 1.0,
                                width: double.infinity,
                              )
                          )
                        ],
                      ),
                      Container(
                          padding: EdgeInsets.all(20.0),
                          child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.itemModel.title.toUpperCase(),
                                    style: boldTextStyle,
                                  ),
                                  SizedBox(
                                      height: 10.0
                                  ),

                                  Text(
                                    "💰" + widget.itemModel.price.toString(),
                                    style: boldTextStyle,
                                  ),
                                  SizedBox(
                                      height: 10.0
                                  ),

                                  Text(
                                    widget.itemModel.description,
                                  ),
                                  SizedBox(
                                      height: 10.0
                                  ),
                                ],
                              )
                          )
                      ),
                      widget.itemModel.image1 == null ?
                      Text("") :
                      SmallPicture(
                          tag: 'picture1', imagePath: widget.itemModel.image1),
                      SizedBox(
                          height: 8.0
                      ),

                      widget.itemModel.image2 == null ?
                      Text("") :
                      SmallPicture(
                          tag: 'picture2', imagePath: widget.itemModel.image2),
                      SizedBox(
                          height: 8.0
                      ),

                      SizedBox(
                          height: 8.0
                      ),

                       widget.itemModel.image3 == null ?
                       Text("") :
                       SmallPicture(
                           tag: 'picture3', imagePath: widget.itemModel.image3),
                       SizedBox(
                          height: 8.0
                       ),
                    ],
                  )
              )
            ],
          )
        ),
      );
  }
}

class SmallPicture extends StatelessWidget {
  final String tag;
  final String imagePath;

  SmallPicture({@required this.tag, @required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullPicture(tag: tag, imagePath: imagePath),
          ),
        );
      },
      child: Hero(
        tag: tag,
        child: Container(
            width: MediaQuery.of(context).size.width *0.8,
            child: Image.network(imagePath)),
      ),
    );
  }
}

class FullPicture extends StatelessWidget {
  final String tag;
  final String imagePath;

  FullPicture({@required this.tag, @required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        body: Center(
          child: Hero(
            tag: 'picture0',
            child: Image.network(imagePath),
          ),
        ),
      ),
    );
  }
}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);