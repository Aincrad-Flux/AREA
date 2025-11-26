import 'package:flutter/material.dart';

import '../../constants/palette.dart';

class GridPainter extends CustomPainter {
  const GridPainter({required this.offset});

  final Offset offset;

  static const double _spacing = 24;

  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()..color = AppPalette.canvas;
    final gridPaint = Paint()
      ..color = AppPalette.canvasGrid
      ..strokeWidth = .5;

    canvas.drawRect(Offset.zero & size, background);

    final double shiftX = offset.dx % _spacing;
    final double shiftY = offset.dy % _spacing;

    for (double x = -_spacing * 2; x < size.width + _spacing * 2; x += _spacing) {
      final double drawX = x + shiftX;
      canvas.drawLine(Offset(drawX, -_spacing * 2), Offset(drawX, size.height + _spacing * 2), gridPaint);
    }
    for (double y = -_spacing * 2; y < size.height + _spacing * 2; y += _spacing) {
      final double drawY = y + shiftY;
      canvas.drawLine(Offset(-_spacing * 2, drawY), Offset(size.width + _spacing * 2, drawY), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant GridPainter oldDelegate) => oldDelegate.offset != offset;
}

