import 'package:flutter/material.dart';

class CloudAnimation extends StatefulWidget {
  const CloudAnimation({Key? key}) : super(key: key);

  @override
  _CloudAnimationState createState() => _CloudAnimationState();
}

class _CloudAnimationState extends State<CloudAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: CloudPainter(
            cloudOffset: _controller.value * MediaQuery.of(context).size.width,
          ),
          child: Container(),
        );
      },
    );
  }
}

class CloudPainter extends CustomPainter {
  final double cloudOffset;

  CloudPainter({required this.cloudOffset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromARGB(255, 170, 162, 162).withOpacity(0.5);
    final path = Path();
    final cloudRadius = 30.0;
    final cloudSpacing = 80.0;
    final cloudHeight = size.height / 3.0;

    for (double i = -cloudSpacing;
        i < size.width + cloudSpacing;
        i += cloudSpacing) {
      path.addOval(Rect.fromCircle(
        center: Offset(i + cloudOffset, cloudHeight),
        radius: cloudRadius,
      ));
      path.addOval(Rect.fromCircle(
        center: Offset(
            i + cloudOffset + cloudRadius / 2, cloudHeight - cloudRadius / 2),
        radius: cloudRadius * 1.5,
      ));
      path.addOval(Rect.fromCircle(
        center: Offset(
            i + cloudOffset + cloudRadius, cloudHeight - cloudRadius / 2),
        radius: cloudRadius * 1.7,
      ));
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
