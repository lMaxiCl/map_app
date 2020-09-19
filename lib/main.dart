import 'package:flutter/material.dart';
import 'package:map_app/ListOfRegions.dart';

void main() {
  runApp(MyApp());
}

//Insertion point of App
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MapApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ListOfRegions(),
    );
  }
}

