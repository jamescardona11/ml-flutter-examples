import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechToTextPage extends StatefulWidget {
  @override
  _SpeechToTextPageState createState() => _SpeechToTextPageState();
}

class _SpeechToTextPageState extends State<SpeechToTextPage> {
  stt.SpeechToText speech;
  bool isListening = false;
  String text = 'Press the button and start speaking';
  double confidence = 1.0;

  final Map<String, HighlightedWord> highLights = {
    'flutter': HighlightedWord(
      onTap: () => debugPrint('Flutter'),
      textStyle: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
    ),
    'James': HighlightedWord(
      onTap: () => debugPrint('James'),
      textStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
    ),
  };

  @override
  void initState() {
    super.initState();
    speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confidence ${(confidence * 100).toStringAsFixed(1)}%'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75,
        duration: Duration(milliseconds: 2000),
        repeatPauseDuration: Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: listen,
          child: Icon(isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: EdgeInsets.fromLTRB(30, 30, 30, 150),
          child: /*Text(text)*/
              TextHighlight(
            text: text,
            words: highLights,
            textStyle: TextStyle(
              fontSize: 32,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  void listen() async {
    if (!isListening) {
      bool available = await speech.initialize(
        onStatus: (val) => debugPrint('OnStatus: $val'),
        onError: (val) => debugPrint('onError: $val'),
      );

      if (available) {
        setState(() {
          isListening = true;
        });
        speech.listen(
          onResult: (val) => setState(() {
            text = val.recognizedWords;
            debugPrint('text: $text');
            if (val.hasConfidenceRating && val.confidence > 0) {
              confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() {
        isListening = false;
      });
      speech.stop();
    }
  }
}
