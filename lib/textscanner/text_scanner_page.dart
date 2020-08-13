import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextScannerPage extends StatefulWidget {
  @override
  _TextScannerPageState createState() => _TextScannerPageState();
}

class _TextScannerPageState extends State<TextScannerPage> {
  String _text = '';
  File _selectedFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            getImageBackground(),
            SizedBox(height: 25),
            if (_text != '')
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Found Text:', style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.w600)),
                  SingleChildScrollView(
                    child: Text(_text, style: TextStyle(fontSize: 18, color: Colors.black)),
                  )
                ],
              ),
            Expanded(child: SizedBox()),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: FlatButton(
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  setState(() {
                    _selectedFile = null;
                    _text = '';
                  });
                  takePicture();
                },
                child: Text('Take a photo', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Image getImageBackground() {
    if (_selectedFile != null) {
      return Image.file(
        _selectedFile,
        width: 250,
        height: 250,
      );
    }

    return Image(
      image: AssetImage('assets/placeholder.jpg'),
      width: MediaQuery.of(context).size.width,
    );
  }

  void takePicture() async {
    final pikedFile = await ImagePicker().getImage(source: ImageSource.camera);
    if (pikedFile != null) {
      final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
      FirebaseVisionImage preProcessImage = new FirebaseVisionImage.fromFilePath(pikedFile.path);

      VisionText textRecognized = await textRecognizer.processImage(preProcessImage);
      String text = textRecognized.text;
      setState(() {
        _selectedFile = File(pikedFile.path);
        _text = text;
      });
    }
  }
}
