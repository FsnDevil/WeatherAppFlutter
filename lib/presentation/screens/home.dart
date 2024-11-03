import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/bloc/weather_bloc.dart';
import 'package:weather_app/presentation/widgets/homecmp.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WeatherBloc>().add(WeatherFetched());
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
          IconButton(
              onPressed: () {
                context.read<WeatherBloc>().add(WeatherFetched());
              },
              icon: const Icon(Icons.refresh)),
        ],
      ),
      body: BlocConsumer<WeatherBloc, WeatherState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is WeatherFailure) {
            return Center(child: Text(state.error));
          }

          if (state is WeatherLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (state is WeatherSuccess) {
            final weatherResponse = state.weatherResponse;
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MainCard(
                      tempData: "${weatherResponse.weatherList[0].main.temp} K",
                      skyData: weatherResponse
                          .weatherList[0].weatherDetails[0].main),
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
                        itemCount: weatherResponse.weatherList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final time = DateTime.parse(weatherResponse
                              .weatherList[index + 1].dtTxt
                              .toString());
                          return ForecastHourlyItem(
                            icon: weatherResponse.weatherList[index]
                                            .weatherDetails[0].main ==
                                        "Clouds" ||
                                    weatherResponse.weatherList[index + 1]
                                            .weatherDetails[0].main ==
                                        "Rain"
                                ? Icons.cloud
                                : Icons.sunny,
                            timeValue: DateFormat.Hm().format(time),
                            kelvinValue: weatherResponse
                                .weatherList[index].main.temp
                                .toString(),
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
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          AdditionalInfoItem(
                            icon: Icons.water_drop,
                            weatherValueString: "Humidity",
                            intValue:
                                "${weatherResponse.weatherList[0].main.humidity}",
                          ),
                          AdditionalInfoItem(
                            icon: Icons.wind_power,
                            weatherValueString: "Wind Speed",
                            intValue:
                                "${weatherResponse.weatherList[0].wind.speed}",
                          ),
                          AdditionalInfoItem(
                            icon: Icons.beach_access,
                            weatherValueString: "Pressure",
                            intValue:
                                "${weatherResponse.weatherList[0].main.pressure}",
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
