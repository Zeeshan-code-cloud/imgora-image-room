import 'package:flutter/material.dart';

class AnimatedGradientBackground extends StatefulWidget {
  final Widget child;

  const AnimatedGradientBackground({
    super.key,
    required this.child,
  });

  @override
  State<AnimatedGradientBackground> createState() => _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // 3 seconds duration makes the gradient animation lively, premium, and faster
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Animate the purple accent color from bottom to top
        final beginY = Tween<double>(begin: 1.5, end: -1.5).evaluate(_animation);
        final endY = Tween<double>(begin: 0.5, end: -2.5).evaluate(_animation);
        
        // Add a subtle diagonal drift for a premium liquid look
        final beginX = Tween<double>(begin: -0.8, end: 0.8).evaluate(_animation);
        final endX = Tween<double>(begin: 0.8, end: -0.8).evaluate(_animation);

        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: const [
                Color(0xff211d3a), // Purple glow
                Color(0xff0B0F1A), // Primary dark background
                Color(0xff0B0F1A), // Primary dark background
              ],
              begin: Alignment(beginX, beginY),
              end: Alignment(endX, endY),
            ),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
