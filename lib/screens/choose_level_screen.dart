import 'package:flutter/material.dart';

class ChooseLevelScreen extends StatefulWidget {
  const ChooseLevelScreen({super.key});

  @override
  State<ChooseLevelScreen> createState() => _ChooseLevelScreenState();
}

class _ChooseLevelScreenState extends State<ChooseLevelScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
      upperBound: 1.3,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: Scaffold(
        backgroundColor: Colors.redAccent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text("tes"),
              ElevatedButton(
                onPressed: () {
                  _controller.reverse().then(
                    (value) => Navigator.of(context).pop(),
                  );
                },
                child: Text("back"),
              ),
            ],
          ),
        ),
      ),
      builder: (context, child) {
        return ClipPath(clipper: MyClipper(_controller.value), child: child);
      },
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  MyClipper(this.value);
  final double value;

  @override
  Path getClip(Size size) {
    var path = Path();
    path.addOval(
      Rect.fromCircle(
        center: Offset(size.height, size.height),
        radius: value * size.width,
      ),
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
