import 'dart:math';

import 'package:flutter/material.dart';

class Triangles extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TrianglesState();
  }
}

class _TrianglesState extends State<Triangles>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  List<Vertex> vertices;
  final int numberOfVertices = 30;
  final Color color = Colors.black;
  final double vertexSize = 1.5;

  @override
  void initState() {
    super.initState();

    // Initialize vertices
    vertices = List();
    int i = numberOfVertices;
    while (i > 0) {
      vertices.add(Vertex(color, vertexSize));
      i--;
    }

    // Init animation controller
    _controller = new AnimationController(
        duration: const Duration(seconds: 1000), vsync: this);
    _controller.addListener(() {
      updateVertexPosition();
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        foregroundPainter:
            VertexPainter(vertices: vertices, controller: _controller),
        size: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height),
      ),
    );
  }

  void updateVertexPosition() {
    vertices.forEach((it) => it.updatePosition());
    setState(() {});
  }
}

class VertexPainter extends CustomPainter {
  List<Vertex> vertices;
  AnimationController controller;

  VertexPainter({this.vertices, this.controller});

  @override
  void paint(Canvas canvas, Size canvasSize) {
    vertices.forEach((it) => it.draw(canvas, canvasSize));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Vertex {
  Color colour;
  double direction;
  double speed;
  double radius;
  double x;
  double y;

  Vertex(Color colour, double vertexSize) {
    this.colour = colour;
    this.direction = Random().nextDouble() * 360;
    this.speed = 0.3;
    this.radius = vertexSize;
  }

  draw(Canvas canvas, Size canvasSize) {
    Paint paint = new Paint()
      ..color = colour
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    assignRandomPositionIfUninitialized(canvasSize);

    randomlyChangeDirectionIfEdgeReached(canvasSize);

    canvas.drawCircle(Offset(x, y), radius, paint);
  }

  void assignRandomPositionIfUninitialized(Size canvasSize) {
    if (x == null) {
      this.x = Random().nextDouble() * canvasSize.width;
    }

    if (y == null) {
      this.y = Random().nextDouble() * canvasSize.height;
    }
  }

  updatePosition() {
    var a = 180 - (direction + 90);
    direction > 0 && direction < 180 ? x += speed : x -= speed;
    direction > 90 && direction < 270 ? y += speed : y -= speed;
  }

  randomlyChangeDirectionIfEdgeReached(Size canvasSize) {
    if (x > canvasSize.width || x < 0 || y > canvasSize.height || y < 0) {
      direction = Random().nextDouble() * 360;
    }
  }
}
