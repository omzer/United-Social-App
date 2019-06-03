import 'package:flutter/material.dart';

class ViewImage extends StatelessWidget {
  final String image;
  ViewImage({this.image});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Hero(
          tag: image,
          child: FadeInImage.assetNetwork(
            image: image,
            placeholder: 'lib/assets/imgs/loading.gif',
          ),
        ),
      ),
    );
  }
}
