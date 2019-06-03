import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class StarRating extends StatefulWidget {
  final Function update;
  StarRating({this.update});
  @override
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  double rating = 0;
  var colors = [
    Colors.black,
    Colors.red,
    Colors.purple,
    Colors.greenAccent,
    Colors.green,
    Colors.amber,
  ];
  var comments = [
    'No rating',
    'Very Bad',
    'Bad',
    'Averege',
    'Good',
    'Excellent',
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('${comments[rating.round()]}'),
        SmoothStarRating(
          rating: rating,
          color: colors[rating.round()],
          borderColor: Colors.black,
          starCount: 5,
          allowHalfRating: false,
          size: 35,
          onRatingChanged: (double val) {
            setState(() {
              rating = val;
              widget.update(val);
            });
          },
        ),
      ],
    );
  }
}
