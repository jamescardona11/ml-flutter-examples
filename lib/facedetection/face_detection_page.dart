import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FaceDetectionPage extends StatefulWidget {
  @override
  _FaceDetectionPageState createState() => _FaceDetectionPageState();
}

class _FaceDetectionPageState extends State<FaceDetectionPage> {
  var _imageFile;
  List<Rect> rect = new List<Rect>();
  bool isFaceDetected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(height: 50.0),
          isFaceDetected
              ? Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(blurRadius: 20),
                      ],
                    ),
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: FittedBox(
                      child: SizedBox(
                        width: _imageFile.width.toDouble(),
                        height: _imageFile.height.toDouble(),
                        child: CustomPaint(
                          painter: FacePainter(rect: rect, imageFile: _imageFile),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
          Center(
            child: FlatButton.icon(
              icon: Icon(
                Icons.photo_camera,
                size: 100,
              ),
              label: Text(''),
              textColor: Theme.of(context).primaryColor,
              onPressed: () => pickImage(),
            ),
          ),
        ],
      ),
    );
  }

  void pickImage() async {
    final pikedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pikedFile != null) {
      final bytesImage = await pikedFile.readAsBytes();
      final imageFile = await decodeImageFromList(bytesImage);

      setState(() {
        _imageFile = imageFile;
      });

      FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(File(pikedFile.path));
      final FaceDetector faceDetector = FirebaseVision.instance.faceDetector();
      final List<Face> faces = await faceDetector.processImage(visionImage);
      if (rect.length > 0) {
        rect = List<Rect>();
      }

      for (Face face in faces) {
        rect.add(face.boundingBox);
      }

      setState(() {
        isFaceDetected = true;
      });
    }
  }
}

class FacePainter extends CustomPainter {
  List<Rect> rect;
  var imageFile;

  FacePainter({@required this.rect, @required this.imageFile});

  @override
  void paint(Canvas canvas, Size size) {
    if (imageFile != null) {
      canvas.drawImage(imageFile, Offset.zero, Paint());
    }

    for (Rect rectangle in rect) {
      canvas.drawRect(
        rectangle,
        Paint()
          ..color = Colors.teal
          ..strokeWidth = 6.0
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
