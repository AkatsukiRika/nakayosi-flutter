import 'dart:ui';

import 'package:alert/alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nakayosi_flutter/common/global.dart';
import 'package:nakayosi_flutter/common/http_request.dart';
import 'package:nakayosi_flutter/routes/main_content.dart';

class NkMain extends StatefulWidget {
  final String question;

  NkMain({Key key, this.question});

  @override
  State<StatefulWidget> createState() => _NkMainState();
}

class _NkMainState extends State<NkMain> {
  final List<ListItem> items = List<ListItem>();
  ScrollController ctrl = ScrollController();
  // params包含2个参数：question(str), from(int)
  Map<String, dynamic> params;
  // 是否已首次从服务器请求到数据
  var isFirstRequested = false;

  @override
  void initState() {
    super.initState();
    ctrl.addListener(() {
      if (ctrl.position.pixels == ctrl.position.maxScrollExtent) {
        // 再加载10条网络数据
        if (params != null) {
          params['from'] = items.length;
          doRequest(params);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    params = {
      'question': widget.question,
      'from': 0
    };
    if (!isFirstRequested) {
      doRequest(params);
      isFirstRequested = true;
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(GlobalStrings.titleAskResult)
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(
                color: Colors.black,
                thickness: 0.15,
                height: 0
              ),
              controller: ctrl,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final QuestionItem item = items[index];
                return InkWell(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      item.buildTitle(context),
                      item.buildBody(context),
                    ],
                  ),
                  onTap: () {
                    print('nk_main: item tapped = ${item.id}');
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => MainContent(id: item.id)
                    ));
                  },
                );
              }
            )
          )
        ],
      )
    );
  }

  void doRequest(Map<String, dynamic> params) async {
    // 请求服务器，获得结果列表
    final url = HttpConfig.baseUrl + HttpConfig.apiAskQuestion;
    print('nk_main: request url = $url, method = GET');
    print('nk_main: request params = $params');
    final result = await NkHttpRequest.request(context, url, params: params);
    print('nk_main: response = $result');
    try {
      // result['data']['response']是一个列表，每个列表项都有id/title/question
      final responseList = result['data']['response'];
      // result['data']['count']是个数字，int类型
      int count = result['data']['count'];
      for (int index = 0; index < count; index++) {
        final id = responseList[index]['id'];
        final title = responseList[index]['title'];
        final String question = responseList[index]['question'];
        final item = QuestionItem(id, title, question.replaceAll('\n', ''));
        setState(() {
          items.add(item);
        });
      }
    } catch (e) {
      print('nk_main: error = ${e.toString()}');
      Alert(message: e.toString()).show();
    }
  }
}

abstract class ListItem {
  Widget buildTitle(BuildContext context);
  Widget buildBody(BuildContext context);
}

class QuestionItem implements ListItem {
  final String id;
  final String title;
  final String body;

  QuestionItem(this.id, this.title, this.body);

  Widget buildTitle(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.fromLTRB(10, 12, 10, 5),
        child: Text(
          title,
          maxLines: 1,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    ],
  );
  Widget buildBody(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.max,
    children: [
      Expanded(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 12),
          child: Text(
            body,
            maxLines: 3,
            style: TextStyle(fontSize: 12, color: GlobalColors.colorGrey,),
            strutStyle: StrutStyle(
              forceStrutHeight: true,
              height: 1.25,
            ),
          ),
        ),
      ),
    ],
  );
}