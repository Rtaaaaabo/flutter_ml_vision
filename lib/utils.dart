import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:meta/meta.dart';

bool isDetecting = false;

Future<CameraDescription> getFrontCamera() async {
  return await availableCameras().then((cameras) => cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front));
}

void cameraBytesToDetector({
  @required CameraController camera,
  @required FaceDetector detector,
  @required void updateFace(Face face),
}) {
  camera.startImageStream((image) {
    if (isDetecting) return;

    isDetecting = true;

    detector.processImage(FirebaseVisionImage.fromBytes(
        image.planes[0].bytes,
        FirebaseVisionImageMetadata(
          size: camera.value.previewSize,
          rotation: ImageRotation.rotation270,
        )));
        .then((faces) {
          updateFace(faces.isEmpty ? null : faces[0]);
          isDetecting = false;
        });
  });
}
