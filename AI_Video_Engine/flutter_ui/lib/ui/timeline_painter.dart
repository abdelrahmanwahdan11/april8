// File: flutter_ui/lib/ui/timeline_painter.dart
import 'package:flutter/material.dart';

class TimelinePainter extends CustomPainter {
  final double progressPercentage; // 0.0 to 1.0
  final List<Map<String, dynamic>> aiMarkers;

  TimelinePainter({required this.progressPercentage, required this.aiMarkers});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background
    final bgPaint = Paint()..color = Colors.grey[900]!;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Draw markers
    for (var marker in aiMarkers) {
      double startX = (marker['startTime'] as double) * size.width;
      double endX = (marker['endTime'] as double) * size.width;

      Paint markerPaint = Paint();
      if (marker['type'] == 'shake') {
        markerPaint.color = Colors.red.withOpacity(0.6);
      } else if (marker['type'] == 'low_light') {
        markerPaint.color = Colors.yellow.withOpacity(0.6);
      } else {
        markerPaint.color = Colors.blue.withOpacity(0.6);
      }

      canvas.drawRect(Rect.fromLTWH(startX, 0, endX - startX, size.height), markerPaint);
    }

    // Draw playhead
    final playheadX = size.width * progressPercentage;
    final playheadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0;

    canvas.drawLine(Offset(playheadX, 0), Offset(playheadX, size.height), playheadPaint);
  }

  @override
  bool shouldRepaint(covariant TimelinePainter oldDelegate) {
    return oldDelegate.progressPercentage != progressPercentage || oldDelegate.aiMarkers != aiMarkers;
  }
}
