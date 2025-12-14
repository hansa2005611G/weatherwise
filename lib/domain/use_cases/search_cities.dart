import '../repositories/weather_repository.dart';

class SearchCities {
  final WeatherRepository repository;

  SearchCities(this.repository);

  Future<List<Map<String, dynamic>>> execute(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }
    return await repository.searchCities(query);
  }
}