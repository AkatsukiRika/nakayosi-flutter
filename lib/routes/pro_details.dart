import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nakayosi_flutter/common/global.dart';

class ProDetails extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProDetailsState();
}

class _ProDetailsState extends State<ProDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(GlobalStrings.appBarRichText),
        actions: [
          TextButton(
            onPressed: () {
              // 上传此页面和become_pro页面的信息
            },
            child: Text(GlobalStrings.richTextSubmit),
            style: ButtonStyle(
              textStyle: MaterialStateProperty.all(
                TextStyle(fontSize: 18)
              ),
              foregroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.pressed)) {
                  return GlobalColors.colorGrey;
                } else {
                  return GlobalColors.colorWhite;
                }
              }),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Text('This is a text editor'),
          ),
        ],
      ),
    );
  }
}