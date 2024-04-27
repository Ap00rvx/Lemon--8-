// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String username;
  String phonenumber;
  String uid;
  String? bio;
  String email;
  String imageurl;
  List<String> post;
  int profileviews;
  List<String> thoughts;
  List<String> friends;

  UserModel({
    required this.username,
    required this.phonenumber,
    required this.uid,
    required this.email,
    required this.imageurl,
    required this.post,
    required this.profileviews,
    required this.thoughts,
    required this.friends,
    this.bio,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    username: json["username"],
    phonenumber: json["phonenumber"],
    uid: json["uid"],
    email: json["email"],
    imageurl: json["imageurl"],
    post: List<String>.from(json["post"].map((x) => x)),
    profileviews: json["profileviews"],
    thoughts: List<String>.from(json["thoughts"].map((x) => x)),
    friends: List<String>.from(json["friends"].map((x) => x)),
    bio:  json['bio'] ?? ''
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "phonenumber": phonenumber,
    "uid": uid,
    "email": email,
    "imageurl": imageurl,
    "post": List<dynamic>.from(post.map((x) => x)),
    "profileviews": profileviews,
    "thoughts": List<dynamic>.from(thoughts.map((x) => x)),
    "friends": List<dynamic>.from(friends.map((x) => x)),
    "bio":bio ?? ''
  };
}
