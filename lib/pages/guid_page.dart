import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:social/MyClasses/static_content.dart';
import 'package:social/backend/firebase_auth.dart';
import 'package:social/pages/login_page.dart';

import 'home_page.dart';

class GuidPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MyAuth.initUser();
    return Scaffold(
      body: Builder(
        builder: (context) => IntroViewsFlutter(
              _getPages(),
              onTapDoneButton: () {
                if (MyAuth.isSigned()) {
                  StaticContent.pushReplacement(context, HomePage());
                } else {
                  StaticContent.pushReplacement(context, LoginPage());
                }
              },
              pageButtonTextStyles: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ), //IntroViewsFlutter
      ), //Builder
    ); //Material App
  }
}

List<PageViewModel> _getPages() {
  final pages = [
    _createPage(
      Colors.amber,
      'United Socail',
      'Welcome! swipe to start',
      'logo2.png',
      Icon(
        Icons.swap_horizontal_circle,
        color: Colors.white,
      ),
    ),
    _createPage(
      Colors.lightGreen,
      'Our idea',
      'We collect people who needs services with others whom willing to serve',
      'idea.png',
      Icon(
        Icons.info,
        color: Colors.white,
      ),
    ),
    _createPage(
      Colors.lightBlue,
      'How it works',
      'You just write a post, and let us do the work!',
      'gears.png',
      Icon(
        Icons.settings,
        color: Colors.blueGrey,
      ),
    ),
    _createPage(
      Colors.blueGrey,
      'Is it free?',
      'Yes, totally!',
      'money_bag.png',
      Icon(
        Icons.monetization_on,
        color: Colors.green,
      ),
    ),
    _createPage(
      Colors.lime,
      'One last thing',
      'Keep in mind that you need internet access to use the app',
      'router.png',
      Icon(
        Icons.wifi,
        color: Colors.brown,
      ),
    ),
    _createPage(
      Colors.lightBlue,
      'Lets start!',
      'There is a lot to discover!!',
      'start.png',
      Icon(
        Icons.play_arrow,
        color: Colors.white,
      ),
    ),
  ];
  return pages;
}

PageViewModel _createPage(
  Color color,
  String title,
  String body,
  String img,
  Icon icon,
) {
  return PageViewModel(
    pageColor: color,
    bubble: icon,
    title: Text(title),
    body: Text(body),
    mainImage: Image.asset(
      'lib/assets/imgs/$img',
      height: 285.0,
      width: 285.0,
      alignment: Alignment.center,
    ),
  );
}
