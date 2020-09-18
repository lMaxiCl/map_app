import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

//Item of list on home screen
class ListItem extends StatelessWidget {
  final _Country;

  ListItem(this._Country);

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
                    builder: (context) => (CountryView(_Country))));
          },
          child: Column(children: [
            Text('Name: ' '${_Country.name}'),
            Text('Alpha2code: ' '${_Country.alpha2Code}'),
            Text('Subregion: ' '${_Country.subregion}'),
            SvgPicture.network(
              _Country.flag,
              width: 20,
              height: 20,
              fit: BoxFit.fill,
            )
          ]),
        ));
  }
}

//View of country, showed when you press on List item
class CountryView extends StatelessWidget {
  final _Country;

  CountryView(this._Country);

  @override
  Widget build(BuildContext context) {
    //TODO: Make this thing more pretty
    return Scaffold(
      appBar: AppBar(
        title: Text('${_Country.name}'),
      ),
      body: Center(
        child: Column(children: [
          Container(
            child:
                MapView(_Country.latlng[0], _Country.latlng[1], _Country.name),
            height: MediaQuery.of(context).size.height * 0.5,
          ),
          Text('Numeric Code: '),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _Country.numericCode
                  .map<Widget>((item) => Text(item))
                  .toList()),
          Text('Borders: '),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
                  _Country.borders.map<Widget>((item) => Text(item)).toList()),
          Text('Currencies: '),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _Country.currencies
                  .map<Widget>((item) => Text(item['name']))
                  .toList())
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
