import 'package:flutter/material.dart';
import 'weather_home.dart';

void main() => runApp(WeatherApp());

class WeatherApp extends StatelessWidget {
  final _textColor = const Color(0xFF343434);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.yellow[300],
          fontFamily: 'Questrial',
          textTheme: TextTheme(
            body1: TextStyle(color: _textColor, letterSpacing: 1.5),
            display1: TextStyle(color: _textColor)
                .copyWith(fontSize: 28.0, letterSpacing: 1.5),
            display2: TextStyle(color: _textColor)
                .copyWith(fontSize: 36.0, letterSpacing: 1.5),
            title: TextStyle(
                color: _textColor,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600),
            subhead: TextStyle(
                color: _textColor,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w600),
          )),
      home: WeatherHome(),
    );
  }
}



