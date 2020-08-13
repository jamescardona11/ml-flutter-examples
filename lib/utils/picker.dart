import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickerExample extends StatefulWidget {
  final bool cameraAvailable;
  final bool galleyAvailable;
  final bool showResult;

  const PickerExample({
    this.cameraAvailable = true,
    this.galleyAvailable = true,
    this.showResult = true,
  });

  @override
  _PickerExampleState createState() => _PickerExampleState();
}

class _PickerExampleState extends State<PickerExample> {
  File _selectedFile;
  bool _inProcess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getImageBackground(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (widget.cameraAvailable)
                    MaterialButton(
                      onPressed: () {
                        getImage(ImageSource.camera);
                      },
                      color: Colors.blue,
                      child: Text('Camera', style: TextStyle(color: Colors.white)),
                    ),
                  if (widget.galleyAvailable)
                    MaterialButton(
                      onPressed: () {
                        getImage(ImageSource.gallery);
                      },
                      color: Colors.amber,
                      child: Text('Gallery', style: TextStyle(color: Colors.white)),
                    ),
                ],
              )
            ],
          ),
          (_inProcess)
              ? Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height * 0.95,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Center()
        ],
      ),
    );
  }

  Image getImageBackground() {
    if (_selectedFile == null) {
      return Image(
        image: AssetImage('assets/placeholder.jpg'),
        width: 300,
      );
    } else {
      return Image.file(
        _selectedFile,
        width: 300,
      );
    }
  }

  void getImage(ImageSource source) async {
    setState(() {
      _inProcess = true;
    });

    final pikedFile = await ImagePicker().getImage(source: source);
    if (pikedFile != null) {
      this.setState(() {
        //_selectedFile = cropped;
        _inProcess = false;
      });
    }
  }
}
