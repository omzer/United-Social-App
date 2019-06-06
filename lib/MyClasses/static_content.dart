import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'my_user.dart';

class StaticContent {
  static User currentUser;
  static double totalReviews = 0;
  static void push(BuildContext context, var destination) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => destination,
      ),
    );
  }

  static void pushReplacement(BuildContext context, var destination) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => destination,
      ),
    );
  }

  static String longtext2 =
      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum';

  static String defaultMaleImg =
      'https://firebasestorage.googleapis.com/v0/b/freeworker-5517f.appspot.com/o/boy.png?alt=media&token=3faad434-141a-49b3-9176-40af208323e5';
  static String defaultFemaleImg =
      'https://firebasestorage.googleapis.com/v0/b/freeworker-5517f.appspot.com/o/girl.png?alt=media&token=e8a423db-4994-49ff-94a9-2c91e7a2e4a3';
}
