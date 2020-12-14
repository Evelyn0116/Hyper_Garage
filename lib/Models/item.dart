import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  String title;
  Timestamp publishedDate;
  String thumbnailUrl;
  String description;
  String price;
  String image1;
  String image2;
  String image3;

  ItemModel(
      {this.title,
        this.publishedDate,
        this.thumbnailUrl,
        this.description,
        this.price,
        this.image1,
        this.image2,
        this.image3,
      });

  ItemModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    publishedDate = json['publishedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    description = json['description'];
    price = json['price'];
    image1 = json['image1'];
    image2 = json['image2'];
    image3 = json['image3'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['price'] = this.price;
    if (this.publishedDate != null) {
      data['publishedDate'] = this.publishedDate;
    }
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['description'] = this.description;
    data['image1'] = this.image1;
    data['image2'] = this.image2;
    data['image3'] = this.image3;
    return data;
  }
}

class PublishedDate {
  String date;

  PublishedDate({this.date});

  PublishedDate.fromJson(Map<String, dynamic> json) {
    date = json['$date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$date'] = this.date;
    return data;
  }
}