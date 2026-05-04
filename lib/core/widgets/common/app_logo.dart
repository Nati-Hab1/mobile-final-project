import 'package:flutter/material.dart';

/// Menesha brand logo widget.
/// Shows the stylized "M" icon with optional label underneath.
class AppLogo extends StatelessWidget {
  final double size;
  final bool showLabel;
  final bool darkBackground;

  const AppLogo({
    super.key,
    this.size = 56,
    this.showLabel = true,
    this.darkBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: darkBackground
                ? Colors.white
                : Color(
                    0xFF2E3A6E,
                  ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                  0.2,
                ),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: _MLogoMark(
              size: size * 0.55,
              darkBackground: darkBackground,
            ),
          ),
        ),
        if (showLabel) ...[
          const SizedBox(height: 6),
          Text(
            'Menesha',
            style: TextStyle(
              color: darkBackground
                  ? Color(
                      0xFFFFFFFF,
                    )
                  : Color(
                      0xFF2E3A6E,
                    ),
              fontSize: size * 0.22,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ],
    );
  }
}

/// Custom painted "M" logo mark with the arrow detail from the Figma design.
class _MLogoMark extends StatelessWidget {
  final double size;
  final bool darkBackground;

  const _MLogoMark({
    required this.size,
    required this.darkBackground,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _MLogoPainter(
        darkBackground: darkBackground,
      ),
    );
  }
}

class _MLogoPainter extends CustomPainter {
  final bool darkBackground;

  _MLogoPainter({required this.darkBackground});

  @override
  void paint(Canvas canvas, Size size) {
    final bodyColor = darkBackground
        ? Color(
            0xFF2E3A6E,
          )
        : Colors.white;
    final accentColor = Color(
      0xFF2952FF,
    );
    final starColor = const Color(
      0xFFFFD700,
    ); // Gold for star accent

    final paint = Paint()
      ..color = bodyColor
      ..style = PaintingStyle.fill;

    // Draw stylized M letter
    final path = Path();
    final w = size.width;
    final h = size.height;

    // Left leg
    path.moveTo(w * 0.05, h * 0.85);
    path.lineTo(w * 0.05, h * 0.2);
    path.lineTo(w * 0.22, h * 0.2);
    path.lineTo(w * 0.5, h * 0.55);
    path.lineTo(w * 0.78, h * 0.2);
    path.lineTo(w * 0.95, h * 0.2);
    path.lineTo(w * 0.95, h * 0.85);
    path.lineTo(w * 0.78, h * 0.85);
    path.lineTo(w * 0.78, h * 0.45);
    path.lineTo(w * 0.5, h * 0.75);
    path.lineTo(w * 0.22, h * 0.45);
    path.lineTo(w * 0.22, h * 0.85);
    path.close();

    canvas.drawPath(path, paint);

    // Draw upward arrow accent (top right of M)
    final arrowPaint = Paint()
      ..color = accentColor
      ..style = PaintingStyle.fill;

    final arrowPath = Path();
    arrowPath.moveTo(w * 0.82, h * 0.15);
    arrowPath.lineTo(w * 0.95, h * 0.02);
    arrowPath.lineTo(w * 0.95, h * 0.12);
    arrowPath.lineTo(w * 1.05, h * 0.12);
    arrowPath.lineTo(w * 1.05, h * 0.25);
    arrowPath.lineTo(w * 0.95, h * 0.25);
    arrowPath.lineTo(w * 0.82, h * 0.15);
    canvas.drawPath(arrowPath, arrowPaint);

    // Small star sparkle top left
    final starPaint = Paint()
      ..color = starColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(w * 0.12, h * 0.08),
      w * 0.06,
      starPaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) =>
      false;
}
