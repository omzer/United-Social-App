import 'package:flutter/material.dart';
import 'package:social/pages/guid_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//      showSemanticsDebugger: true,
      debugShowCheckedModeBanner: false,
      home: GuidPage(),
    );
  }
}
