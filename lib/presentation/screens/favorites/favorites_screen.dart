import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../providers/favorites_provider.dart';
import '../../providers/weather_provider.dart';
import 'widgets/favorite_city_card.dart';
import 'widgets/favorite_city_list_item.dart';
import 'widgets/empty_favorites_widget.dart';
import 'widgets/add_favorite_dialog.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh weather data when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(favoritesProvider.notifier).refreshWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoritesState = ref.watch(favoritesProvider);
    final cities = favoritesState.cities;
    final viewMode = favoritesState.viewMode;

    return Scaffold(
      appBar:  AppBar(
        title: const Text('Favorite Cities'),
        leading: IconButton(
          icon:  const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (cities.isNotEmpty)
            IconButton(
              icon: Icon(
                viewMode == ViewMode.grid
                    ? Icons.list
                    : Icons.grid_view,
              ),
              onPressed: () {
                ref.read(favoritesProvider. notifier).toggleViewMode();
              },
              tooltip: viewMode == ViewMode.grid ? 'List View' : 'Grid View',
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(favoritesProvider.notifier).refreshWeather();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Refreshing weather data...'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: cities.isEmpty
          ? const EmptyFavoritesWidget()
          : _buildFavoritesList(cities, viewMode),
      floatingActionButton: FadeInUp(
        duration: const Duration(milliseconds: 500),
        child: FloatingActionButton. extended(
          onPressed: () => _showAddCityDialog(context),
          icon: const Icon(Icons.add),
          label: const Text('Add City'),
        ),
      ),
    );
  }

  Widget _buildFavoritesList(List<FavoriteCityData> cities, ViewMode viewMode) {
    if (viewMode == ViewMode.grid) {
      return RefreshIndicator(
        onRefresh: () async {
          await ref.read(favoritesProvider.notifier).refreshWeather();
        },
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio:  0.85,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: cities.length,
          itemBuilder: (context, index) {
            return FadeInUp(
              duration: const Duration(milliseconds: 400),
              delay: Duration(milliseconds: index * 50),
              child: FavoriteCityCard(
                cityData: cities[index],
                onTap: () => _onCityTap(cities[index].cityName),
                onDelete: () => _onDeleteCity(cities[index].cityName),
                onEdit: () => _onEditCity(cities[index].cityName),
              ),
            );
          },
        ),
      );
    } else {
      return RefreshIndicator(
        onRefresh: () async {
          await ref.read(favoritesProvider.notifier).refreshWeather();
        },
        child: ReorderableListView.builder(
          padding: const EdgeInsets. all(16),
          physics:  const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          itemCount: cities.length,
          onReorder: (oldIndex, newIndex) {
            ref.read(favoritesProvider.notifier).reorderCities(oldIndex, newIndex);
          },
          itemBuilder: (context, index) {
            return FadeInUp(
              key: Key(cities[index].cityName),
              duration: const Duration(milliseconds: 400),
              delay: Duration(milliseconds: index * 50),
              child: FavoriteCityListItem(
                cityData: cities[index],
                onTap: () => _onCityTap(cities[index].cityName),
                onDelete: () => _onDeleteCity(cities[index].cityName),
                onEdit: () => _onEditCity(cities[index].cityName),
              ),
            );
          },
        ),
      );
    }
  }

  Future<void> _onCityTap(String cityName) async {
    // Fetch weather for selected city
    await ref.read(weatherProvider.notifier).fetchWeatherByCity(cityName);
    await ref.read(weatherProvider.notifier).fetchForecast(cityName);

    // Navigate back to home
    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _onDeleteCity(String cityName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove City'),
        content: Text('Remove $cityName from favorites?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(favoritesProvider. notifier).removeCity(cityName);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$cityName removed'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed:  () {
                      ref.read(favoritesProvider.notifier).addCity(cityName);
                    },
                  ),
                ),
              );
            },
            child: const Text(
              'Remove',
              style: TextStyle(color: Colors. red),
            ),
          ),
        ],
      ),
    );
  }

  void _onEditCity(String cityName) {
    final controller = TextEditingController(text: cityName);

    showDialog(
      context:  context,
      builder: (context) => AlertDialog(
        title: const Text('Edit City Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'City Name',
            hintText: 'Enter new name',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName. isNotEmpty && newName != cityName) {
                ref.read(favoritesProvider.notifier).updateCityNickname(
                      cityName,
                      newName,
                    );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('City name updated')),
                );
              } else {
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddCityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddFavoriteDialog(
        onAdd: (cityName) {
          ref.read(favoritesProvider.notifier).addCity(cityName);
        },
      ),
    );
  }
}