import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/favorites_provider.dart';

class WeatherAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String cityName;
  final VoidCallback onSearchTap;
  final VoidCallback onFavoriteTap;
  final VoidCallback onMenuTap;

  const WeatherAppBar({
    super.key,
    required this.cityName,
    required this.onSearchTap,
    required this. onFavoriteTap,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoritesProvider. notifier).isFavorite(cityName);

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon:  const Icon(Icons.menu, color: Colors.white),
        onPressed: onMenuTap,
        tooltip: 'Menu',
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.location_on,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              cityName,
              style:  const TextStyle(
                color:  Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: onSearchTap,
          tooltip: 'Search',
        ),
        IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_outline,
            color: Colors.white,
          ),
          onPressed: () {
            if (isFavorite) {
              ref.read(favoritesProvider.notifier).removeCity(cityName);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content:  Text('Removed from favorites')),
              );
            } else {
              ref.read(favoritesProvider. notifier).addCity(cityName);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Added to favorites')),
              );
            }
          },
          tooltip: isFavorite ? 'Remove from Favorites' : 'Add to Favorites',
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size. fromHeight(kToolbarHeight);
}