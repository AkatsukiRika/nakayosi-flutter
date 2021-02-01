import 'dart:ui';

import 'package:alert/alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nakayosi_flutter/common/global.dart';
import 'package:nakayosi_flutter/routes/nk_main.dart';
import 'package:nakayosi_flutter/widgets/home_drawer.dart';

class NkHomePage extends StatefulWidget {
  NkHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _NkHomePageState createState() => _NkHomePageState();
}

class _NkHomePageState extends State<NkHomePage> {
  TextEditingController questionCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      drawer: Container(
        width: 211,
        child: HomeDrawer(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(7, 7, 7, 7),
              child: TextFormField(
                strutStyle: StrutStyle(
                  forceStrutHeight: true,
                  height: 1.3,
                ),
                controller: questionCtrl,
                maxLines: 8,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isCollapsed: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                  hintText: GlobalStrings.indexHint,
                  fillColor: GlobalColors.colorIndexTextField,
                  filled: true,
                )
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(7, 0, 7, 7),
              child: SizedBox(
                width: double.infinity,
                height: 42,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(GlobalColors.colorPrimary)
                  ),
                  child: Text(GlobalStrings.askButtonText),
                  onPressed: () {
                    if (questionCtrl.text.isNotEmpty) {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => NkMain(question: questionCtrl.text)
                      ));
                    } else {
                      Alert(message: GlobalStrings.nullQuestionToast).show();
                    }
                  }
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}