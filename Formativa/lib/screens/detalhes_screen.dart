import 'package:flutter/material.dart';

import '../models/local.dart';
import '../theme/app_theme.dart';
import '../widgets/local_image.dart';
import '../widgets/quick_action_tile.dart';
import '../widgets/rating_stars.dart';

class DetalhesScreen extends StatefulWidget {
  const DetalhesScreen(
      {super.key, required this.local, this.onFavoriteChanged});

  final Local local;
  final ValueChanged<Local>? onFavoriteChanged;

  @override
  State<DetalhesScreen> createState() => _DetalhesScreenState();
}

class _DetalhesScreenState extends State<DetalhesScreen> {
  late Local _local;

  @override
  void initState() {
    super.initState();
    _local = widget.local;
  }

  void _toggleFavorite() {
    setState(() => _local = _local.copyWith(favorito: !_local.favorito));
    widget.onFavoriteChanged?.call(_local);
  }

  void _message(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label estará disponível em breve.')),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _HeroHeader(
                local: _local,
                onBack: () => Navigator.of(context).pop(_local),
                onShare: () => _message('Compartilhamento'),
              ),
            ),
            SliverToBoxAdapter(
              child: Transform.translate(
                offset: const Offset(0, -18),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PlaceOverview(
                        local: _local,
                        onFavorite: _toggleFavorite,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          QuickActionTile(
                            label: 'Ligar',
                            icon: Icons.phone_rounded,
                            color: AppColors.primary,
                            background: const Color(0xffdcf8f8),
                            onTap: () => _message('Ligação'),
                          ),
                          const SizedBox(width: 9),
                          QuickActionTile(
                            label: 'Como chegar',
                            icon: Icons.near_me_rounded,
                            color: const Color(0xfff29d38),
                            background: const Color(0xfffff0dc),
                            onTap: () => _message('Rotas'),
                          ),
                          const SizedBox(width: 9),
                          QuickActionTile(
                            label: 'Agendar',
                            icon: Icons.calendar_month_rounded,
                            color: const Color(0xff8b59db),
                            background: const Color(0xffeee6ff),
                            onTap: () => _message('Agendamento'),
                          ),
                          const SizedBox(width: 9),
                          QuickActionTile(
                            label: 'Sobre',
                            icon: Icons.info_outline_rounded,
                            color: const Color(0xff488de9),
                            background: const Color(0xffe4f0ff),
                            onTap: () => _message('Mais informações'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text('Sobre',
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(
                        _local.descricao,
                        style: const TextStyle(
                          color: AppColors.muted,
                          height: 1.45,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 25),
                      Row(
                        children: [
                          Text('Fotos',
                              style: Theme.of(context).textTheme.titleLarge),
                          const Spacer(),
                          TextButton(
                            onPressed: () => _message('Galeria de fotos'),
                            child: const Text('Ver todas'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        height: 92,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _photoUrls.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 10),
                          itemBuilder: (context, index) => SizedBox(
                            width: 120,
                            child: LocalImage(
                              imageUrl: index == 0
                                  ? _local.imagemUrl
                                  : _photoUrls[index],
                              borderRadius: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({
    required this.local,
    required this.onBack,
    required this.onShare,
  });

  final Local local;
  final VoidCallback onBack;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: MediaQuery.sizeOf(context).height * .34,
        child: Stack(
          fit: StackFit.expand,
          children: [
            LocalImage(imageUrl: local.imagemUrl, borderRadius: 0),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x4d000000), Color(0x00000000)],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.paddingOf(context).top + 12,
              left: 18,
              child: _RoundHeaderButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onPressed: onBack,
              ),
            ),
            Positioned(
              top: MediaQuery.paddingOf(context).top + 12,
              right: 18,
              child: _RoundHeaderButton(
                icon: Icons.ios_share_rounded,
                onPressed: onShare,
              ),
            ),
          ],
        ),
      );
}

class _RoundHeaderButton extends StatelessWidget {
  const _RoundHeaderButton({required this.icon, required this.onPressed});
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        shape: const CircleBorder(),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(icon, size: 19, color: AppColors.ink),
        ),
      );
}

class _PlaceOverview extends StatelessWidget {
  const _PlaceOverview({required this.local, required this.onFavorite});
  final Local local;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        local.nome,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    IconButton(
                      onPressed: onFavorite,
                      icon: Icon(
                        local.favorito
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: local.favorito
                            ? const Color(0xffff6576)
                            : AppColors.muted,
                      ),
                    ),
                  ],
                ),
                Text(
                  local.categoria,
                  style: const TextStyle(color: AppColors.muted, fontSize: 13),
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    RatingStars(rating: local.avaliacao, size: 15),
                    const SizedBox(width: 4),
                    Text(
                      '(${local.totalAvaliacoes})',
                      style:
                          const TextStyle(color: AppColors.muted, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                _DetailLine(
                  icon: Icons.location_on_rounded,
                  text: '${local.distancia.toStringAsFixed(1)} km',
                ),
                const SizedBox(height: 5),
                _DetailLine(
                  icon: Icons.access_time_filled_rounded,
                  text: local.horario,
                  color: const Color(0xff22a06b),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const _MiniRoute(),
        ],
      );
}

class _DetailLine extends StatelessWidget {
  const _DetailLine(
      {required this.icon, required this.text, this.color = AppColors.ink});
  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: color, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      );
}

class _MiniRoute extends StatelessWidget {
  const _MiniRoute();

  @override
  Widget build(BuildContext context) => Container(
        width: 91,
        height: 105,
        decoration: BoxDecoration(
          color: const Color(0xffe7eef0),
          borderRadius: BorderRadius.circular(15),
        ),
        child: CustomPaint(painter: _RoutePainter()),
      );
}

class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final street = Paint()
      ..color = Colors.white
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(12, 12),
        Offset(size.width - 17, size.height - 13), street);
    canvas.drawLine(
        Offset(size.width - 13, 14), Offset(15, size.height - 18), street);

    final route = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final path = Path()
      ..moveTo(25, 16)
      ..lineTo(48, 36)
      ..lineTo(37, 55)
      ..lineTo(65, 79);
    canvas.drawPath(path, route);
    canvas.drawCircle(
        const Offset(25, 16), 4, Paint()..color = AppColors.primary);
    canvas.drawCircle(
        const Offset(65, 79), 4, Paint()..color = const Color(0xffff6576));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

const _photoUrls = <String>[
  'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&w=400&q=80',
  'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?auto=format&fit=crop&w=400&q=80',
  'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?auto=format&fit=crop&w=400&q=80',
];
