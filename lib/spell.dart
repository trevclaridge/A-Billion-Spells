import 'package:cloud_firestore/cloud_firestore.dart';

class Spell {
  late String name;
  late String nameInsensative;
  late String description;
  late Timestamp createdDate;
  late List<String> tags;

  Spell(
      {required this.name,
      required this.nameInsensative,
      required this.description,
      required this.createdDate,
      required this.tags});

  Spell.fromJson(Map<String, dynamic> json) {
    name = json["name"] as String;
    nameInsensative = json["nameInsensative"] as String;
    description = json["description"] as String;
    createdDate = json["createdDate"] as Timestamp;
    var incomingTags = json["tags"] as Map<String, dynamic>;
    tags = [];
    for (var tag in incomingTags.keys) {
      tags.add(tag);
    }
  }

  Map<String, dynamic> toJson() {
    var tagMap = {};
    for (var tag in tags) {
      tagMap[tag] = true;
    }
    return {
      "name": name,
      "nameInsensative": nameInsensative,
      "description": description,
      "createdDate": createdDate,
      "tags": tagMap
    };
  }
}
