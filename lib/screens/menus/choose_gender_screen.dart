import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toilet_training/screens/menus/choose_level_screen.dart';

class ChooseGenderScreen extends StatefulWidget {
  const ChooseGenderScreen({super.key});

  @override
  State<ChooseGenderScreen> createState() => _ChooseGenderScreenState();
}

class _ChooseGenderScreenState extends State<ChooseGenderScreen>
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
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _controller.reverse().then(
                      (value) => Navigator.of(context).pop(),
                    );
                  },
                  child: Text("back"),
                ),
                Card(child: Text("Next")),
              ],
            ),
            Center(child: Text("Pilih Jenis Kelamin Mu")),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Get.to(
                      () => ChooseLevelScreen(),
                      transition: Transition.circularReveal,
                      duration: Duration(milliseconds: 1500),
                    );
                  },
                  child: Column(
                    children: [
                      Image.network(
                        "https://images.unsplash.com/photo-1484517586036-ed3db9e3749e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80",
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                      Text("Laki-laki"),
                    ],
                  ),
                ),
                SizedBox(width: 10.0),
                InkWell(
                  onTap: () {
                    Get.to(
                      () => ChooseLevelScreen(),
                      transition: Transition.circularReveal,
                      duration: Duration(milliseconds: 1500),
                    );
                  },
                  child: Column(
                    children: [
                      Image.network(
                        "https://images.unsplash.com/photo-1484517586036-ed3db9e3749e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80",
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                      Text("Perempuan"),
                    ],
                  ),
                ),
              ],
            ),
          ],
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
