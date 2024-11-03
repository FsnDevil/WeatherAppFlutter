import 'dart:convert';

import 'package:weather_app/data/dataprovider/weather_data_provider.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherRepository {
  final WeatherDataProvider weatherDataProvider;

  WeatherRepository({required this.weatherDataProvider});

  Future<WeatherResponse> getCurrentForecastForMainScreen(
      String cityName) async {
    try {
      String weatherStringData =
          await weatherDataProvider.getCurrentForecastForMainScreen(cityName);
      final jsonData = jsonDecode(weatherStringData);

      // Check if response code is not "200" and throw an error if so.
      if (jsonData["cod"] != "200") {
        throw "Unexpected Error Found..";
      }

      // Parse JSON data to WeatherResponse object.
      return WeatherResponse.fromJson(jsonData);
    } catch (e) {
      throw Exception("Failed to load weather data: ${e.toString()}");
    }
  }
}
