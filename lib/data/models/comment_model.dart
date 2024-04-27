// To parse this JSON data, do
//
//     final commentModel = commentModelFromJson(jsonString);

import 'dart:convert';

CommentModel commentModelFromJson(String str) => CommentModel.fromJson(json.decode(str));

String commentModelToJson(CommentModel data) => json.encode(data.toJson());

class CommentModel {
  DateTime date;
  String userImageurl;
  String comment;
  String id;
  String userId;
  String username;

  CommentModel({
    required this.date,
    required this.userImageurl,
    required this.comment,
    required this.id,
    required this.userId,
    required this.username,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
    date: DateTime.parse(json["date"]),
    userImageurl: json["userImageurl"],
    comment: json["comment"],
    id: json["id"],
    userId: json["userID"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "date": date.toIso8601String(),
    "userImageurl": userImageurl,
    "comment": comment,
    "id": id,
    "userID": userId,
    "username": username,
  };
}
