import 'package:alert/alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nakayosi_flutter/common/global.dart';
import 'package:nakayosi_flutter/common/http_request.dart';
import 'package:nakayosi_flutter/routes/main_content.dart';

class AddAnswer extends StatefulWidget {
  final id;
  final MainContentState mainContentState;

  AddAnswer({Key key, @required this.id, @required this.mainContentState});

  @override
  State<StatefulWidget> createState() => _AddAnswerState();
}

class _AddAnswerState extends State<AddAnswer> {
  String answerContent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(GlobalStrings.addAnswer),
        actions: [
          TextButton(
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
            onPressed: () {
              print('问题ID: ${widget.id}, 回答内容: $answerContent');
              doRequest(widget.id, answerContent);
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(7.0),
              child: TextField(
                decoration: InputDecoration.collapsed(hintText: GlobalStrings.addAnswerHint),
                maxLines: null,
                onChanged: (value) {
                  answerContent = value;
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  void doRequest(String id, String answer) async {
    final url = HttpConfig.baseUrl + HttpConfig.apiAddAnswer;
    final params = {
      'id': id,
      'answer': answer
    };
    final result = await NkHttpRequest.request(context, url, data: params, method: 'post');
    try {
      if (result['data']['status'] == 'success') {
        Navigator.pop(context);
        widget.mainContentState.doRequest(widget.mainContentState.params);
      } else {
        Alert(message: GlobalStrings.addAnswerFail).toString();
        Navigator.pop(context);
      }
    } catch (e) {
      Alert(message: e.toString()).show();
    }
  }
}