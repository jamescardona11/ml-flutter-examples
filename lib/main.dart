import 'package:flutter/material.dart';
import 'package:ml_flutter_examples/speechtotext/speech_to_text.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('List of apps'),
        ),
        body: _NavigatorIntern(),
      ),
    );
  }
}

class _NavigatorIntern extends StatelessWidget {
  final Map<String, Widget> screens = {
    'Speech to Text': SpeechToTextPage(),
    'Scanner Text': SpeechToTextPage(),
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

List<Widget> convertMapToList(BuildContext context, screens) {
  List<Widget> listItems = [];
  screens.forEach(
    (key, value) => listItems.add(
      Card(
        child: ListTile(
          title: Text(key, style: TextStyle()),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => value)),
        ),
      ),
    ),
  );

  return listItems;
}
