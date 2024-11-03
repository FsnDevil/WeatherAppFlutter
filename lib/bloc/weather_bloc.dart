import 'package:weather_app/data/repositories/weather_repositories.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherBloc(this.weatherRepository) : super(WeatherInitial()) {
    on<WeatherFetched>(_weatherFetched);
  }

  void _weatherFetched(WeatherFetched event,Emitter<WeatherState> emit) async{
    emit(WeatherLoading());
    try{
      final weatherResponse = await weatherRepository.getCurrentForecastForMainScreen("Pune");
      emit(WeatherSuccess(weatherResponse: weatherResponse));
    }catch(e){
      emit(WeatherFailure(error: e.toString()));
    }
  }
}
