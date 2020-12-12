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
                "Hyper Garage",
                style: TextStyle(fontSize: 55.0, color: Colors.white),
              ),
              actions: [
                Stack(
                  children: [
                    IconButton(
                        icon: Icon(Icons.table_chart)
                    )
                  ],
                )
              ]
          ),
          // drawer: MyDrawer(), // 新的widget,没写
          body: ListView(
            children: [
              Container(
                  padding: EdgeInsets.all(20.0),
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Center(
                            child: Image.network(widget.itemModel.thumbnailUrl),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.itemModel.title,
                                    style: boldTextStyle,
                                  ),
                                  SizedBox(
                                      height: 10.0
                                  ),

                                  Text(
                                    "\$" + widget.itemModel.price.toString(),
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

                      //"Add to Cart"
                      // Padding(
                      //   padding: EdgeInsets.only(top: 10.0),
                      //   child: Center(
                      //     child: InkWell(
                      //       onTap: () => print("clicked"),
                      //       child: Container(
                      //         color: Colors.blue,
                      //         width: MediaQuery.of(context).size.width - 40.0,
                      //         height: 50.0,
                      //         child: Center(
                      //           child: Text("Add to Cart", style: TextStyle(color: Colors.white)),
                      //         )
                      //       )
                      //     )
                      //   )
                      // ),
                    ],
                  )
              )
            ],
          )
      ),
    );
  }

}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
