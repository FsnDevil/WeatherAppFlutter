import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/components/homecmp.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late Future<Map<String,dynamic>> weather;

  @override
  void initState() {
    super.initState();
    weather=getCurrentForecastForMainScreen();
  }

  Future<Map<String,dynamic>> getCurrentForecastForMainScreen() async {
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
          IconButton(onPressed: () {setState(() {
            weather=getCurrentForecastForMainScreen();
          });}, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: FutureBuilder(
          future: weather,
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
            final weatherData=forecastData["list"][0];
            final tempData=weatherData["main"]["temp"];
            final skyData=weatherData["weather"][0]["main"];

            final humidityData=forecastData["list"][1]["main"]["humidity"];
            final pressureData=forecastData["list"][1]["main"]["pressure"];
            final windSpeed=forecastData["list"][1]["wind"]["speed"];


            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MainCard(tempData: "$tempData K",skyData:"$skyData"),
                  const SizedBox(height: 15),
                  const Text(
                    "Weather Forecast",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        fontFamily: "suse"),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                        itemCount: 30,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context,index){
                          final time = DateTime.parse(forecastData["list"][index+1]["dt_txt"].toString());
                          return ForecastHourlyItem(
                            icon: forecastData["list"][index+1]["weather"][0]["main"]=="Clouds" || forecastData["list"][index+1]["weather"][0]["main"]=="Rain"?Icons.cloud:Icons.sunny,
                            timeValue: DateFormat.Hm().format(time),
                            kelvinValue: forecastData["list"][index+1]["main"]["temp"].toString(),
                          );
                        }),
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
                   Container(width: double.infinity,alignment: Alignment.center,
                   child: SingleChildScrollView(
                     scrollDirection: Axis.horizontal,
                     child: Row(
                       children: [
                         AdditionalInfoItem(
                           icon: Icons.water_drop,
                           weatherValueString: "Humidity",
                           intValue: "$humidityData",
                         ),
                         AdditionalInfoItem(
                           icon: Icons.wind_power,
                           weatherValueString: "Wind Speed",
                           intValue: "$windSpeed",
                         ),
                         AdditionalInfoItem(
                           icon: Icons.beach_access,
                           weatherValueString: "Pressure",
                           intValue: "$pressureData",
                         ),
                       ],
                     ),
                   ),),
                ],
              ),
            );
          }),
    );
  }
}
