import 'package:a_billion_spells/database_service.dart';
import 'package:a_billion_spells/spell.dart';
import 'package:a_billion_spells/spell_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'a_billion_spells_algo.dart' as algo;

class SpellSearchPage extends StatefulWidget {
  const SpellSearchPage({super.key});

  @override
  State<SpellSearchPage> createState() => _SpellSearchPageState();
}

class _SpellSearchPageState extends State<SpellSearchPage> {
  List<String> tagFilter = [];
  List<String> tagSearchSuggestions = [];
  TextEditingController tagsController = TextEditingController();

  @override
  void initState() {
    super.initState();

    tagSearchSuggestions = algo.fullTagList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          "A Billion Spells: The Vault",
          style: TextStyle(
            fontSize: 30.0,
            fontFamily: GoogleFonts.eduVicWaNtBeginner().fontFamily,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20.0),
                SearchAnchor(
                  builder: (BuildContext context, SearchController controller) {
                    return SearchBar(
                      controller: controller,
                      padding: const MaterialStatePropertyAll<EdgeInsets>(
                        EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      onTap: () {
                        controller.openView();
                      },
                      leading: const Icon(Icons.search),
                    );
                  },
                  suggestionsBuilder:
                      (BuildContext context, SearchController controller) {
                    return List<ListTile>.generate(
                      tagSearchSuggestions.length,
                      (int index) {
                        return ListTile(
                          title: Text(tagSearchSuggestions[index]),
                          onTap: () {
                            setState(
                              () {
                                if (!tagFilter
                                    .contains(tagSearchSuggestions[index])) {
                                  tagFilter.add(tagSearchSuggestions[index]);
                                }
                                controller
                                    .closeView(tagSearchSuggestions[index]);
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                  viewOnChanged: (query) {
                    tagSearchOnChange(query);
                  },
                  viewOnSubmitted: (tag) {
                    if (tag != '' && !tagFilter.contains(tag)) {
                      setState(() {
                        tagFilter.add(tag);
                      });
                    }
                  },
                  viewTrailing: const [],
                ),
                const SizedBox(height: 20.0),
                Wrap(spacing: 10.0, children: _getTagChips()),
                const SizedBox(
                  height: 30.0,
                ),
                _spellListView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void tagSearchOnChange(String query) {
    var suggestions = algo.fullTagList().where((tag) {
      query.toLowerCase();
      return tag.contains(query);
    }).toList();
    setState(() {
      query.isEmpty
          ? tagSearchSuggestions = algo.fullTagList()
          : tagSearchSuggestions = suggestions;
    });
  }

  List<Chip> _getTagChips() {
    List<Chip> tagChips = [];
    for (var tag in tagFilter) {
      Chip chip = Chip(
        padding: EdgeInsets.zero,
        label: Text(tag, style: const TextStyle(fontSize: 20.0)),
        deleteIcon: const Icon(Icons.close),
        deleteButtonTooltipMessage: 'Remove',
        onDeleted: () {
          setState(() {
            tagFilter.removeWhere((element) => element == tag);
          });
        },
      );
      tagChips.add(chip);
    }
    return tagChips;
  }

  Widget _spellListView() {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.8,
      width: MediaQuery.sizeOf(context).width,
      child: StreamBuilder(
        stream: DatabaseService().getSpells(tagFilter),
        builder: (context, snapshot) {
          List spells = snapshot.data?.docs ?? [];
          if (spells.isEmpty) {
            return const Center(
              child: Text(
                  'No spells with this tag combination have been submitted yet!'),
            );
          }
          return ListView.builder(
            itemCount: spells.length,
            itemBuilder: (context, index) {
              Spell spell = Spell.fromJson(spells[index].data());
              String spellId = spells[index].id;

              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListTile(
                  title: Text(spell.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        spell.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text("Tags: ${spell.tags}"),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SpellPage(
                          spell: spell,
                          spellId: spellId,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
