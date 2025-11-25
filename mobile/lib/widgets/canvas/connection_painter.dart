import 'package:flutter/material.dart';

import '../../constants/palette.dart';
import '../../models/models.dart';

class ConnectionPainter extends CustomPainter {
  ConnectionPainter({required this.nodes, required this.connections});

  final List<PipelineNode> nodes;
  final List<NodeConnection> connections;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppPalette.accent
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (final conn in connections) {
      final from = nodes.where((node) => node.id == conn.from).firstOrNull;
      final to = nodes.where((node) => node.id == conn.to).firstOrNull;
      if (from == null || to == null) continue;
      final start = Offset(from.position.dx + 210, from.position.dy + 70);
      final end = Offset(to.position.dx, to.position.dy + 70);
      final control1 = Offset((start.dx + end.dx) / 2, start.dy);
      final control2 = Offset((start.dx + end.dx) / 2, end.dy);
      final path = Path()
        ..moveTo(start.dx, start.dy)
        ..cubicTo(control1.dx, control1.dy, control2.dx, control2.dy, end.dx, end.dy);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ConnectionPainter oldDelegate) {
    return oldDelegate.nodes != nodes || oldDelegate.connections != connections;
  }
}

