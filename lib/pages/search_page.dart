import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: ListView(
        children: <Widget>[
          _buildUpperBar(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('Search for a hero!'),
      elevation: 0,
    );
  }

  Widget _buildUpperBar() {
    return Stack(
      children: <Widget>[
        Positioned(
          child: Container(
            color: Colors.blue,
            width: double.infinity,
            height: 100,
          ),
        ),
        Positioned(
          bottom: 8,
          left: 10,
          right: 10,
          child: Material(
            elevation: 10,
            color: Colors.amber,
            child: TextField(
              decoration: InputDecoration(
                  labelText: 'Search',
                  labelStyle: TextStyle(color: Colors.black),
                  prefix: Icon(Icons.search, color: Colors.blue)),
            ),
          ),
        ),
      ],
    );
  }
}
