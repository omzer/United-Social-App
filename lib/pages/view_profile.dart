import 'package:flutter/material.dart';
import 'package:social/MyClasses/static_content.dart';
import 'package:social/custom_widgets/my_expandable_info.dart';
import 'package:social/custom_widgets/my_expandable_post.dart';
import 'package:social/custom_widgets/my_expandable_reviews.dart';
import 'package:social/custom_widgets/user_profile_stack.dart';

import 'message_page.dart';

class UserProfile extends StatelessWidget {
  final String uid;
  BuildContext context;

  UserProfile({
    this.uid,
  });
  List<Widget> widgets = [];
  @override
  Widget build(BuildContext context) {
    this.context = context;
    if (widgets.isEmpty) {
      // Personal info section
      widgets.add(ExpandablePersonalInfo(uid: uid, context: context));
      widgets.add(Divider(color: Colors.black));
      // Reviews section
      widgets.add(MyExpandableReviews(uid: uid, context: context));
      widgets.add(Divider(color: Colors.black));
      // Posts section
      widgets.add(ExpandablePosts(uid: uid, context: context));
      // Profile img and name (first element in the page)
      widgets.insert(0, ProfileCard(uid: uid, context: context));
    }
    return Scaffold(
      appBar: _buildAppBar(),
      body: ListView(
        children: widgets,
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('User Profile'),
      elevation: 0,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.send,
            color: Colors.white,
          ),
          onPressed: () => StaticContent.push(context, MessagePage(uid: uid)),
        )
      ],
    );
  }
}
