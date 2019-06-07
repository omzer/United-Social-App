import 'package:flutter/material.dart';
import 'package:social/backend/my_db.dart';

import 'my_text.dart';

class MyPostCard extends StatelessWidget {
  final String uid;
  final String code;
  final String location;
  final String content;
  final double price;
  final String postId;
  final List<dynamic> photos;
  final Function onCardClicked;
  String date;
  String image;
  String name;

  MyPostCard({
    this.photos,
    this.uid,
    this.code,
    this.name,
    this.image,
    this.postId,
    this.date,
    this.location,
    this.content,
    this.price,
    this.onCardClicked,
  });

  BuildContext _context;
  SizedBox box;
  @override
  Widget build(BuildContext context) {
    _context = context;
    if (box != null) return box;
    return box = SizedBox(
      width: double.infinity,
      height: 240,
      child: Center(
        child: Card(
          elevation: 8,
          margin: EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: onCardClicked,
              child: FutureBuilder(
                future: MyDB.getUserInfoById(uid),
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return Stack(
                    children: <Widget>[
                      _buildPostLocation(),
                      _buildPostDate(),
                      _buildContent(),
                      _buildPrice(),
                      _buildAuthorName(
                          '${snap.data['displayName']} ${snap.data['familyName']}'),
                      _buildAuthorImage(snap.data['photoURL'])
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthorImage(String image) {
    this.image = image;
    return Positioned(
      top: 8,
      left: 8,
      child: Hero(
        tag: postId,
        child: CircleAvatar(
          backgroundImage: NetworkImage(image),
          maxRadius: 25,
          backgroundColor: Colors.blueGrey,
        ),
      ),
    );
  }

  Widget _buildPrice() {
    return Positioned(
      right: 0,
      top: 29,
      child: MyText(
        content: '$price\$',
        color: Colors.green,
      ),
    );
  }

  Widget _buildAuthorName(String name) {
    this.name = name;
    return Positioned(
      left: 64,
      top: 29,
      child: MyText(content: name),
    );
  }

  Widget _buildPostDate() {
    this.date = date.substring(0, 10);
    return Positioned(
      left: 0,
      top: 60,
      child: MyText(
        content: date,
        color: Colors.grey,
        size: 12,
      ),
    );
  }

  Widget _buildPostLocation() {
    return Positioned(
      left: 0,
      top: 75,
      child: MyText(
        content: location,
        color: Colors.blueAccent,
        size: 12,
      ),
    );
  }

  Widget _buildContent() {
    return Positioned(
      left: 8,
      top: 100,
      child: Container(
        width: MediaQuery.of(_context).size.width,
        height: 80,
        child: MyText(
          content: content ?? 'default content',
          overflow: TextOverflow.fade,
          maxLines: 5,
          size: 18,
        ),
      ),
    );
  }
}
