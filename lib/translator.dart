import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:text_translator/utils/utils.dart';

import 'constants/globals.dart';

class Translator extends ChangeNotifier {
  String? translated_text = null;
  String? base_text = null;
  File? image = null;
  String selected_language = "english";
  List? all_languages = null;
  bool isLoading = false;

  Future<dynamic> translate_with_image() async {
    List<int> imageBytes = image!.readAsBytesSync();

    String base64Image = base64Encode(imageBytes);

    try {
      isLoading = true;
      notifyListeners();
      http.Response response = await http.post(
        Uri.parse(
          'http://192.168.1.104:5000/image',
        ),
        body: <String, String>{
          'file': base64Image,
          "target_lan": selected_language,
        },
      );
      if (response.statusCode == 200) {
        print(response.body);
      } else {
        print('A network error occurred');
      }

      isLoading = false;

      translated_text = jsonDecode(response.body);

      translated_text == null ? showSnackbar("Any text couldn't find") : null;
      notifyListeners();
    } catch (e) {
      showSnackbar("Connection error: " + e.toString());
      return ["Connection error: " + e.toString(), 0];
    }
  }

  Future<dynamic> get_all_languages() async {
    try {
      http.Response response = await http.post(
        Uri.parse(
          'http://192.168.1.104:5000/all_languages',
        ),
      );
      if (response.statusCode == 200) {
        print(response.body);
      } else {
        print('A network error occurred');
      }

      all_languages = jsonDecode(response.body);
      notifyListeners();
    } catch (e) {
      return ["Connection error: " + e.toString(), 0];
    }
  }

  Future<dynamic> translate_with_text() async {
    try {
      isLoading = true;
      notifyListeners();
      http.Response response = await http.post(
        Uri.parse(
          'http://192.168.1.104:5000/text',
        ),
        body: <String, String>{
          'text': base_text!,
          "target_lan": selected_language,
        },
      );
      if (response.statusCode == 200) {
        print(response.body);
      } else {
        print('A network error occurred');
      }
      isLoading = false;
      translated_text = jsonDecode(response.body);

      notifyListeners();
    } catch (e) {
      showSnackbar("Connection error: " + e.toString());
      return ["Connection error: " + e.toString(), 0];
    }
  }
}
