import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(32.0),
          child: SquareAnimation(),
        ),
      ),
    );
  }
}

class SquareAnimation extends StatefulWidget {
  const SquareAnimation({super.key});

  @override
  State<SquareAnimation> createState() => _SquareAnimationState();
}

class _SquareAnimationState extends State<SquareAnimation> {
  static const double _squareSize = 50.0;

  Alignment alignment = Alignment.center; // Start in the center
  Duration duration = const Duration(seconds: 10);
  Curve curve = Curves.fastOutSlowIn;

  bool isAnimating = false; // Track animation state
  String activeButton = 'center'; // 'left', 'right', or 'center

  void moveLeft() {
    if (!isAnimating) {
      setState(() {
        alignment = Alignment.centerLeft;
        activeButton = 'left';
        isAnimating = true; // Disable buttons
      });

      Future.delayed(duration, () {
        setState(() {
          isAnimating = false; // Enable buttons after animation
        });
      });
    }
  }

  void moveRight() {
    if (!isAnimating) {
      setState(() {
        alignment = Alignment.centerRight;
        activeButton = 'right';
        isAnimating = true; // Disable buttons
      });

      Future.delayed(duration, () {
        setState(() {
          isAnimating = false; // Enable buttons after animation
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 100, // Space for animation
          width: double.infinity, // Full width
          child: AnimatedAlign(
            alignment: alignment,
            duration: duration,
            curve: curve,
            child: Container(
              width: _squareSize,
              height: _squareSize,
              decoration: BoxDecoration(
                color: Colors.red,
                border: Border.all(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: isAnimating ? null : moveLeft, // Disable while animating
              style: ElevatedButton.styleFrom(
                backgroundColor: activeButton == 'left'
                    ? Colors.grey[400] // Inactive button color
                    : null,
              ),
              child: const Text('Left'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: isAnimating ? null : moveRight, // Disable while animating
              style: ElevatedButton.styleFrom(
                backgroundColor: activeButton == 'right'
                    ? Colors.grey[400] // Inactive button color
                    : null,
              ),
              child: const Text('Right'),
            ),
          ],
        ),
      ],
    );
  }
}
