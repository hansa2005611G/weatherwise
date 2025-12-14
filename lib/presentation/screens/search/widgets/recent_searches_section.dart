import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/search_provider.dart';

class RecentSearchesSection extends ConsumerWidget {
  final ValueChanged<String> onCityTap;

  const RecentSearchesSection({
    super.key,
    required this.onCityTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchProvider);
    final recentSearches = searchState.recentSearches;

    if (recentSearches.isEmpty) {
      return const SizedBox. shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:  [
              const Text(
                'Recent Searches',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  _showClearDialog(context, ref);
                },
                child: const Text('Clear All'),
              ),
            ],
          ),
        ),
        const SizedBox(height:  8),
        ListView.builder(
          shrinkWrap: true,
          physics:  const NeverScrollableScrollPhysics(),
          itemCount: recentSearches.length,
          itemBuilder: (context, index) {
            final city = recentSearches[index];
            return Dismissible(
              key: Key(city),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              onDismissed: (direction) {
                ref.read(searchProvider.notifier).removeFromRecentSearches(city);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$city removed'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: ListTile(
                leading: const Icon(Icons.history),
                title: Text(city),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () {
                    ref.read(searchProvider.notifier).removeFromRecentSearches(city);
                  },
                ),
                onTap: () => onCityTap(city),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showClearDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder:  (context) => AlertDialog(
        title: const Text('Clear Recent Searches'),
        content: const Text('Are you sure you want to clear all recent searches?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(searchProvider.notifier).clearRecentSearches();
              Navigator.pop(context);
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: Colors. red),
            ),
          ),
        ],
      ),
    );
  }
}