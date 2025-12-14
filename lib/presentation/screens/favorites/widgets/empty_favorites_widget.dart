import 'package:flutter/material.dart';

class EmptyFavoritesWidget extends StatelessWidget {
  const EmptyFavoritesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child:  Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty state illustration
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor. withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child:  Icon(
                Icons.favorite_border,
                size: 80,
                color: Theme.of(context).primaryColor,
              ),
            ),

            const SizedBox(height:  32),

            // Title
            Text(
              'No Favorite Cities',
              style: Theme. of(context).textTheme.headlineSmall?. copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              'Add cities to your favorites to quickly check their weather',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Add button
            ElevatedButton. icon(
              onPressed: () {
                // The FAB will handle this
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Your First City'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}