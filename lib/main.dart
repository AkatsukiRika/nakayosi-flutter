import 'package:flutter/material.dart';
import 'package:nakayosi_flutter/routes/home_page.dart';
import 'package:nakayosi_flutter/common/global.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: GlobalStrings.appName,
      theme: ThemeData(
        primarySwatch: GlobalColors.colorPrimaryMaterial,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NkHomePage(title: GlobalStrings.appName)
    );
  }
}
