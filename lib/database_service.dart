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

  Future<String> addSpell(Spell spell) async {
    var docRef = await _firestoreInstance
        .collection(spellsCollectionReference)
        .add(spell.toJson());
    return docRef.id;
  }

  Future<Spell?> getSpellById(String id) async {
    try {
      var spellDoc = await _firestoreInstance
          .collection(spellsCollectionReference)
          .doc(id)
          .get();
      return Spell.fromJson(spellDoc.data()!);
    } on Exception catch (e) {
      debugPrint('Failed to retrive spell with message \'$e.\'');
    }
    return null;
  }

  Future<bool> doesSpellWithNameExist(String name) async {
    bool result = false;
    await _firestoreInstance
        .collection(spellsCollectionReference)
        .where('nameInsensative', isEqualTo: name)
        .get()
        .then((value) {
      if (value.size >= 1) {
        result = true;
      }
    });
    return result;
  }
}
