import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/weather_bloc.dart';
import 'package:weather_app/data/repositories/weather_repositories.dart';
import 'package:weather_app/presentation/screens/home.dart';

import 'data/dataprovider/weather_data_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) =>
          WeatherRepository(weatherDataProvider: WeatherDataProvider()),
      child: BlocProvider(
        create: (context) => WeatherBloc(context.read<WeatherRepository>()),
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.dark(
              useMaterial3: true,
            ),
            home: const HomeScreen()),
      ),
    );
  }
}
