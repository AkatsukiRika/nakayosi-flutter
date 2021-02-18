import 'package:alert/alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nakayosi_flutter/common/global.dart';
import 'package:nakayosi_flutter/common/http_request.dart';
import 'main_content.dart';

class AddNew extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddNewState();
}

// 表单Widget
// ignore: must_be_immutable
class FormInside extends StatelessWidget {
  FormInside({Key key, @required this.formKey, this.context}) : super(key: key);
  final GlobalKey<FormState> formKey;
  final BuildContext context;
  String title = "";
  String question = "";

  Future<String> doRequest(Map<String, String> params) async {
    // 发送问题标题、问题内容给服务器
    final url = HttpConfig.baseUrl + HttpConfig.apiAddQuestion;
    print('add_new: request params = $params');
    final result = await NkHttpRequest.request(context, url, data: params, method: 'post');
    print('add_new: response = $result');
    try {
      final id = result['data']['id'];
      final status = result['data']['status'];
      print('add_new: id = $id, status = $status');
      // 若成功创建，返回id，否则返回null，需判断
      return id;
    } catch (e) {
      Alert(message: e.toString()).show();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextFormField(
          decoration: InputDecoration(
            labelText: GlobalStrings.nickNameLabel,
            labelStyle: TextStyle(height: 0.75),
          ),
          validator: (value) {
            if (value.isEmpty) {
              return GlobalStrings.nickNameLabel + GlobalStrings.validationSuffix;
            }
            return null;
          },
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: GlobalStrings.titleLabel,
            labelStyle: TextStyle(height: 0.75),
          ),
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          maxLines: 3,
          validator: (value) {
            if (value.isEmpty) {
              return GlobalStrings.titleLabel + GlobalStrings.validationSuffix;
            }
            return null;
          },
          onChanged: (value) {
            title = value;
          },
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: GlobalStrings.questionLabel,
            labelStyle: TextStyle(height: 0.75),
          ),
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          maxLines: 9,
          validator: (value) {
            if (value.isEmpty) {
              return GlobalStrings.questionLabel + GlobalStrings.validationSuffix;
            }
            return null;
          },
          onChanged: (value) {
            question = value;
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(GlobalColors.colorAnswerTitle),
              ),
              onPressed: () async {
                if (formKey.currentState.validate()) {
                  String id = await doRequest({
                    'title': title,
                    'question': question,
                  });
                  if (id != null) {
                    // 使用pushReplacement，进入问题页面后按下返回键不再返回到添加页面
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => MainContent(id: id)
                    ));
                  }
                }
              },
              child: Text(GlobalStrings.questionSubmit),
            ),
          ),
        ),
      ],
    );
  }
}

class _AddNewState extends State<AddNew> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primarySwatch: GlobalColors.materialColorMainContent,
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(GlobalStrings.appBarAddNew),
          backgroundColor: GlobalColors.colorMainContentAppBar
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(5, 2, 5, 0),
          child: Form(
            key: _formKey,
            child: FormInside(formKey: _formKey, context: context),
          ),
        ),
      ),
    );
  }
}