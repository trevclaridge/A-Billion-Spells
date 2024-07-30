import "dart:math";
import "bin/domains.dart";
import "bin/subjects.dart";
import "bin/techniques.dart";
import "bin/qualities.dart";
import "bin/effects.dart";
import "bin/elements.dart";
import "bin/forms.dart";
import "bin/spell_formulae.dart";

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
