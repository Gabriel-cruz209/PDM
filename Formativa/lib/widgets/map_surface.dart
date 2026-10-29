import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../models/local.dart';
import '../theme/app_theme.dart';

class MapSurface extends StatelessWidget {
  const MapSurface({
    super.key,
    required this.locais,
    required this.selectedId,
    required this.onSelect,
  });

  final List<Local> locais;
  final String selectedId;
  final ValueChanged<Local> onSelect;

  static const _positions = <String, Offset>{
    'academia-fitness': Offset(.57, .41),
    'smart-fit': Offset(.27, .31),
    'body-center': Offset(.72, .64),
    'cafe-central': Offset(.31, .69),
  };

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: LayoutBuilder(
          builder: (context, constraints) => Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(painter: _MapPainter()),
              for (final local in locais)
                _positionedPin(
                  constraints,
                  local,
                  _positions[local.id] ?? const Offset(.5, .5),
                ),
              const Positioned(
                right: 14,
                bottom: 82,
                child: _MapControl(icon: Icons.my_location_rounded),
              ),
              const Positioned(
                right: 14,
                bottom: 28,
                child: _MapControl(icon: Icons.layers_outlined),
              ),
            ],
          ),
        ),
      );

  Widget _positionedPin(BoxConstraints constraints, Local local, Offset point) {
    final selected = local.id == selectedId;
    return Positioned(
      left: point.dx * constraints.maxWidth - (selected ? 18 : 16),
      top: point.dy * constraints.maxHeight - 38,
      child: _MapPin(
        local: local,
        selected: selected,
        onTap: () => onSelect(local),
      ),
    );
  }
}

class _MapControl extends StatelessWidget {
  const _MapControl({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
        width: 42,
        height: 42,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Color(0x19000000), blurRadius: 12, offset: Offset(0, 4)),
          ],
        ),
        child: Icon(icon, size: 20, color: AppColors.ink),
      );
}

class _MapPin extends StatelessWidget {
  const _MapPin(
      {required this.local, required this.selected, required this.onTap});
  final Local local;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selected)
              Container(
                margin: const EdgeInsets.only(top: 5, right: 6),
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x2600aeb6),
                        blurRadius: 10,
                        offset: Offset(0, 4)),
                  ],
                ),
                child: Text(
                  local.nome,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                  ),
                ),
              ),
            _PinShape(selected: selected),
          ],
        ),
      );
}

class _PinShape extends StatelessWidget {
  const _PinShape({required this.selected});
  final bool selected;

  @override
  Widget build(BuildContext context) => CustomPaint(
        size: const Size(34, 40),
        painter:
            _PinPainter(selected ? AppColors.primary : const Color(0xff3d4654)),
        child: const SizedBox(width: 34, height: 40),
      );
}

class _PinPainter extends CustomPainter {
  const _PinPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..cubicTo(4, 24, 2, 17, 2, 12)
      ..arcToPoint(Offset(size.width - 2, 12),
          radius: Radius.circular(size.width / 2))
      ..cubicTo(
          size.width - 2, 17, size.width - 4, 24, size.width / 2, size.height)
      ..close();
    canvas.drawShadow(path, Colors.black, 4, true);
    canvas.drawPath(path, paint);
    canvas.drawCircle(
        Offset(size.width / 2, 12), 5, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _PinPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(const Color(0xffe8edf0), BlendMode.srcOver);
    final blockPaint = Paint()..color = const Color(0xfff8fafb);
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    final minorRoad = Paint()
      ..color = const Color(0xffd9e0e4)
      ..strokeWidth = 1.2;
    final parkPaint = Paint()..color = const Color(0xffd5e9df);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * .58, size.height * .09, size.width * .33,
            size.height * .21),
        const Radius.circular(32),
      ),
      parkPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * .05, size.height * .60, size.width * .26,
            size.height * .22),
        const Radius.circular(24),
      ),
      parkPaint,
    );

    final blocks = <Rect>[
      Rect.fromLTWH(10, 12, size.width * .22, size.height * .16),
      Rect.fromLTWH(size.width * .29, 5, size.width * .19, size.height * .20),
      Rect.fromLTWH(size.width * .08, size.height * .27, size.width * .28,
          size.height * .20),
      Rect.fromLTWH(size.width * .42, size.height * .34, size.width * .22,
          size.height * .18),
      Rect.fromLTWH(size.width * .70, size.height * .39, size.width * .23,
          size.height * .17),
      Rect.fromLTWH(size.width * .36, size.height * .64, size.width * .25,
          size.height * .23),
      Rect.fromLTWH(size.width * .70, size.height * .69, size.width * .22,
          size.height * .18),
    ];
    for (final block in blocks) {
      canvas.drawRRect(
          RRect.fromRectAndRadius(block, const Radius.circular(10)),
          blockPaint);
    }

    final roads = <List<Offset>>[
      [
        Offset(-10, size.height * .18),
        Offset(size.width * .34, size.height * .30),
        Offset(size.width + 10, size.height * .18)
      ],
      [
        Offset(size.width * .12, -10),
        Offset(size.width * .43, size.height * .37),
        Offset(size.width * .31, size.height + 10)
      ],
      [
        Offset(size.width * .85, -10),
        Offset(size.width * .62, size.height * .48),
        Offset(size.width * .88, size.height + 10)
      ],
      [
        Offset(-10, size.height * .70),
        Offset(size.width * .45, size.height * .58),
        Offset(size.width + 10, size.height * .72)
      ],
    ];
    for (final road in roads) {
      canvas.drawPoints(ui.PointMode.polygon, road, roadPaint);
    }

    final random = math.Random(8);
    for (var index = 0; index < 26; index++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      canvas.drawLine(Offset(x, y), Offset(x + 35, y + 22), minorRoad);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
