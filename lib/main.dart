import 'package:flutter/material.dart';
import 'package:ml_flutter_examples/speechtotext/speech_to_text.dart';
import 'package:ml_flutter_examples/utils/utils.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        body: _NavigatorIntern(),
      ),
    );
  }
}

class _NavigatorIntern extends StatelessWidget {
  final Map<String, Widget> screens = {
    'Speech to Text': SpeechToTextPage(),
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: ListView(
        children: convertMapToList(context, screens),
      ),
    );
  }
}
