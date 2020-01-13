import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';

typedef HandleDetection = Future<List<Face>> Function(
    FirebaseVisionImage image);

Future<CameraDescription> getCamera(CameraLensDirection dir) async {
  return await availableCameras().then(
    (List<CameraDescription> cameras) => cameras.firstWhere(
      (CameraDescription camera) => camera.lensDirection == dir,
    ),
  );
}

Uint8List concatenatePlanes(List<Plane> planes) {
  final WriteBuffer allBytes = WriteBuffer();
  planes.forEach((Plane plane) => allBytes.putUint8List(plane.bytes));
  return allBytes.done().buffer.asUint8List();
}

FirebaseVisionImageMetadata buildMetaData(
  CameraImage image,
  ImageRotation rotation,
) {
  return FirebaseVisionImageMetadata(
    rawFormat: image.format.raw,
    size: Size(image.width.toDouble(), image.height.toDouble()),
    rotation: rotation,
    planeData: image.planes.map(
      (Plane plane) {
        return FirebaseVisionImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList(),
  );
}

Future<List<Face>> detect(
  CameraImage image,
  HandleDetection handleDetection,
  ImageRotation rotation,
) async {
  return handleDetection(
    FirebaseVisionImage.fromBytes(
      concatenatePlanes(image.planes),
      buildMetaData(image, rotation),
    ),
  );
}

ImageRotation rotationIntToImageRotation(int rotation) {
  switch (rotation) {
    case 0:
      return ImageRotation.rotation0;
    case 90:
      return ImageRotation.rotation90;
    case 180:
      return ImageRotation.rotation180;
    default:
      assert(rotation == 270);
      return ImageRotation.rotation270;
  }
}
// bool isDetecting = false;

// // Future<CameraDescription>
// Future<CameraDescription> getFrontCamera() async {
//   return await availableCameras().then((cameras) => cameras.firstWhere(
//       (camera) => camera.lensDirection == CameraLensDirection.front));
// }

// void cameraBytesToDetector({
//   @required CameraController camera,
//   @required FaceDetector detector,
//   @required void updateFace(Face face),
// }) {
//   camera.startImageStream((image) {
//     if (isDetecting) return;

//     isDetecting = true;

//     detector.processImage(FirebaseVisionImage.fromBytes(
//         image.planes[0].bytes,
//         FirebaseVisionImageMetadata(
//             rawFormat: image.format.raw,
//             size: camera.value.previewSize,
//             rotation: ImageRotation.rotation270,
//             planeData: image.planes
//                 .map((currentPlane) => FirebaseVisionImagePlaneMetadata(
//                     bytesPerRow: currentPlane.bytesPerRow,
//                     height: currentPlane.height,
//                     width: currentPlane.width))
//                 .toList())));
//   });
// }
