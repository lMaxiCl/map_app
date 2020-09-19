import 'package:flutter/material.dart';
import 'package:map_app/ListOfCountries.dart';

//Just list of 5 regions to make this app work with all countries
class ListOfRegions extends StatelessWidget {
  final List regions = ['Africa', 'Americas', 'Asia', 'Europe', 'Oceania'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of regions'),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: regions
                .map<Widget>((e) => FlatButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListOfCountries(e)));
                      },
                      child: Container(
                          width: 250,
                          height: 50,
                          color: Colors.cyan,
                          child: Center(
                            child: Text(e),
                          )),
                    ))
                .toList()),
      ),
    );
  }
}
