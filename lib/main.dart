import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'listItem.dart';

void main() {
  runApp(MyApp());
}

//Fetching data part
//Getting data from API as List
Future<List<Country>> fetchCountries(http.Client client) async {
  final response =
      await client.get('https://restcountries.eu/rest/v2/region/europe');

  return parseCountries(response.body);
}

//This function making from each item in List object of Country class
List<Country> parseCountries(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Country>((json) => Country.fromJson(json)).toList();
}

//Defining Country class
class Country {
  final String name;
  final String alpha2Code;
  final String subregion;
  final String flag;
  final List latlng;
  final List numericCode;
  final List borders;
  final List currencies;

  Country(
      {this.name,
      this.alpha2Code,
      this.subregion,
      this.flag,
      this.latlng,
      this.borders,
      this.currencies,
      this.numericCode});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'],
      alpha2Code: json['alpha2Code'],
      subregion: json['subregion'],
      flag: json['flag'],
      latlng: json['latlng'],
      borders: json['borders'],
      currencies: json['currencies'],
      numericCode: json['callingCodes'],
    );
  }
}

//Insertion point of App
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

//Home page of app where is all
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

//state of Home Page. Here lives almost a half of app.
class _MyHomePageState extends State<MyHomePage> {
  Future<List<Country>> futureCountry;

  @override
  void initState() {
    super.initState();
    futureCountry = fetchCountries(http.Client());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('MapApp   ; - )')),
      body: Center(
          child: FutureBuilder<List<Country>>(
              //Building future from request
              future: futureCountry,
              builder: (context, snapshot) {
                return snapshot.hasError
                    ? Container(
                        //If there is an error in fetch...
                        child: Column(
                          children: [
                            //I show this text and button that refreshes request
                            Text('Something wrong, try again!'),
                            RaisedButton(
                              child: Text('Refresh!'),
                              onPressed: initState,
                            )
                          ],
                        ),
                      )
                    : snapshot.hasData
                        ? //If there is data in snapshot App builds List
                        ListView(
                            children:
                                snapshot.data.map((e) => ListItem(e)).toList(),
                          )
                        : Center(child: CircularProgressIndicator());
              })),
    );
  }
}
