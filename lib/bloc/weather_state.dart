part of 'weather_bloc.dart';

@immutable
sealed class WeatherState {}

final class WeatherInitial extends WeatherState {}

final class WeatherLoading extends WeatherState {}

final class WeatherSuccess extends WeatherState {
  final WeatherResponse weatherResponse;

  WeatherSuccess({required this.weatherResponse});
}

final class WeatherFailure extends WeatherState {
  final String error;

  WeatherFailure({required this.error});
}
