// ignore_for_file: always_specify_types

import 'package:flutter/material.dart';
import 'dart:math';

class QuienParaLogo extends StatelessWidget {
  const QuienParaLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icono gráfico personalizado
          CustomPaint(
            size: Size(100, 100), // Tamaño del icono
            painter: LogoPainter(),
          ),
          SizedBox(height: 8), // Espaciado entre el icono y el texto
          // Texto "Quién Para?"
          Text(
            "Quién Para?",
            style: TextStyle(
              fontFamily: 'Poppins', // Fuente principal
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Color del texto
            ),
          ),
        ],
      ),
    );
  }
}

// Clase para dibujar el icono gráfico
class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Color(0xFFFF6F61) // Naranja (#FF6F61)
      ..style = PaintingStyle.fill;

    final Paint paintBlue = Paint()
      ..color = Color(0xFF4FC3F7) // Azul claro (#4FC3F7)
      ..style = PaintingStyle.fill;

    final Paint paintWhite = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Dibujar el círculo dividido en dos mitades
    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      -pi / 2,
      pi,
      true,
      paint,
    );

    canvas.drawArc(
      Rect.fromLTWH(0, 0, size.width, size.height),
      pi / 2,
      pi,
      true,
      paintBlue,
    );

    // Dibujar los puntos dentro del círculo
    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.5),
      8,
      paintWhite,
    );
    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.5),
      8,
      paintWhite,
    );

    // Dibujar la línea curva que conecta los puntos
    final Path path = Path();
    path.moveTo(size.width * 0.3, size.height * 0.5);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.3,
      size.width * 0.7,
      size.height * 0.5,
    );
    canvas.drawPath(path, paintWhite);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
