import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:text_translator/translator.dart';
import 'package:text_translator/utils/utils.dart';
import 'package:text_translator/widgets/appbar.dart';

class TranslateTextPage extends StatefulWidget {
  const TranslateTextPage({super.key});

  @override
  State<TranslateTextPage> createState() => _TranslateTextPageState();
}

class _TranslateTextPageState extends State<TranslateTextPage> {
  late final _key;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _key = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            inputWidget(),
            SizedBox(
              height: 10,
            ),
            showResult(100),
          ],
        ),
      ),
    );
  }

  translate(text) async {
    final providerTranslate = Provider.of<Translator>(context, listen: false);
    Provider.of<Translator>(context, listen: false).base_text = text;
    await providerTranslate.translate_with_text();

    setState(() {});
  }

  Widget showResult(double height) {
    final providerTranslate = Provider.of<Translator>(context, listen: true);

    return providerTranslate.isLoading
        ? const CircularProgressIndicator()
        : _key.text != ""
            ? Stack(
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

  TextField inputWidget() {
    return TextField(
      minLines: 1,
      maxLines: 7,
      maxLength: 1500,
      controller: _key,
      onChanged: (value) async {
        await translate(value);
        setState(() {});
      },
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        labelText: "Write your text here",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            15.0,
          ),
        ),
      ),
    );
  }
}
