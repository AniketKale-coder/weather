import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:weather/models/weather.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Response<Map<String, dynamic>>>(
        future: Dio().get(
            "https://api.openweathermap.org/data/2.5/weather?q=Nashik&appid=574debf51a2251ada146f3fdbc76afde"),
        builder: (context, snap) {
          if (snap.hasError)
            return Center(
              child: Text(snap.error.toString()),
            );
          if (!snap.hasData) return Center(child: CircularProgressIndicator());

          Weather weather = Weather.fromMap(snap.data!.data!);

          return ListView(
            children: [
              ListTile(
                title: Text(
                  weather.name ?? "CityName",
                ),
                subtitle: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: (weather.sys?.country ?? "Country") + " (",
                      ),
                      TextSpan(
                        text:
                            (weather.coord?.lat.toString() ?? "Lat") + " Lat, ",
                      ),
                      TextSpan(
                        text:
                            (weather.coord?.lon.toString() ?? "Lon") + " Lon)",
                      ),
                    ],
                  ),
                ),
                leading: CircleAvatar(
                  child: Icon(Icons.location_city_rounded),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
