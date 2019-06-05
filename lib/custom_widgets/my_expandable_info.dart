import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:social/backend/my_db.dart';
import 'my_text.dart';

class ExpandablePersonalInfo extends StatelessWidget {
  final String uid;
  final BuildContext context;
  ExpandablePersonalInfo({
    this.uid,
    this.context,
  });

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      header: _buildHeader(),
      expanded: _buildFuture(),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: <Widget>[
        SizedBox(width: 4),
        Icon(
          Icons.info,
          color: Colors.blue,
        ),
        SizedBox(width: 8),
        MyText(
          content: 'User Info',
          size: 18,
          isBold: true,
        ),
      ],
    );
  }

  Widget _buildFuture() {
    return FutureBuilder(
      future: MyDB.getUserInfo(uid),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Column(children: <Widget>[LinearProgressIndicator()]);
        }
        List<Widget> widgets = [];
        // bio
        widgets.add(
          _buildListTile(Icons.view_list, 'Biography',
              snap.data['bio'] ?? 'not added yet'),
        );
        // age
        widgets.add(
          _buildListTile(
              Icons.child_care, 'Age', '${snap.data['age'] ?? '-'} years old'),
        );
        // city
        widgets.add(
          _buildListTile(Icons.location_city, 'City',
              snap.data['city'] ?? 'not added yet'),
        );
        // email
        widgets.add(
          _buildListTile(
              Icons.email, 'Email', snap.data['email'] ?? 'not added yet'),
        );
        // gender
        widgets.add(
          _buildListTile(
              Icons.group, 'Gender', snap.data['gender'] ?? 'not added yet'),
        );

        return Column(children: widgets);
      },
    );
  }

  Widget _buildListTile(IconData icon, String title, String content) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      subtitle: Text(content),
    );
  }
}
