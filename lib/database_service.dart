import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

const String spellsCollectionReference = "spells";

class DatabaseService {
  final _firestoreInstance = FirebaseFirestore.instance;

  void addSpell(Map<String, dynamic> spell) {
    _firestoreInstance.collection(spellsCollectionReference).add(spell);
  }

  void searchSpellsByTag(tags) {
    Query<Map<String, dynamic>> query =
        _firestoreInstance.collection(spellsCollectionReference);
    for (var tag in tags) {
      var tagString = "tags.$tag";
      query = query.where(tagString, isEqualTo: true);
    }
    // .where("tags", arrayContains: tags)
    query.get().then(
      (querySnapshot) {
        if (kDebugMode) {
          print("Successfully completed");
        }
        for (var docSnapshot in querySnapshot.docs) {
          if (kDebugMode) {
            print('${docSnapshot.id} => ${docSnapshot.data()}');
          }
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }
}
