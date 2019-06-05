import 'package:flutter/material.dart';
import 'package:social/MyClasses/static_content.dart';
import 'package:social/backend/my_db.dart';
import 'package:social/custom_widgets/my_custom_textfeild.dart';
import 'package:social/custom_widgets/my_star_rating.dart';

class MyDialogs {
  static void showCustomDialog(
      BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(child: Text(content)),
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

  static Future<void> showReviewDialog(
    BuildContext context,
    String code,
    String postOwnerID,
    String postId,
  ) async {
    if (postOwnerID == StaticContent.currentUser.uid) {
      // if the owner of the post is me
      await _showReviewDialog(context, postId, code, true, postOwnerID);
      _showCode(context, code);
    } else {
      // owner is someone else
      bool result = await _askForCode(context, code);
      if (result) {
        // tell db to close this post
        await _showReviewDialog(context, postId, code, false, postOwnerID);
        // take exchange reviews
      }
    }
  }

  static double ratingVal;
  static String reviewVal;
  static String codeEntered;

  static Future<void> _showReviewDialog(
    BuildContext context,
    String postId,
    String code,
    bool isPostOwner,
    String postOwnerID,
  ) async {
    ratingVal = 0;
    reviewVal = '';
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tell people about your experiance'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                StarRating(update: (_) => ratingVal = _),
                MyTextFeild(
                  label: 'Tell us more',
                  onChange: (_) => reviewVal = _,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () async {
                // Review Clicked
                if (isPostOwner) {
                  await MyDB.addRateToPost(
                      context, postId, ratingVal.round(), reviewVal);
                  Navigator.pop(context);
                } else {
                  MyDB.closePost(
                    context,
                    postId,
                    ratingVal.round(),
                    reviewVal,
                    postOwnerID,
                  );
                }
              },
              child: Text('Send review'),
            )
          ],
        );
      },
    );
  }

  static Future<void> _showCode(BuildContext context, String code) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Code is: $code'),
            content: Text('Share it with the person who helped you'),
            actions: <Widget>[
              FlatButton(
                  child: Text('done'), onPressed: () => Navigator.pop(context))
            ],
          );
        });
  }

  static Future<bool> _askForCode(BuildContext context, String code) async {
    bool result = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Check code'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Write down the code you have to close the post'),
                SizedBox(height: 16.0),
                MyTextFeild(
                  label: 'code',
                  onChange: (_) => codeEntered = _,
                  keyType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('submit'),
              onPressed: () {
                if (code == codeEntered) {
                  Navigator.pop(context);
                  result = true;
                } else {
                  showCustomDialog(context, 'Error', 'Wrong code');
                }
              },
            )
          ],
        );
      },
    );
    return result;
  }
}
