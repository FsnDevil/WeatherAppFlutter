import 'package:http/http.dart' as http;

import '../../secrets.dart';

class WeatherDataProvider{
  Future<String> getCurrentForecastForMainScreen(String cityName) async {
    try {
      var result = await http.get(Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$weatherApiKey"));
      return result.body;
    } catch (e) {
      throw e.toString();
    }
  }
}