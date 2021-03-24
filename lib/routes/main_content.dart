import 'dart:ui';

import 'package:alert/alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:nakayosi_flutter/common/global.dart';
import 'package:nakayosi_flutter/common/http_request.dart';
import 'package:nakayosi_flutter/routes/add_answer.dart';

// 顶部显示标题和问题内容的Widget
class HeaderWidget extends StatelessWidget {
  final title;
  final subTitle;

  HeaderWidget({Key key, this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  strutStyle: StrutStyle(
                    forceStrutHeight: true,
                    height: 1.7,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          thickness: 0.15,
          color: Colors.black,
          height: 0,
        ),
        ListTile(
          title: Text(
            subTitle,
            strutStyle: StrutStyle(
              forceStrutHeight: true,
              height: 1.7,
            ),
          ),
          contentPadding: EdgeInsets.fromLTRB(15, 8, 15, 8),
        ),
      ],
    );
  }
}

// 显示一条回答的Widget
class AnswerWidget extends StatefulWidget {
  final int index;
  final String answer;

  AnswerWidget({Key key, this.index, this.answer});

  @override
  State<StatefulWidget> createState() => _AnswerWidgetState();
}

class _AnswerWidgetState extends State<AnswerWidget> {
  bool _isExpanded = false;
  Icon _controlIcon;
  String _controlText;
  int _maxLines;
  String _text;

  @override
  Widget build(BuildContext context) {
    _controlIcon = _isExpanded ? Icon(Icons.keyboard_arrow_up, color: GlobalColors.colorGrey)
        : Icon(Icons.keyboard_arrow_down, color: GlobalColors.colorGrey);
    _controlText = _isExpanded ? GlobalStrings.shrinkAnswer : GlobalStrings.expandAnswer;
    _maxLines = _isExpanded ? GlobalNumbers.maxInt : 3;
    _text = _isExpanded ? widget.answer : widget.answer.replaceAll('\n', '');
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      margin: EdgeInsets.fromLTRB(13, 7, 13, 7),
      elevation: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            dense: true,
            title: Center(
              child: Text(
                '${GlobalStrings.answerTitle} ${widget.index + 1}',
                style: TextStyle(
                  color: GlobalColors.colorWhite,
                  fontSize: 16
                ),
              ),
            ),
            tileColor: GlobalColors.colorAnswerTitle,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 10, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Text(
                    _text,
                    strutStyle: StrutStyle(forceStrutHeight: true, height: 1.7),
                    style: TextStyle(fontSize: 16),
                    maxLines: _maxLines,
                  ),
                ),
              ],
            ),
          ),
          Theme(
            data: ThemeData(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 10, 5),
              child: InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _controlIcon,
                    Text(
                      _controlText,
                      style: TextStyle(
                        color: GlobalColors.colorGrey,
                        fontSize: 12
                      ),
                    )
                  ]
                ),
                onTap: () {
                  setState(() {
                    this._isExpanded = !this._isExpanded;
                  });
                },
              )
            )
          )
        ],
      )
    );
  }
}

// ignore: must_be_immutable
class MainContent extends StatefulWidget {
  final String id;
  // 需要传递给AddAnswer组件的MainContentState
  MainContentState mainContentState;

  MainContent({Key key, this.id});

  @override
  State<StatefulWidget> createState() {
    mainContentState = MainContentState();
    return mainContentState;
  }
}

class MainContentState extends State<MainContent> {
  // params包含1个参数：id(str)
  Map<String, String> params;
  // 是否已首次从服务器请求到数据
  var isFirstRequested = false;
  // 需要传递给子ListView的数据项
  var _title = GlobalStrings.questionTitleDefault;
  var _subTitle = GlobalStrings.questionSubTitleDefault;
  var _answerList = List<dynamic>();

  @override
  Widget build(BuildContext context) {
    params = {
      'id': widget.id
    };
    if (!isFirstRequested) {
      doRequest(params);
      isFirstRequested = true;
    }

    return Theme(
      data: ThemeData(
        primarySwatch: GlobalColors.materialColorMainContent,
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(GlobalStrings.titleMainContent),
          backgroundColor: GlobalColors.colorMainContentAppBar,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                margin: EdgeInsets.fromLTRB(13, 7, 13, 7),
                elevation: 3,
                child: HeaderWidget(title: _title, subTitle: _subTitle),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return AnswerWidget(
                    index: index,
                    answer: _answerList[index],
                  );
                },
                itemCount: _answerList.length,
              ),
              Row(
                children: [
                  Divider(
                    color: Colors.transparent,
                    height: 10,
                  ),
                ],
              ),
              Offstage(
                offstage: GlobalStates.realNameLoggedIn == null,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(13, 0, 13, 14),
                  child: SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: ElevatedButton(
                      child: Text(GlobalStrings.addAnswer),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => AddAnswer(id: widget.id, mainContentState: widget.mainContentState),
                        ));
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(GlobalColors.colorAddAnswerBtn),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }

  void doRequest(Map<String, String> params) async {
    // 通过问题ID请求服务器，获得问题及回答列表
    final url = HttpConfig.baseUrl + HttpConfig.apiGetResult;
    print('main_content: request url = $url, method = GET');
    print('main_content: request params = $params');
    final result = await NkHttpRequest.request(context, url, params: params);
    print('main_content: response = $result');
    try {
      /**
       * result['data']['source']下有4个key
       * ['title']是问题的标题，['question']是问题内容
       * ['answers']是答案列表，['type']是类别标签列表
       * 所有类型均为String
       */
      final title = result['data']['source']['title'];
      final question = result['data']['source']['question'];
      final List<dynamic> answerList = result['data']['source']['answers'];
      setState(() {
        _title = title;
        _subTitle = question;
        if (answerList != null) {
          _answerList = answerList;
        }
      });
    } catch (e) {
      print('main_content: error = ${e.toString()}');
      Alert(message: e.toString()).show();
    }
  }

  void addAnswer(String content) {
    // 用于从AddAnswer回到详情页面时调用，在界面上添加一条回答
    setState(() {
      _answerList.add(content);
    });
  }
}