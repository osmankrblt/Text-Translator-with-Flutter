import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:text_translator/widgets/appbar.dart';
import 'constants.dart';
import 'translator.dart';
import 'extensions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'utils/utils.dart';

class TranslateImagePage extends StatefulWidget {
  TranslateImagePage({super.key});

  @override
  State<TranslateImagePage> createState() => _TranslateImagePageState();
}

class _TranslateImagePageState extends State<TranslateImagePage> {
  XFile? selectedImage = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(
          15.0,
        ),
        child: Column(
          children: [
            showImage(
              context.dynamicHeight(
                0.5,
              ),
            ),
            showResult(100),
            showButtons(
              context.dynamicHeight(
                0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container showButtons(double height) {
    return Container(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            child: const Text(
              "Gallery",
            ),
            onPressed: () async {
              await pickImage(
                ImageSource.gallery,
              );
              if (selectedImage != null) {
                await translate();
              }
            },
          ),
          SizedBox(
            width: context.dynamicWidth(
              0.1,
            ),
          ),
          ElevatedButton(
            style: buttonStyle,
            child: const Text(
              "Camera",
            ),
            onPressed: () async {
              await pickImage(
                ImageSource.camera,
              );
              if (selectedImage != null) {
                await translate();
              }
            },
          ),
        ],
      ),
    );
  }

  Container showImage(double height) {
    return Container(
      height: height,
      child: selectedImage != null
          ? Container(
              margin: const EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(
                    File(
                      selectedImage!.path,
                    ),
                  ),
                ),
              ),
            )
          : Container(
              margin: const EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.black,
                ),
              ),
            ),
    );
  }

  pickImage(source) async {
    final ImagePicker picker = ImagePicker();

    selectedImage = await picker.pickImage(
      source: source,
    );

    setState(() {});
  }

  translate() async {
    final providerTranslate = Provider.of<Translator>(context, listen: false);
    providerTranslate.image = File(
      selectedImage!.path,
    );
    await providerTranslate.translate_with_image();

    setState(() {});
  }

  Widget showResult(double height) {
    final providerTranslate = Provider.of<Translator>(context, listen: true);

    return providerTranslate.isLoading
        ? const CircularProgressIndicator()
        : providerTranslate.translated_text != null
            ? Stack(
                fit: StackFit.loose,
                children: [
                  Positioned(
                    top: 0,
                    right: double.minPositive,
                    child: IconButton(
                      icon: Icon(
                        Icons.copy,
                      ),
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(
                            text: providerTranslate.translated_text,
                          ),
                        );
                        showSnackbar("Copied to your clipboard !");
                      },
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(
                      15,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                    ),
                    child: SelectableText(
                      providerTranslate.translated_text!,
                    ),
                  ),
                ],
              )
            : const Text(" ");
  }
}
