import 'package:cloud_firestore/cloud_firestore.dart';

class Spell {
  late String name;
  late String description;
  late Timestamp createdDate;
  late List<String> tags;

  Spell(
      {required this.name,
      required this.description,
      required this.createdDate,
      required this.tags});

  Spell.fromJson(Map<String, dynamic> json) {
    name = json["name"] as String;
    description = json["description"] as String;
    createdDate = json["createdDate"] as Timestamp;
    var incomingTags = json["tags"] as Map<String, bool>;
    for (var tag in incomingTags.keys) {
      tags.add(tag);
    }
  }
}
