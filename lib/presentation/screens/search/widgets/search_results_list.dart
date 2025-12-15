import 'package:flutter/material.dart';
import '../../../providers/search_provider.dart';

class SearchResultsList extends StatelessWidget {
  final List<CitySearchResult> results;
  final ValueChanged<String> onCitySelected;

  const SearchResultsList({
    super.key,
    required this.results,
    required this.onCitySelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: results.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final result = results[index];
        return _buildResultItem(context, result);
      },
    );
  }

  Widget _buildResultItem(BuildContext context, CitySearchResult result) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets. all(12),
        decoration:  BoxDecoration(
          // ignore: deprecated_member_use
          color:  Theme.of(context).primaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.location_city,
          color: Theme.of(context).primaryColor,
          size: 24,
        ),
      ),
      title: Text(
        result.name,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        result.state != null
            ? '${result. state}, ${result.country}'
            :  result.country,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => onCitySelected(result.name),
    );
  }
}