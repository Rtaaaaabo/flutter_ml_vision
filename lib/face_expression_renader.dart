import 'package:camera/camera.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/foundation.dart';
import 'utils.dart';

class FaceExpressionReader extends ValueNotifier<Face> {
  FaceExpressionReader() : super(null) {
    init();
  }

  CameraController camera;
  FaceDetector detector;

  void init() async {
    camera = CameraController(await getFrontCamera(), ResolutionPreset.low);
    await camera.initialize();

    detector = FirebaseVision.instance.faceDetector(FaceDetectorOptions(
      enableClassification: true,
      mode: FaceDetectorMode.accurate,
    ));

    cameraBytesToDetector(
        camera: camera,
        detector: detector,
        updateFace: (face) {
          value = face;
        });
  }
}
