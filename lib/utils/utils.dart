import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constants/globals.dart';

showSnackbar(content) {
  final SnackBar snackBar = SnackBar(
    content: Text(content),
  );
  snackbarKey.currentState?.showSnackBar(snackBar);
}
