import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:social/backend/my_db.dart';
import 'package:social/custom_widgets/my_dialogs.dart';
import 'package:social/custom_widgets/my_text.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class MyExpandableReviews extends StatelessWidget {
  final String uid;
  final BuildContext context;
  MyExpandableReviews({
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

  Widget _buildFuture() {
    return FutureBuilder(
      future: MyDB.getReviews(uid),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Column(children: <Widget>[LinearProgressIndicator()]);
        }
        List<dynamic> listOfReviews = snap.data;
        List<Widget> listOfWidgets = [];
        listOfReviews.forEach((review) {
          listOfWidgets.add(
            _buildReview(
              review['rate'],
              review['rateContent'],
              review['imgURL'],
              review['name'],
            ),
          );
          listOfWidgets.add(SizedBox(height: 8));
        });
        return Column(children: listOfWidgets);
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: <Widget>[
        SizedBox(width: 4),
        Icon(
          Icons.star_half,
          color: Colors.blue,
        ),
        SizedBox(width: 8),
        MyText(
          content: 'User Reviews',
          size: 18,
          isBold: true,
        ),
      ],
    );
  }

// 47630951
  Widget _buildReview(int rating, String review, String imgURL, String name) {
    return SizedBox(
      width: double.infinity,
      height: 150,
      child: InkWell(
        onTap: () => _showReview(review),
        child: Card(
          elevation: 10,
          child: Stack(
            children: <Widget>[
              _buildUserImage(imgURL),
              _buildName(name),
              _buildRating(rating),
              _buildReviewContent(review),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserImage(String imgURL) {
    return Positioned(
      left: 4,
      top: 4,
      child: CircleAvatar(
        backgroundImage: NetworkImage(imgURL),
        radius: 25,
        backgroundColor: Colors.amber,
      ),
    );
  }

  Widget _buildName(String name) {
    return Positioned(
      top: 10,
      left: 60,
      child: MyText(
        content: name.toUpperCase(),
        size: 16,
      ),
    );
  }

  Widget _buildRating(int rate) {
    return Positioned(
      top: 10,
      right: 10,
      child: SmoothStarRating(
        rating: rate.toDouble(),
        starCount: 5,
        size: 20,
      ),
    );
  }

  Widget _buildReviewContent(String review) {
    return Positioned(
      left: 8,
      top: 65,
      right: 8,
      child: MyText(
        size: 16,
        content: review,
        maxLines: 3,
        overflow: TextOverflow.fade,
      ),
    );
  }

  void _showReview(String review) {
    MyDialogs.showCustomDialog(context, 'Review content', review);
  }
}
