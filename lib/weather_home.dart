import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'weather-data.dart';


var apiUrl; //api url

//Weather Data
Future<WeatherData> fetchWeatherData() async {
  final response = await http.get(apiUrl);

  if (response.statusCode == 200) {
    return WeatherData.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load data');
  }
}

class WeatherHome extends StatefulWidget {
  @override
  _WeatherHomeState createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  Map<String, double> _currentLocation;
  Location _location = new Location();

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future getLocation() async {
    try {
      var _getLocation = await _location.getLocation().then((result) {
        setState(() {
          _currentLocation = result;
          print(_currentLocation);
          print(_currentLocation["latitude"]);
          print(_currentLocation["longitude"]);

          getAPI();
        });
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future getAPI() async {
    apiUrl = "https://fcc-weather-api.glitch.me/api/current?lat=" +
        _currentLocation["latitude"].toString() +
        "&lon=" +
        _currentLocation["longitude"].toString();
    print(apiUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: FutureBuilder<WeatherData>(
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
          }

          return snapshot.hasData
              ? _buildBody(snapshot.data)
              : Center(
            child: CircularProgressIndicator(
              backgroundColor: const Color(0xFF343434),
            ),
          );
        },
        future: fetchWeatherData(),
      ),
    );
  }

  Widget _buildBody(WeatherData weatherDataSnapshot) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
              child: Center(
                child: _currentWeatherData(weatherDataSnapshot),
              )),
          Expanded(child: Center(child: _moreDetails(weatherDataSnapshot))),
        ],
      ),
    );
  }

  Widget _currentWeatherData(WeatherData weatherDataSnapshot) {
    print("Location name : " + weatherDataSnapshot.locationName);
    print("weather condition : " + weatherDataSnapshot.weather[0]['main']);
    print("weather condition desc : " +
        weatherDataSnapshot.weather[0]['description']);
    print("weather Temp : " + weatherDataSnapshot.main['temp'].toString());
    print("weather humidity : " +
        weatherDataSnapshot.main['humidity'].toString());
    print("weather temp_min : " +
        weatherDataSnapshot.main['temp_min'].toString());
    print("weather temp_max : " +
        weatherDataSnapshot.main['temp_max'].toString());
    print("weather temp_max : " +
        weatherDataSnapshot.main['temp_max'].toString());
    print("wind speed : " + weatherDataSnapshot.wind['speed'].toString());

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Text(
            weatherDataSnapshot.locationName,
            style: Theme.of(context).textTheme.display2,
          ),
          flex: 1,
        ),
        Expanded(
          child: Text(weatherDataSnapshot.weather[0]['main'],
              style: Theme.of(context).textTheme.display1),
          flex: 1,
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  child: Center(
                    child: weatherDataSnapshot.weather[0]['icon'] == null ? null : Image.network(weatherDataSnapshot.weather[0]['icon']),
                  )),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "${weatherDataSnapshot.main['temp']}° C",
                      style: Theme.of(context).textTheme.display2,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      weatherDataSnapshot.weather[0]['description'],
                      style: Theme.of(context).textTheme.title,
                    )
                  ],
                ),
              )
            ],
          ),
          flex: 2,
        )
      ],
    );
  }

  Widget _moreDetails(WeatherData weatherDataSnapshot) {
    return Column(
      children: <Widget>[
        Divider(
          height: 0.0,
          color: const Color(0xFF343434),
        ),
        Expanded(
          flex: 10,
          child: Row(
            children: <Widget>[
              _extraData(
                  name: "Min. temp.",
                  value: "${weatherDataSnapshot.main['temp_min']}"),
              _extraData(
                  name: "Max. temp.",
                  value: "${weatherDataSnapshot.main['temp_max']}"),
            ],
          ),
        ),
        Expanded(
          flex: 9,
          child: Row(
            children: <Widget>[
              _extraData(
                  name: "Humidity",
                  value: "${weatherDataSnapshot.main['humidity']}%"),
              _extraData(
                  name: "Wind Speed",
                  value: "${weatherDataSnapshot.wind['speed']} km/h"),
            ],
          ),
        )
      ],
    );
  }

  Widget _extraData({String name, String value}) {
    return Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  value,
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  name,
                  style: Theme.of(context).textTheme.subhead,
                ),
                Center(
                  child: SizedBox(
                    height: 8.0,
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
