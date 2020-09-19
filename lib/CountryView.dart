import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';



//View of country, showed when you press on List item
class CountryView extends StatelessWidget {
  final _country;

  CountryView(this._country);

  @override
  Widget build(BuildContext context) {
    //TODO: Make this thing more pretty
    return Scaffold(
      appBar: AppBar(
        title: Text('${_country.name}'),
      ),
      body: Center(
        child: Column(children: [
          Container(
            child:
                MapView(_country.latlng[0], _country.latlng[1], _country.name),
            height: MediaQuery.of(context).size.height * 0.5,
          ),
          Column(
            children: [
              Text('Numeric Code: '),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _country.numericCode
                      .map<Widget>((item) => Text(item))
                      .toList()),
            ],
          ),
          Column(
            children: [
              Text('Borders: '),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _country.borders
                      .map<Widget>((item) => Text(item))
                      .toList()),
            ],
          ),
          Column(children: [
            Text('Currencies: '),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _country.currencies
                    .map<Widget>((item) => Text(item['name']))
                    .toList())
          ])
        ]),
      ),
    );
  }
}

// This is the thing that shows map
class MapView extends StatelessWidget {
  final double lat;
  final double lng;
  final String name;

  MapView(this.lat, this.lng, this.name);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
        options: MapOptions(
          center: LatLng(lat, lng),
          zoom: 6.0,
        ),
        layers: [
          TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']),
          // Maybe its a good idea to show name of country on map
          // But Im not sure...
          MarkerLayerOptions(markers: [
            Marker(
                width: 120,
                height: 120,
                point: LatLng(lat, lng),
                builder: (ctx) => Text(
                      name,
                      style: TextStyle(fontSize: 30),
                    ))
          ])
        ]);
  }
}
