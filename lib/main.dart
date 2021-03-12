import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Weather App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _locality = '';
  String _weather = '';
  String _temperature = '';

  Future<Position> getPosition() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return position;
  }

  Future<Placemark> getPlacemark(double latitude, double longitude) async {
    List<Placemark> placemark =
        await Geolocator().placemarkFromCoordinates(latitude, longitude);
    return placemark[0];
  }

  Future<Map> getData(double latitude, double longitude) async {
    String api = 'https://api.openweathermap.org/data/2.5/weather';
    String appId = '2821804b34845c15cfed4c89380564c7';

    String url = '$api?lat=$latitude&lon=$longitude&units=metric&APPID=$appId';

    http.Response response = await http.get(url);

    Map parsed = json.decode(response.body);

    return parsed;
  }

  @override
  void initState() {
    super.initState();
    getPosition().then((position) {
      getPlacemark(position.latitude, position.longitude).then((data) {
        getData(position.latitude, position.longitude).then((weather) {
          setState(() {
            _locality = data.locality;
            _weather = weather['weather'][0]['description'];
            _temperature = weather['main']['temp'].toString();

          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Weather App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_locality',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '$_temperature',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text(
              '$_weather',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
