import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:weather/models/weather.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final TextEditingController searchController;
  late String city;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: "Nashik");
    city = searchController.text;
  }

  String getImgUrl(String type) {
    switch (type) {
      case "Clouds":
        return "https://images.unsplash.com/photo-1515694346937-94d85e41e6f0?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cmFpbnxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&w=1000&q=80";

      default:
        return "https://images.unsplash.com/photo-1515694346937-94d85e41e6f0?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cmFpbnxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&w=1000&q=80";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder<Response<Map<String, dynamic>>>(
        future: Dio().get(
            "https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=574debf51a2251ada146f3fdbc76afde"),
        builder: (context, snap) {
          if (snap.hasError) {
            return Center(
              child: Dialog(
                // shape: CircleBorder(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 20, 5, 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        ((snap.error as DioError).response?.data['message'] ??
                                "Error")
                            .toString()
                            .toUpperCase(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            city = "Nashik";
                          });
                        },
                        child: Text(
                          "Reset",
                          style: TextStyle(color: Colors.amber),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          if (!snap.hasData) return Center(child: CircularProgressIndicator());

          Weather weather = Weather.fromMap(snap.data!.data!);

          return SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    getImgUrl(weather.weather?[0].main ?? ""),
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration:
                        BoxDecoration(color: Colors.black.withOpacity(0.2)),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      margin:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(30)),
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                city = searchController.text;
                              });
                            },
                            child: Icon(Icons.search),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                              child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                                hintText: "Search City",
                                border: InputBorder.none),
                          )),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20)),
                            margin: EdgeInsets.symmetric(horizontal: 25),
                            child: Row(
                              children: <Widget>[
                                Image.network(
                                    "http://openweathermap.org/img/wn/${weather.weather?[0].icon}@2x.png"),
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30),
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  (weather.name ?? "City Name"),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30),
                                      child: Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: (weather.weather?[0]
                                                      .description ??
                                                  "Weather"),
                                              style: TextStyle(
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20)),
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 30),
                                  child: Row(
                                    children: [
                                      Icon(WeatherIcons.thermometer),
                                      SizedBox(
                                        width: 90,
                                      ),
                                      Text(
                                        "Temprature",
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: (weather.main?.temp
                                                    ?.round()
                                                    .toString() ??
                                                "Temp"),
                                            style: TextStyle(fontSize: 50),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      WeatherIcons.celsius,
                                      size: 30,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Sunrise",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Spacer(),
                                    Text(
                                      "Sunset",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: DateFormat.jm().format(
                                                DateTime
                                                    .fromMillisecondsSinceEpoch(
                                              Duration(
                                                      seconds: weather
                                                              .sys?.sunrise ??
                                                          0)
                                                  .inMilliseconds,
                                              isUtc: true,
                                            ).toLocal()),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: DateFormat.jm().format(
                                                DateTime
                                                    .fromMillisecondsSinceEpoch(
                                              Duration(
                                                      seconds:
                                                          weather.sys?.sunset ??
                                                              0)
                                                  .inMilliseconds,
                                              isUtc: true,
                                            ).toLocal()),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20)),
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(left: 24, right: 8),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(WeatherIcons.day_windy),
                                    SizedBox(width: 20),
                                    Text("WindSpeed"),
                                  ],
                                ),
                                SizedBox(
                                  height: 45,
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: ((weather.wind?.speed ?? 0.0)
                                            .toStringAsFixed(2)),
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Text("m/s")
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20)),
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(left: 8, right: 24),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(WeatherIcons.humidity),
                                    SizedBox(width: 20),
                                    Text("Humidity"),
                                  ],
                                ),
                                SizedBox(
                                  height: 45,
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: (weather.main?.humidity
                                                .toString() ??
                                            "Humidity"),
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  "Percent",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Chip(
                      backgroundColor: Colors.white.withOpacity(0.1),
                      label: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Created by ",
                            ),
                            TextSpan(
                              text: "Aniket Kale ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: "with ",
                            ),
                            WidgetSpan(
                              child: FlutterLogo(
                                size: 15,
                              ),
                            )
                          ],
                        ),
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
