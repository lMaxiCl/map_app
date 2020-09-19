import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';

import 'dart:async';
import 'dart:convert';

import 'CountryView.dart';

//Fetching data part
//Getting data from API as List
//TODO: add posibility to search by region
Future<List<Country>> fetchCountries(http.Client client, _region) async {
  final response =
      await client.get('https://restcountries.eu/rest/v2/region/$_region');

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

//Home page of app where is all
class ListOfCountries extends StatefulWidget {
  final String _region;

  ListOfCountries(this._region);

  @override
  _ListOfCountries createState() => _ListOfCountries(_region);
}

//state of Home Page. Here lives almost a half of app.
class _ListOfCountries extends State<ListOfCountries> {
  Future<List<Country>> futureCountry;

  final String _region;

  _ListOfCountries(this._region);

  @override
  void initState() {
    super.initState();
    futureCountry = fetchCountries(http.Client(), _region);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Region: $_region')),
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
                              onPressed: () => setState(() {
                                futureCountry =
                                    fetchCountries(http.Client(), _region);
                              }),
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

//Item of list on List of countries
class ListItem extends StatelessWidget {
  final _country;

  ListItem(this._country);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(5),
        color: Colors.cyan,
        child: FlatButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => (CountryView(_country))));
          },
          child: Column(children: [
            Text('Name: ' '${_country.name}'),
            Text('Alpha2code: ' '${_country.alpha2Code}'),
            Text('Subregion: ' '${_country.subregion}'),
            SvgPicture.network(
              _country.flag,
              width: 20,
              height: 20,
              fit: BoxFit.fill,
            )
          ]),
        ));
  }
}
