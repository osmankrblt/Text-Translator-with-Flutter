import 'package:provider/provider.dart';
import 'package:text_translator/constants.dart';
import 'package:flutter/material.dart';
import 'package:text_translator/translator.dart';
import 'constants/globals.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Translator(),
      child: MaterialApp(
        scaffoldMessengerKey: snackbarKey,
        title: 'Translator',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: appColor,
        ),
        home: HomePage(),
      ),
    );
  }
}
