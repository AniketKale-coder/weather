import 'package:flutter/material.dart';
import 'package:weather/pages/home.dart';

void main() => runApp(
      MaterialApp(
        // debugShowCheckedModeBanner: false,
        routes: {
          "/": (context) => Home(),
        },
      ),
    );
