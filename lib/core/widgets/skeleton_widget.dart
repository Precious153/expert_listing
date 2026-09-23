import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SkeletonWidget extends StatefulWidget {
  final double? width;
  final double? height;
  final double? borderRadius;
  final BoxShape shape;
  final Widget? child;

  const SkeletonWidget({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.child,
  });

  @override
  State<SkeletonWidget> createState() => _SkeletonWidgetState();
}

class _SkeletonWidgetState extends State<SkeletonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
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
        return Opacity(
          opacity: _animation.value,
          child: child,
        );
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: AppColors.border.withValues(alpha: 0.5),
          shape: widget.shape,
          borderRadius: widget.shape == BoxShape.rectangle
              ? BorderRadius.circular(widget.borderRadius ?? 8.r)
              : null,
        ),
        child: widget.child,
      ),
    );
  }
}
