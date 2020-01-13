import 'dart:ui' as ui show Image;
import 'dart:math' as Math;
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

class FacePaint extends CustomPaint {
  final CustomPainter painter;

  FacePaint({this.painter}) : super(painter: painter);
}

class SmilePainter extends CustomPainter {
  final ui.Image image;
  final List<Face> faces;

  SmilePainter(this.image, this.faces);

  @override
  void paint(Canvas canvas, Size size) {
    if (image != null) {
      canvas.drawImage(image, Offset.zero, Paint());
    }

    final paintRectStyle = Paint()
      ..color = Colors.red
      ..strokeWidth = 30.0
      ..style = PaintingStyle.stroke;

    // Draw Body
    final paint = Paint()..color = Colors.yellow;

    for (var i = 0; i < faces.length; i++) {
      final radius =
          Math.min(faces[i].boundingBox.width, faces[i].boundingBox.height) / 2;
      final center = faces[i].boundingBox.center;
      final smilePaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius / 8;
      canvas.drawRect(faces[i].boundingBox, paintRectStyle);
      canvas.drawCircle(center, radius, paint);
      canvas.drawArc(
          Rect.fromCircle(
              center: center.translate(0, radius / 8), radius: radius / 2),
          0,
          Math.pi,
          false,
          smilePaint);

      // Draw the eyes
      canvas.drawCircle(Offset(center.dx - radius / 2, center.dy - radius / 2),
          radius / 8, Paint());
      canvas.drawCircle(Offset(center.dx + radius / 2, center.dy - radius / 2),
          radius / 8, Paint());
    }
  }

  @override
  bool shouldRepaint(SmilePainter oldDelegate) {
    return image != oldDelegate.image || faces != oldDelegate.faces;
  }
}

class SmilePainterLiveCamera extends CustomPainter {
  final Size imageSize;
  final List<Face> faces;

  SmilePainterLiveCamera(this.imageSize, this.faces);
}
