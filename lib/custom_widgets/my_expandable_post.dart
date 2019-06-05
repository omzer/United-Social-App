import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:social/backend/my_db.dart';
import 'package:social/custom_widgets/my_custom_post.dart';

import 'my_text.dart';

class ExpandablePosts extends StatelessWidget {
  final String uid;
  final BuildContext context;
  ExpandablePosts({
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
          Icons.featured_play_list,
          color: Colors.blue,
        ),
        SizedBox(width: 8),
        MyText(
          content: 'User Posts',
          size: 18,
          isBold: true,
        ),
      ],
    );
  }

  Widget _buildFuture() {
    return FutureBuilder(
      future: MyDB.getAllPostForUser(uid),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Column(children: <Widget>[LinearProgressIndicator()]);
        }
        List<Widget> posts = [];
        List<dynamic> postsSanp = snap.data;

        postsSanp.forEach((post) {
          posts.add(MyPostCard(
            uid: post['uid'],
            location: post['location'],
            date: post['date'],
            code: post['code'],
            price: post['price'],
            content: post['description'],
            photos: post['photos'],
            postId: post['postId'],
            onCardClicked: () => print('todooooo'),
          ));
        });

        return Column(children: posts);
      },
    );
  }
}
