import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'ocr_engine.dart';
// import 'utils.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(OcrApp());
}

class OcrApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Face Detect",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Face Detect"),
        ),
        body: CameraPage(),
      ),
    );
  }
}

class CameraPage extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraPage> {
  CameraController controller;
  bool _isScanBusy = false;
  Timer _timer;
  String _faceDetected = "0";
  // String _smilingDetected = "0";

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.low);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startStream() async {
    await controller.startImageStream((CameraImage availableImage) async {
      if (_isScanBusy) {
        return;
      }
      _isScanBusy = true;
      OcrManager.scanFace(availableImage).then((detectFace) {
        if (detectFace[0].smilingProbability > 0.2) {
          setState(() {
            print(detectFace[0].smilingProbability);
            _faceDetected =
                (detectFace[0].smilingProbability).toStringAsFixed(3);
          });
        }
        _isScanBusy = false;
      }).catchError((error) {
        _isScanBusy = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Column(children: [
      Expanded(child: _cameraPreviewWidget()),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        Text(
          _faceDetected,
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 34),
        )
      ]),
      Container(
        height: 100,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              MaterialButton(
                  child: Text("Start Scanning"),
                  textColor: Colors.white,
                  color: Colors.blue,
                  onPressed: () async {
                    _startStream();
                  }),
              MaterialButton(
                  child: Text("Stop Scanning"),
                  textColor: Colors.white,
                  color: Colors.red,
                  onPressed: () async {
                    _timer?.cancel();
                    await controller.stopImageStream();
                  })
            ]),
      ),
    ]);
  }

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      );
    }
  }
}
