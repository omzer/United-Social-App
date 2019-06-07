import 'package:flutter/material.dart';
import 'package:social/MyClasses/static_content.dart';
import 'package:social/backend/my_db.dart';
import 'package:social/custom_widgets/my_text.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class ProfileCard extends StatefulWidget {
  final BuildContext context;
  final String uid;
  List<Widget> memo = [];
  ProfileCard({
    this.uid,
    this.context,
  });

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    isCurrentUser = widget.uid == StaticContent.currentUser.uid;
    return _buildFuture();
  }

  Widget _buildBackground() {
    return Container(
      width: double.infinity,
      height: isCurrentUser ? 200 : 230,
      color: Colors.blue,
    );
  }

  Widget _buildUserName(String name) {
    return Positioned(
      top: 10.0,
      left: MediaQuery.of(widget.context).size.width / 2 - name.length * 6.7,
      child: MyText(
        content: name.toUpperCase(),
        size: 22,
        isBold: true,
        color: Colors.white,
      ),
    );
  }

  Widget _buildUserImg(String url) {
    return Positioned(
      top: 40.0,
      left: MediaQuery.of(widget.context).size.width / 2 - 50,
      child: CircleAvatar(
        backgroundImage: NetworkImage(url),
        radius: 50,
      ),
    );
  }

  bool firstRefresh = true;

  Widget _buildUserRateBar() {
    return Positioned(
      top: 150.0,
      left: MediaQuery.of(widget.context).size.width / 2 - 75,
      child: SmoothStarRating(
        size: 30,
        starCount: 5,
        rating: StaticContent.totalReviews,
        color: Colors.amber,
        borderColor: Colors.amber,
      ),
    );
  }

  Widget _buildFuture() {
    if (widget.memo.isNotEmpty) return Stack(children: widget.memo);
    return FutureBuilder(
      future: MyDB.getUserDataForProfile(widget.uid),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting)
          return Center(child: CircularProgressIndicator());
        if (snap.hasError) {
          return Center(child: Text('Error occured!'));
        }
        widget.memo.add(_buildBackground());
        widget.memo.add(_buildUserName(snap.data['name']));
        widget.memo.add(_buildUserImg(snap.data['url']));
        widget.memo.add(_buildUserRateBar());
        widget.memo.add(_buildFollowButtonFuture());
        return Stack(children: widget.memo);
      },
    );
  }

  Widget _buildFollowButtonFuture() {
    if (isCurrentUser) return SizedBox();
    return FutureBuilder(
      future: MyDB.isFollower(widget.uid),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return _buildLoadingFollowButton();
        }
        return _buildFollowButton(snap.data);
      },
    );
  }

  Widget _buildFollowButton(bool isFollower) {
    if (isCurrentUser) return SizedBox();
    return Positioned(
      top: 8,
      right: 8,
      child: InkWell(
        onTap: () => _follow(isFollower),
        child: CircleAvatar(
          radius: 25,
          backgroundColor: isFollower ? Colors.green : Colors.grey,
          child: Icon(
            Icons.person_add,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingFollowButton() {
    if (isCurrentUser) return SizedBox();
    return Positioned(
      top: 8,
      right: 8,
      child: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.white,
        child: CircularProgressIndicator(),
      ),
    );
  }

  bool clicked = false;
  void _follow(bool isFollower) async {
    if (clicked) return;
    clicked = true;
    if (isFollower) {
      await MyDB.unFollowUser(widget.uid);
    } else {
      await MyDB.followUser(widget.uid);
    }
    setState(() {
      widget.memo.removeLast();
      widget.memo.insert(4, _buildFollowButtonFuture());
    });
    clicked = false;
  }
}
