import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../translator.dart';
import '../utils/utils.dart';

getAppBar(BuildContext context, VoidCallback func) {
  List? items = Provider.of<Translator>(context, listen: true).all_languages;

  return AppBar(
    title: const Text(
      "Translator",
      style: TextStyle(
        color: Colors.black,
        fontStyle: FontStyle.italic,
      ),
    ),
    backgroundColor: Colors.white,
    actions: [
      items != null
          ? getLanguagesList(
              context,
              items,
              func,
            )
          : SizedBox(),
    ],
  );
}

Widget getLanguagesList(BuildContext context, items, VoidCallback func) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(
            10,
          )),
      padding: EdgeInsets.all(5),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton(
            alignment: Alignment.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            value: Provider.of<Translator>(context, listen: true)
                .selected_language,
            items: items
                .map<DropdownMenuItem<String>>(
                  (e) => DropdownMenuItem<String>(
                    value: e,
                    child: Text(
                      e.toUpperCase(),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              Provider.of<Translator>(context, listen: false)
                  .selected_language = value.toString();
              func();
            },
          ),
        ),
      ),
    ),
  );
}
