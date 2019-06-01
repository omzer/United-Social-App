import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:social/MyClasses/static_content.dart';
import 'package:social/backend/my_db.dart';
import 'package:social/custom_widgets/my_custom_post.dart';
import 'package:social/custom_widgets/my_text.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:social/pages/view_detailed_post.dart';

class UserProfile extends StatelessWidget {
  final String uid;
  BuildContext context;

  UserProfile({
    this.uid,
  });

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: MyDB.getUserInfoById(uid),
            builder: (context, userSnap) {
              if (userSnap.connectionState == ConnectionState.waiting) {
                return Center(child: LinearProgressIndicator());
              }
              String imgURL = userSnap.data['photoURL'];
              String name = userSnap.data['displayName'];
              name += ' ${userSnap.data['familyName']}';
              String location = userSnap.data['location'];
              List<dynamic> postsLinks = userSnap.data['posts'];
              List<Widget> widgets = [_buildStack(imgURL, name, location)];

              if (postsLinks == null) return Column(children: widgets);

              postsLinks.forEach((post) {
                Widget g = FutureBuilder(
                  future: MyDB.getPostById(post),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return LinearProgressIndicator();
                    }

                    String uid = snap.data['uid'];
                    String location = snap.data['location'];
                    String date = snap.data['date'];
                    int price = snap.data['price'];
                    String content = snap.data['description'];
                    String postId = snap.data.documentID;
                    String title = snap.data['title'];
                    List<dynamic> photos = snap.data['photos'];
                    MyPostCard current;
                    current = MyPostCard(
                      uid: uid,
                      location: location,
                      date: date,
                      price: price,
                      content: content,
                      postId: postId,
                      title: title,
                      photos: photos,
                      onCardClicked: () => _postClicked(current),
                    );
                    return current;
                  },
                );
                widgets.add(g);
              });
              return Column(children: widgets);
            }),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text('User profile'),
      elevation: 0,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.send,
            color: Colors.white,
          ),
          onPressed: _sendMessage,
        )
      ],
    );
  }

  Widget _buildStack(String imgURL, String name, String location) {
    return Container(
      color: Colors.blue,
      height: 180,
      child: Stack(
        children: <Widget>[
          MyCircle(size: 150, bottom: -40, left: -60),
          MyCircle(size: 80, top: 40, right: -20),
          MyCircle(size: 200, top: -70, right: 30),
          _buildUserProfile(imgURL),
          _buildUserName(name),
          _buildUserLocation(location),
          _buildFollowButton(),
          _buildRatingBar(),
        ],
      ),
    );
  }

  Widget _buildUserProfile(String url) {
    return Positioned(
      left: MediaQuery.of(context).size.width / 2 - 40,
      top: 30,
      child: CircleAvatar(
        radius: 40,
        backgroundImage: NetworkImage(url ?? StaticContent.defaultMaleImg),
      ),
    );
  }

  Widget _buildUserName(String userName) {
    return Positioned(
      top: 10,
      left: 8,
      child: MyText(
        content: userName ?? 'user name',
        color: Colors.white,
        size: 18,
        align: TextAlign.center,
        isBold: true,
      ),
    );
  }

  Widget _buildUserLocation(String location) {
    return Positioned(
      top: 40,
      left: 8,
      child: MyText(
        content: location ?? 'no location',
        color: Colors.white,
        size: 18,
        align: TextAlign.center,
        isBold: true,
      ),
    );
  }

  Widget _buildFollowButton() {
    return Positioned(
      top: 8,
      right: 8,
      child: MaterialButton(
        child: Icon(
          Icons.person_add,
          color: Colors.white,
        ),
        color: Colors.blueGrey,
        onPressed: _follow,
      ),
    );
  }

  Widget _buildRatingBar() {
    return Positioned(
      top: 120,
      left: MediaQuery.of(context).size.width / 2 - 95,
      child: SmoothStarRating(
        rating: 3.3,
        color: Colors.yellowAccent,
        borderColor: Colors.white,
        starCount: 5,
        size: 40,
      ),
    );
  }

  void _follow() {}

  void _sendMessage() {}

  void _postClicked(MyPostCard post) {
    StaticContent.push(this.context, ViewDetailedPost(post: post));
  }
}

class MyCircle extends StatelessWidget {
  final double size;
  final double top;
  final double bottom;
  final double left;
  final double right;

  MyCircle({
    this.size,
    this.top,
    this.bottom,
    this.left,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.15),
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }
}
