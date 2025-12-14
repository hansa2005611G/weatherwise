import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../providers/search_provider.dart';
import '../../providers/weather_provider.dart';
import '../../providers/favorites_provider.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/recent_searches_section.dart';
import 'widgets/popular_cities_section.dart';
import 'widgets/search_results_list.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto-focus search bar when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode. dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // Debounce search - only search after user stops typing
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_searchController.text == query) {
        ref.read(searchProvider.notifier).searchCities(query);
      }
    });
  }

  void _onClearSearch() {
    _searchController.clear();
    ref.read(searchProvider.notifier).clearSearch();
    _searchFocusNode.requestFocus();
  }

  Future<void> _onCitySelected(String cityName) async {
    // Add to recent searches
    await ref.read(searchProvider.notifier).addToRecentSearches(cityName);

    // Fetch weather for selected city
    await ref.read(weatherProvider.notifier).fetchWeatherByCity(cityName);
    await ref.read(weatherProvider.notifier).fetchForecast(cityName);

    // Navigate back to home
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final hasQuery = searchState.query.isNotEmpty;
    final hasResults = searchState.results.isNotEmpty;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon:  const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Search Location'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            FadeInDown(
              duration: const Duration(milliseconds: 400),
              child:  Padding(
                padding: const EdgeInsets.all(16.0),
                child: SearchBarWidget(
                  controller:  _searchController,
                  focusNode: _searchFocusNode,
                  onChanged:  _onSearchChanged,
                  onClear: _onClearSearch,
                ),
              ),
            ),

            // Use Current Location Button
            FadeInDown(
              duration: const Duration(milliseconds: 400),
              delay: const Duration(milliseconds: 100),
              child:  Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _buildCurrentLocationButton(),
              ),
            ),

            const SizedBox(height: 16),

            // Main Content
            Expanded(
              child: hasQuery
                  ? _buildSearchResults(searchState, hasResults)
                  : _buildDefaultContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentLocationButton() {
    return InkWell(
      onTap: () => _useCurrentLocation(),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius. circular(12),
          border: Border.all(
            color: Theme.of(context).primaryColor. withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.my_location,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width:  16),
            const Expanded(
              child: Text(
                'Use Current Location',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(SearchState searchState, bool hasResults) {
    if (searchState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (searchState.error != null) {
      return Center(
        child:  Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.search_off,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                searchState.error! ,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    if (!hasResults) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_off,
                size: 64,
                color: Colors. grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No cities found',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors. grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Try searching with a different name',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return FadeInUp(
      duration: const Duration(milliseconds: 400),
      child: SearchResultsList(
        results: searchState.results,
        onCitySelected: _onCitySelected,
      ),
    );
  }

  Widget _buildDefaultContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          // Recent Searches Section
          FadeInUp(
            duration:  const Duration(milliseconds: 400),
            delay: const Duration(milliseconds: 200),
            child: RecentSearchesSection(
              onCityTap: _onCitySelected,
            ),
          ),

          const SizedBox(height: 24),

          // Popular Cities Section
          FadeInUp(
            duration: const Duration(milliseconds:  400),
            delay: const Duration(milliseconds: 300),
            child: PopularCitiesSection(
              onCityTap: _onCitySelected,
            ),
          ),

          const SizedBox(height:  24),
        ],
      ),
    );
  }

  Future<void> _useCurrentLocation() async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child:  Card(
          child: Padding(
            padding: EdgeInsets. all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Getting your location... '),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      // TODO: Implement actual location fetching with geolocator
      // For now, we'll use a default location
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        Navigator. pop(context); // Close loading dialog
        
        // Show message
        ScaffoldMessenger. of(context).showSnackBar(
          const SnackBar(
            content: Text('Location feature coming soon!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to get location: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}