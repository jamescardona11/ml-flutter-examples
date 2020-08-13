import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'scanner_utils.dart';

class TextScannerPage extends StatefulWidget {
  @override
  _TextScannerPageState createState() => _TextScannerPageState();
}

class _TextScannerPageState extends State<TextScannerPage> {
  CameraLensDirection _direction = CameraLensDirection.back;
  CameraController _camera;
  String _text;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  @override
  void dispose() {
    super.dispose();
    _camera?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          _camera == null
              ? Container(
                  color: Theme.of(context).primaryColor,
                )
              : Container(
                  height: MediaQuery.of(context).size.height,
                  child: CameraPreview(_camera),
                ),
          if (_text != '')
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(100),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Found Text:', style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.w600)),
                  Text(_text, style: TextStyle(fontSize: 18, color: Colors.white))
                ],
              ),
            ),
          Positioned(
            bottom: 50,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _text == ''
                      ? GestureDetector(
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: IconButton(
                              onPressed: () => takePicture(),
                              icon: Icon(
                                Icons.camera,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : Column(
                          children: <Widget>[
                            FlatButton(
                              color: Colors.white,
                              onPressed: () => setState(() => _text = ''),
                              child: Text(
                                'Take a photo',
                                style: TextStyle(fontSize: 18, color: Colors.black),
                              ),
                            ),
                          ],
                        )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void initCamera() async {
    _text = '';
    final CameraDescription description = await ScannerUtils.getCamera(_direction);
    setState(() {
      _camera = CameraController(description, ResolutionPreset.high);
    });

    await _camera.initialize();
    debugPrint('Camera Ready');
  }

  void takePicture() {}
}
