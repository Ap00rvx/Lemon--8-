// To parse this JSON data, do
//
//     final postModel = postModelFromJson(jsonString);

import 'dart:convert';

PostModel postModelFromJson(String str) => PostModel.fromJson(json.decode(str));

String postModelToJson(PostModel data) => json.encode(data.toJson());

class PostModel {
  String title;
  String imageUrl;
  String username;
  String userImageUrl;
  String uid;
  String postId;
  String caption;

  List<String> likes;
  List<String> comments;
  DateTime date;
  String media ;

  PostModel({
    required this.title,
    required this.media,
    required this.imageUrl,
    required this.username,
    required this.userImageUrl,
    required this.uid,
    required this.postId,
    required this.caption,
    required this.likes,
    required this.comments,
    required this.date,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    title: json["title"],
    imageUrl: json["imageUrl"],
    username: json["username"],
    media: json['media'],
    userImageUrl: json["userImageUrl"],
    uid: json["uid"],
    postId: json["postID"],
    caption: json["caption"],
    likes: List<String>.from(json["likes"].map((x) => x)),
    comments: List<String>.from(json["comments"].map((x) => x)),
    date: DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "imageUrl": imageUrl,
    "username": username,
    "userImageUrl": userImageUrl,
    "uid": uid,
    "media":media,
    "postID": postId,
    "caption": caption,
    "likes": List<dynamic>.from(likes.map((x) => x)),
    "comments": List<dynamic>.from(comments.map((x) => x)),
    "date": date.toIso8601String(),
  };
}
