import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  String title;
  Timestamp publishedDate;
  String thumbnailUrl;
  String description;
  int price;
  String image1;
  String image2;

  ItemModel(
      {this.title,
        this.publishedDate,
        this.thumbnailUrl,
        this.description,
        this.price,
        this.image1,
        this.image2,
      });

  ItemModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    publishedDate = json['publishedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    description = json['description'];
    price = json['price'];
    image1 = json['images'];
    image2 = json['images'];
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
