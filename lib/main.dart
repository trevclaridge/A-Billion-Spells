import 'package:a_billion_spells/database_service.dart';
import 'package:a_billion_spells/spell.dart';
import 'package:a_billion_spells/spell_page.dart';
import 'package:a_billion_spells/spell_search_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'a_billion_spells_algo.dart' as algo;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'A Billion Spells!',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: false,
      ),
      home: const MyHomePage(title: 'A Billion Spells!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> tags = algo.getBillionSpellTags();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          Row(
            children: [
              Text(
                'Peruse the Spell Vault!   ===> ',
                style: TextStyle(
                  fontFamily: GoogleFonts.abel().fontFamily,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SpellSearchPage(),
                    ),
                  );
                },
                child: const FaIcon(FontAwesomeIcons.book),
              ),
              const SizedBox(
                width: 20.0,
              ),
            ],
          )
        ],
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 30.0,
            fontFamily: GoogleFonts.eduVicWaNtBeginner().fontFamily,
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: Center(
          child: SizedBox(
            width: 700.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Write a spell inspired by the following tags:',
                  style: TextStyle(
                      fontSize: 20.0,
                      fontFamily: GoogleFonts.eduVicWaNtBeginner().fontFamily),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(
                    tags.length,
                    (int index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        tags[index],
                        style: TextStyle(
                          fontSize: 28.0,
                          fontFamily: GoogleFonts.abel().fontFamily,
                          shadows: <Shadow>[
                            Shadow(
                              blurRadius: 6,
                              color: Color(
                                (math.Random().nextDouble() * 0xFFFFFF).toInt(),
                              ).withOpacity(1.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Tooltip(
                  message: 'Reroll tags',
                  child: TextButton(
                    onPressed: () => setState(() {
                      tags = algo.getBillionSpellTags();
                    }),
                    child: const FaIcon(FontAwesomeIcons.dice),
                  ),
                ),
                const SizedBox(height: 50.0),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: const OutlineInputBorder(),
                      labelText: 'Spell name',
                      labelStyle: TextStyle(
                        fontFamily: GoogleFonts.abel().fontFamily,
                        fontSize: 20.0,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name for the spell!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30.0),
                TextFormField(
                  minLines: 8,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  controller: descriptionController,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: const OutlineInputBorder(),
                    labelText: 'Spell description',
                    labelStyle: TextStyle(
                      fontFamily: GoogleFonts.abel().fontFamily,
                      fontSize: 20.0,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text for the spell description!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30.0),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      var spellId =
                          await DatabaseService().addSpell(generateSpell());
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SpellPage(
                            spellId: spellId,
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('Submit'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Spell generateSpell() {
    Map<String, bool> tagMap = {};
    for (var tag in tags) {
      tagMap[tag] = true;
    }
    var jsonMap = {
      'name': nameController.text.trim(),
      'description': descriptionController.text.trim(),
      'createdDate': Timestamp.now(),
      'tags': tagMap
    };
    return Spell.fromJson(jsonMap);
  }
}
