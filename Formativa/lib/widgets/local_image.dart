import 'package:flutter/material.dart';

class LocalImage extends StatelessWidget {
  const LocalImage({
    super.key,
    required this.imageUrl,
    this.borderRadius = 16,
    this.fit = BoxFit.cover,
  });

  final String imageUrl;
  final double borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.network(
          imageUrl,
          fit: fit,
          errorBuilder: (_, __, ___) => Container(
            color: const Color(0xffdfe5e8),
            alignment: Alignment.center,
            child: const Icon(Icons.image_outlined, color: Color(0xff9299a3)),
          ),
        ),
      );
}
