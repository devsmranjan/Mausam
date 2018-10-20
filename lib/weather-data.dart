class WeatherData {
  final String locationName;
  final List weather;
  final main;
  final wind;

  WeatherData({this.locationName, this.weather, this.main, this.wind});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      locationName: json['name'],
      weather: json['weather'],
      main: json['main'],
      wind: json['wind'],
    );
  }
}