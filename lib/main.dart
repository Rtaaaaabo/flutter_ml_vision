// import 'dart:html';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_camera_ml_vision/flutter_camera_ml_vision.dart';

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
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> data = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RaisedButton(
            child: Text('スキャン'),
            onPressed: () async {
              final barcode = await Navigator.of(context).push<Barcode>(
                MaterialPageRoute(
                  builder: (c) {
                    return ScanPage();
                  },
                ),
              );
              if (barcode == null) {
                return;
              }
              setState(() {
                print(barcode);
                data.add(barcode.displayValue);
              });
            },
          ),
          Expanded(
            child: ListView(
              children: data.map((d) => Text(d)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class ScanPage extends StatefulWidget {
  final String title;
  ScanPage({Key key, this.title}) : super(key: key);
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  bool resultSent = false;
  BarcodeDetector barcodeDetector = FirebaseVision.instance.barcodeDetector();
  FaceDetector faceDetector = FirebaseVision.instance.faceDetector();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: CameraMlVision<List<Face>>(
          detector: faceDetector.processImage,
          onResult: (infoFaces) {
            if (!mounted ||
                resultSent ||
                infoFaces == null ||
                infoFaces.isEmpty) {
              return;
            }
          },
        ),
      ),
    ));
  }
}
