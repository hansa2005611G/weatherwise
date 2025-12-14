import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class PopularCitiesSection extends StatelessWidget {
  final ValueChanged<String> onCityTap;

  const PopularCitiesSection({
    super. key,
    required this.onCityTap,
  });

  // Popular cities with their emoji flags
  static const List<PopularCity> popularCities = [
    PopularCity(name: 'New York', country: 'USA', emoji: '🗽', flag: '🇺🇸'),
    PopularCity(name: 'London', country: 'UK', emoji: '🏰', flag: '🇬🇧'),
    PopularCity(name: 'Tokyo', country: 'Japan', emoji: '🗼', flag: '🇯🇵'),
    PopularCity(name: 'Paris', country: 'France', emoji:  '🗼', flag: '🇫🇷'),
    PopularCity(name: 'Dubai', country: 'UAE', emoji: '🏙️', flag: '🇦🇪'),
    PopularCity(name: 'Sydney', country: 'Australia', emoji: '🌊', flag: '🇦🇺'),
    PopularCity(name: 'Singapore', country: 'Singapore', emoji: '🏙️', flag: '🇸🇬'),
    PopularCity(name: 'Berlin', country: 'Germany', emoji: '🏛️', flag: '🇩🇪'),
    PopularCity(name: 'Toronto', country: 'Canada', emoji: '🍁', flag: '🇨🇦'),
    PopularCity(name: 'Mumbai', country: 'India', emoji: '🏙️', flag: '🇮🇳'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Popular Cities',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 12,
            mainAxisSpacing:  12,
          ),
          itemCount: popularCities.length,
          itemBuilder: (context, index) {
            final city = popularCities[index];
            return _buildCityCard(context, city);
          },
        ),
      ],
    );
  }

  Widget _buildCityCard(BuildContext context, PopularCity city) {
    return InkWell(
      onTap: () => onCityTap(city.name),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withOpacity(0.8),
              AppColors.primaryLight.withOpacity(0.6),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Flag emoji in background
            Positioned(
              right: -10,
              top: -10,
              child:  Opacity(
                opacity: 0.2,
                child: Text(
                  city.flag,
                  style: const TextStyle(fontSize: 80),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:  [
                  Row(
                    children: [
                      Text(
                        city.emoji,
                        style: const TextStyle(fontSize: 28),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white. withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment:  CrossAxisAlignment.start,
                    children: [
                      Text(
                        city.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        city.country,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors. white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Popular city model
class PopularCity {
  final String name;
  final String country;
  final String emoji;
  final String flag;

  const PopularCity({
    required this.name,
    required this. country,
    required this.emoji,
    required this.flag,
  });
}