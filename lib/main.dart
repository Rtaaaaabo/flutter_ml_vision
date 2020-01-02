// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter_camera_ml_vision/flutter_camera_ml_vision.dart';
import 'package:camera/camera.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pay Per Laugh for Japan',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ScanPage(title: 'Firebase ML KIT'),
      // home: HomePage(title: 'mkkit face recognition'),
    );
  }
}

// class HomePage extends StatefulWidget {

// }

class ScanPage extends StatefulWidget {
  final String title;
  ScanPage({Key key, this.title}) : super(key: key);
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  bool resultSent = false;
  final FaceDetector faceDetector = FirebaseVision.instance.faceDetector();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: CameraMlVision<List<Face>>(
          detector: faceDetector.processImage,
          cameraLensDirection: CameraLensDirection.front,
          onResult: (List<Face> infoFaces) {
            // print(infoFaces);
            if (!mounted ||
                resultSent ||
                infoFaces == null ||
                infoFaces.isEmpty) {
              return;
            }
            infoFaces.forEach((data) => print(data.smilingProbability));
          },
        ),
      ),
    ));
  }
}
