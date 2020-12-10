
import 'package:flutter/material.dart';
import '../Models/item.dart';

double width;

class StoreHome extends StatefulWidget {
  @override
  _StoreHomeState createState() => _StoreHomeState();
}

class _StoreHomeState extends State<StoreHome> {
  // Widget build(BuildContext context) {
  //   width = MediaQuery.of(context).size.width;
  //   return SafeArea(
  //     child: Scaffold(
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      "MM YQF Hyper Garage",
                      style: TextStyle(color: Colors.deepPurple, fontSize: 30)

                  ),
                  Image.asset("images/welcome2.jpg"),
                  SizedBox(height: 30.0,),
                  FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/newpost');
                      },
                      child: Text(
                          "New Post"
                      )
                  )
                ]
            )
        )
    );
  }
}


Widget sourceInfo(ItemModel model, BuildContext context,
    {Color background, removeCartFunction}) {
  return InkWell();
}



Widget card({Color primaryColor = Colors.redAccent, String imgPath}) {
  return Container();
}



void checkItemInCart(String productID, BuildContext context)
{
}