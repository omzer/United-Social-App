import 'package:flutter/material.dart';

class MyDialogs {
  static void showCustomDialog(
      BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Ok'),
            )
          ],
        );
      },
    );
  }

  static Future<bool> showYesNoDialog(
      BuildContext context, String title, String content) async {
    bool result;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
                result = true;
              },
              child: Text('Yes'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
                result = false;
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
    return result;
  }
}
