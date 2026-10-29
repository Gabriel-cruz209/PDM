import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({
    super.key,
    required this.rating,
    this.size = 14,
    this.showValue = true,
    this.color = const Color(0xffffb400),
  });

  final double rating;
  final double size;
  final bool showValue;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final fullStars = rating.floor().clamp(0, 5);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var index = 0; index < 5; index++)
          Icon(
            index < fullStars ? Icons.star_rounded : Icons.star_outline_rounded,
            color: color,
            size: size,
          ),
        if (showValue) ...[
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(fontSize: size - 2, fontWeight: FontWeight.w700),
          ),
        ],
      ],
    );
  }
}
