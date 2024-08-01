import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'spell.dart';

class SpellPage extends StatefulWidget {
  const SpellPage({super.key, required this.spell, required this.spellId});

  final Spell spell;
  final String spellId;

  @override
  State<SpellPage> createState() => _SpellPageState();
}

class _SpellPageState extends State<SpellPage> {
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 40.0),
            SelectableText(
              widget.spell.name,
              style: TextStyle(
                  fontSize: 28.0,
                  fontFamily: GoogleFonts.eduVicWaNtBeginner().fontFamily),
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                widget.spell.tags.length,
                (int index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SelectableText(
                    widget.spell.tags[index],
                    style: TextStyle(
                      fontSize: 20.0,
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
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: SelectableText(
                widget.spell.description,
                style: const TextStyle(fontSize: 20.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
