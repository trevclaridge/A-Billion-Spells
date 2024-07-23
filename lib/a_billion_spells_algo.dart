import "dart:math";
import "domains.dart";
import "subjects.dart";
import "techniques.dart";
import "qualities.dart";
import "effects.dart";
import "elements.dart";
import "forms.dart";
import "spell_formulae.dart";

extension RandomListItem<T> on List<T> {
  T randomItem() {
    return this[Random().nextInt(length)];
  }
}

List<String> getBillionSpellTags() {
  List<String> result = [];
  result.add(techniques.randomItem());

  var numTags = Random().nextInt(2) + 1;
  for (int i = 0; i < numTags; i++) {
    if (Random().nextBool()) {
      result.add(domains.randomItem());
    } else {
      result.add(subjects.randomItem());
    }
  }

  return result;
}

String getKnaveSpell() {
  var result = '';

  var formula = spellformulae.randomItem();

  for (var piece in formula) {
    switch (piece) {
      case 'element':
        result += '${elements.randomItem()} ';
        break;
      case 'effect':
        result += '${effects.randomItem()} ';
        break;
      case 'quality':
        result += '${qualities.randomItem()} ';
        break;
      case 'form':
        result += '${forms.randomItem()} ';
        break;
    }
  }

  if (formula.contains('quality')) {
    result = 'The $result';
  }

  return result;
}
