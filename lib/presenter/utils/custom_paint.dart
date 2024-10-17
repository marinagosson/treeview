import 'package:flutter/material.dart';

class LShapeBorderPainter extends CustomPainter {
  final double lineWidth;
  final double baseLength;
  final Color color;

  LShapeBorderPainter({
    required this.lineWidth,
    required this.baseLength,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;

    // Desenhar a linha vertical do L (à esquerda)
    canvas.drawLine(
      Offset(0, 0),               // Ponto inicial (canto superior esquerdo)
      Offset(0, size.height),      // Ponto final (parte inferior)
      paint,
    );

    // Desenhar a linha horizontal do L (base parcial)
    canvas.drawLine(
      Offset(0, size.height),       // Começo da base no canto inferior esquerdo
      Offset(baseLength, size.height), // Tamanho da base personalizada
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}