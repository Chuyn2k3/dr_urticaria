import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../utils/colors.dart';
import '../utils/styles.dart';

class CircleWithIcon extends StatefulWidget {
  static void x() {}

  const CircleWithIcon({
    Key? key,
    required this.boxSize,
    required this.iconSize,
    required this.icon,
    this.titleColor,
    this.color,
    this.title,
    this.onTap = x,
    this.colorIcon,
  }) : super(key: key);

  final double boxSize, iconSize;
  final String icon;
  final String? title;
  final Color? color;
  final Color? titleColor;
  final Function()? onTap;
  final Color? colorIcon;

  bool _isSvg() {
    return icon.endsWith('svg');
  }

  @override
  State<CircleWithIcon> createState() => _CircleWithIconState();
}

class _CircleWithIconState extends State<CircleWithIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: (_) {
          setState(() => _isPressed = true);
          _animationController.forward();
        },
        onTapUp: (_) {
          setState(() => _isPressed = false);
          _animationController.reverse();
        },
        onTapCancel: () {
          setState(() => _isPressed = false);
          _animationController.reverse();
        },
        onTap: widget.onTap,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: widget.boxSize,
              width: widget.boxSize,
              decoration: BoxDecoration(
                gradient: _isPressed
                    ? LinearGradient(
                        colors: [
                          const Color(0xFF0066CC).withOpacity(0.8),
                          const Color(0xFF004499).withOpacity(0.8),
                        ],
                      )
                    : LinearGradient(
                        colors: [
                          const Color(0xFF0066CC).withOpacity(0.1),
                          const Color(0xFF004499).withOpacity(0.1),
                        ],
                      ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0066CC)
                        .withOpacity(_isPressed ? 0.3 : 0.1),
                    blurRadius: _isPressed ? 15 : 10,
                    offset: Offset(0, _isPressed ? 8 : 4),
                  ),
                ],
              ),
              child: Center(
                child: widget._isSvg()
                    ? SvgPicture.asset(
                        widget.icon,
                        color: _isPressed
                            ? Colors.white
                            : (widget.colorIcon ?? const Color(0xFF0066CC)),
                        width: widget.iconSize * 0.6,
                        height: widget.iconSize * 0.6,
                      )
                    : ColorFiltered(
                        colorFilter: ColorFilter.mode(
                            _isPressed
                                ? Colors.white
                                : (widget.colorIcon ?? const Color(0xFF0066CC)),
                            BlendMode.srcIn),
                        child: Image.asset(
                          widget.icon,
                          width: widget.iconSize * 0.6,
                          height: widget.iconSize * 0.6,
                        ),
                      ),
              ),
            ),
            if (widget.title != null) ...[
              const SizedBox(height: 12),
              Text(
                widget.title ?? "",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: widget.titleColor ?? const Color(0xFF374151),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
