import 'dart:convert';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:text_translator/translate_text.dart';
import 'package:text_translator/widgets/appbar.dart';

import 'constants.dart';
import 'translate_image.dart';
import 'translator.dart';
import 'extensions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  late Translator translator;
  late List items = [];
  static List<Widget> _pages = <Widget>[
    TranslateTextPage(),
    TranslateImagePage(),
  ];

  void _onItemTapped(int index) {
    Provider.of<Translator>(context, listen: false).translated_text = null;
    Provider.of<Translator>(context, listen: false).base_text = null;

    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    translator = Translator();

    Provider.of<Translator>(context, listen: false).get_all_languages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context, () {
        selectedIndex == 0
            ? Provider.of<Translator>(context, listen: false)
                .translate_with_text()
            : Provider.of<Translator>(context, listen: false)
                .translate_with_image();

        setState(() {});
      }),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped,
        currentIndex: selectedIndex,
        items: [
          BottomNavigationBarItem(
            label: "Translate with text",
            icon: Icon(
              Icons.home_filled,
              size: 27,
            ),
          ),
          BottomNavigationBarItem(
            label: "Translate with image",
            icon: Icon(
              Icons.image,
              size: 27,
            ),
          ),
        ],
      ),
      body: Center(
        child: _pages.elementAt(selectedIndex),
      ),
    );
  }
}
