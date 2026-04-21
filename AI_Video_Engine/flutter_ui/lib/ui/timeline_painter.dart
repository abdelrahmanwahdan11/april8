import 'package:flutter/material.dart';

class TimelinePainter extends CustomPainter {
  final int progressMs;
  final int totalDurationMs;
  final List<Map<String, dynamic>> aiMarkers;

  TimelinePainter({
    required this.progressMs,
    required this.totalDurationMs,
    required this.aiMarkers,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    final bgPaint = Paint()..color = const Color(0xFF1E1E1E);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    if (totalDurationMs == 0) return;

    // AI Markers
    for (var marker in aiMarkers) {
      double startX = (marker['startTime'] / totalDurationMs) * size.width;
      double endX = (marker['endTime'] / totalDurationMs) * size.width;

      Color markerColor;
      if (marker['type'] == 'shake') {
        markerColor = Colors.red.withOpacity(0.6);
      } else if (marker['type'] == 'low_light') {
        markerColor = Colors.yellow.withOpacity(0.6);
      } else {
        markerColor = Colors.blue.withOpacity(0.6);
      }

      final markerPaint = Paint()..color = markerColor;
      canvas.drawRect(Rect.fromLTWH(startX, 0, endX - startX, size.height), markerPaint);
    }

    // Playhead
    double playheadX = (progressMs / totalDurationMs) * size.width;
    final playheadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0;

    canvas.drawLine(Offset(playheadX, 0), Offset(playheadX, size.height), playheadPaint);
  }

  @override
  bool shouldRepaint(covariant TimelinePainter oldDelegate) {
    return oldDelegate.progressMs != progressMs ||
           oldDelegate.totalDurationMs != totalDurationMs ||
           oldDelegate.aiMarkers != aiMarkers;
  }
}
