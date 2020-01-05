import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

class OcrManager {
  static Future<List<Face>> scanText(CameraImage availableImage) async {
    final FirebaseVisionImageMetadata metadata = FirebaseVisionImageMetadata(
        rawFormat: availableImage.format.raw,
        size: Size(
            availableImage.width.toDouble(), availableImage.height.toDouble()),
        planeData: availableImage.planes
            .map((currentPlane) => FirebaseVisionImagePlaneMetadata(
                bytesPerRow: currentPlane.bytesPerRow,
                height: currentPlane.height,
                width: currentPlane.width))
            .toList(),
        rotation: ImageRotation.rotation90);

    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromBytes(availableImage.planes[0].bytes, metadata);

    // final TextRecognizer textRecognizer =
    //     FirebaseVision.instance.textRecognizer();
    final FaceDetector faceDetector =
        FirebaseVision.instance.faceDetector(FaceDetectorOptions(
      enableClassification: true,
      mode: FaceDetectorMode.accurate,
    ));
    // final VisionText visionText =
    //     await textRecognizer.processImage(visionImage);

    final List<Face> faces = await faceDetector.processImage(visionImage);
    print(faces);

    // for (TextBlock block in visionText.blocks) {
    //   for (TextLine line in block.lines) {
    //     for (TextElement element in line.elements) {
    //       print(element);
    //     }
    //   }
    // }
    return faces;
  }

  Uint8List concatenatePlanes(List<Plane> planes) {
    final WriteBuffer allBytes = WriteBuffer();
    planes.forEach((Plane plane) => allBytes.putUint8List(plane.bytes));
    return allBytes.done().buffer.asUint8List();
  }

  FirebaseVisionImageMetadata buildMetaData(CameraImage image) {
    return FirebaseVisionImageMetadata(
        rawFormat: image.format.raw,
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: ImageRotation.rotation90,
        planeData: image.planes.map((Plane plane) {
          return FirebaseVisionImagePlaneMetadata(
              bytesPerRow: plane.bytesPerRow,
              height: plane.height,
              width: plane.width);
        }).toList());
  }
}
