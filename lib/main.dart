import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera_ml_vision/flutter_camera_ml_vision.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

List<CameraDescription> camera;

Future<void> main() async {
  camera = await availableCameras();
  runApp(OcrApp());
}
