import 'package:flutter/material.dart';

import '../models/local.dart';
import '../theme/app_theme.dart';
import 'local_image.dart';
import 'rating_stars.dart';

class LocalResultCard extends StatelessWidget {
  const LocalResultCard({
    super.key,
    required this.local,
    required this.onTap,
    required this.onFavorite,
  });

  final Local local;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Ink(
            height: 118,
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x120d1b2a),
                  blurRadius: 13,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 94,
                  height: double.infinity,
                  child:
                      LocalImage(imageUrl: local.imagemUrl, borderRadius: 12),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                local.nome,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.ink,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: onFavorite,
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints.tightFor(
                                  width: 28, height: 28),
                              icon: Icon(
                                local.favorito
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color: local.favorito
                                    ? const Color(0xffff6576)
                                    : const Color(0xffb4b8bc),
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        Text(local.categoria,
                            style: const TextStyle(
                                color: AppColors.muted, fontSize: 11)),
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined,
                                size: 13, color: AppColors.muted),
                            const SizedBox(width: 2),
                            Text(
                              '${local.distancia.toStringAsFixed(1)} km',
                              style: const TextStyle(
                                  color: AppColors.ink, fontSize: 11),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        RatingStars(rating: local.avaliacao, size: 13),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
