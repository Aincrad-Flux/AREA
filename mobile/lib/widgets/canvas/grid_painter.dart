import 'package:flutter/material.dart';

import '../../constants/palette.dart';

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()..color = AppPalette.canvas;
    final gridPaint = Paint()
      ..color = AppPalette.canvasGrid
      ..strokeWidth = .5;

    canvas.drawRect(Offset.zero & size, background);

    for (double x = 0; x < size.width; x += 24) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 24) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

