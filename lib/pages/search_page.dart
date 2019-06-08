import 'package:flutter/material.dart';
import 'package:social/MyClasses/static_content.dart';
import 'package:social/backend/my_db.dart';
import 'package:social/pages/view_profile.dart';

class SearchPageStatless extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SearchPage(),
      appBar: _buildAppBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('Search for a hero!'),
      elevation: 0,
    );
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String input;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        _buildUpperBar(),
        SearchResults(input: input),
      ],
    );
  }

  Widget _buildUpperBar() {
    return Stack(
      children: <Widget>[
        Positioned(
          child: Container(
            color: Colors.blue,
            width: double.infinity,
            height: 160,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            color: Colors.white,
            width: double.infinity,
            height: 40,
          ),
        ),
        Positioned(
          bottom: 8,
          left: 10,
          right: 10,
          child: Material(
            elevation: 10,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            child: _buildSearchFeild(),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchFeild() {
    return TextField(
      onChanged: (_) {
        setState(() {
          input = _;
        });
      },
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: 'Search',
        labelStyle: TextStyle(color: Colors.black),
        prefixIcon: Hero(
          tag: 'search',
          child: Icon(
            Icons.search,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}

class SearchResults extends StatefulWidget {
  String input;
  SearchResults({this.input});
  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MyDB.getSearchResult(widget.input),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Column(children: <Widget>[LinearProgressIndicator()]);
        }
        if (snap.hasError) {
          return Center(child: Text('${snap.error} err'));
        }
        List<dynamic> users = snap.data;
        List<Widget> widgets = [];

        users.forEach((user) {
          widgets.add(
            _buildSearchResultTile(
              user['img'],
              user['name'],
              user['uid'],
            ),
          );
        });
        return Column(children: widgets);
      },
    );
  }

  Widget _buildSearchResultTile(String imgURL, String name, String uid) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => StaticContent.push(context, UserProfile(uid: uid)),
        child: ListTile(
          leading: CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(imgURL),
          ),
          title: Text(name),
        ),
      ),
    );
  }
}
