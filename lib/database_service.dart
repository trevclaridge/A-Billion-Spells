import 'package:a_billion_spells/spell.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

const String spellsCollectionReference = "spells";

class DatabaseService {
  final _firestoreInstance = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getSpells([tags = const []]) {
    Query<Map<String, dynamic>> query =
        _firestoreInstance.collection(spellsCollectionReference);
    for (var tag in tags) {
      var tagString = "tags.$tag";
      query = query.where(tagString, isEqualTo: true);
    }
    return query.snapshots();
  }

  void addSpell(Map<String, dynamic> spell) {
    _firestoreInstance.collection(spellsCollectionReference).add(spell);
  }

  Spell? getSpellById(String id) {
    _firestoreInstance.doc(id).get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Spell.fromJson(data);
    }, onError: (e) {
      debugPrint("Error getting document: $e");
    });
    return null;
  }
}
