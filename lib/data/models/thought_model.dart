// To parse this JSON data, do
//
//     final thoughtModel = thoughtModelFromJson(jsonString);

import 'dart:convert';

ThoughtModel thoughtModelFromJson(String str) => ThoughtModel.fromJson(json.decode(str));

String thoughtModelToJson(ThoughtModel data) => json.encode(data.toJson());

class ThoughtModel {
  String mood;
  String content;
  DateTime date;
  String username;
  String userimage;
  String uid;
  String thoughtId;

  ThoughtModel({
    required this.mood,
    required this.content,
    required this.date,
    required this.username,
    required this.userimage,
    required this.uid,
    required this.thoughtId,
  });

  factory ThoughtModel.fromJson(Map<String, dynamic> json) => ThoughtModel(
    mood: json["mood"],
    content: json["content"],
    date: DateTime.parse(json["date"]),
    username: json["username"],
    userimage: json["userimage"],
    uid: json["uid"],
    thoughtId: json["ThoughtID"],
  );

  Map<String, dynamic> toJson() => {
    "mood": mood,
    "content": content,
    "date": date.toIso8601String(),
    "username": username,
    "userimage": userimage,
    "uid": uid,
    "ThoughtID": thoughtId,
  };
}
