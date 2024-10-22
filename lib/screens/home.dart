import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weather_app/components/homecmp.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getCurrentForecastForMainCard();
  }

  Future<Map<String,dynamic>> getCurrentForecastForMainCard() async {
    String cityName = "Pune";
    try {
      var result = await http.get(Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$weatherApiKey"));

      var forecastData = jsonDecode(result.body);

      if(forecastData["cod"]!="200"){
        throw "Unexpected Error Found..";
      }

      return forecastData;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: FutureBuilder(
          future: getCurrentForecastForMainCard(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }

            final forecastData=snapshot.data!;
            final tempData=forecastData["list"][0]["main"]["temp"];

            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MainCard(tempData: "$tempData K"),
                  const SizedBox(height: 15),
                  const Text(
                    "Weather Forecast",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        fontFamily: "suse"),
                  ),
                  const SizedBox(height: 10),
                  const SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ForecastHourlyItem(
                          icon: Icons.cloud,
                          timeValue: "09:15",
                          kelvinValue: "300",
                        ),
                        ForecastHourlyItem(
                          icon: Icons.sunny,
                          timeValue: "10:15",
                          kelvinValue: "100",
                        ),
                        ForecastHourlyItem(
                          icon: Icons.water_sharp,
                          timeValue: "11:15",
                          kelvinValue: "250",
                        ),
                        ForecastHourlyItem(
                          icon: Icons.cloud,
                          timeValue: "12:15",
                          kelvinValue: "65",
                        ),
                        ForecastHourlyItem(
                          icon: Icons.sunny,
                          timeValue: "13:15",
                          kelvinValue: "97",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Addition Information",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        fontFamily: "suse"),
                  ),
                  const SizedBox(height: 8),
                  const SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        AdditionalInfoItem(
                          icon: Icons.water_drop,
                          weatherValueString: "Humidity",
                          intValue: "91",
                        ),
                        AdditionalInfoItem(
                          icon: Icons.wind_power,
                          weatherValueString: "Wind Speed",
                          intValue: "7.5",
                        ),
                        AdditionalInfoItem(
                          icon: Icons.beach_access,
                          weatherValueString: "Pressure",
                          intValue: "1000",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
