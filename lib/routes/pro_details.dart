import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:flutter_quill/widgets/toolbar.dart';
import 'package:nakayosi_flutter/common/global.dart';
import 'package:nakayosi_flutter/common/http_request.dart';
import 'package:nakayosi_flutter/models/pro_user.dart';
import 'package:alert/alert.dart';

// ignore: must_be_immutable
class ProDetails extends StatefulWidget {
  ProUser proUser;

  ProDetails({Key key, @required this.proUser});

  @override
  State<StatefulWidget> createState() => _ProDetailsState();
}

class _ProDetailsState extends State<ProDetails> {
  final QuillController _controller = QuillController.basic();
  final FocusNode _focusNode = FocusNode();

  String getEditorText() => jsonEncode(_controller.document.toDelta().toJson());

  Future<String> doRequest(ProUser proUser) async {
    final url = HttpConfig.baseUrl + HttpConfig.apiAddProUser;
    final result = await NkHttpRequest.request(context, url, data: proUser.toMap(), method: 'post');
    try {
      final id = result['data']['id'];
      final status = result['data']['status'];
      print('pro_details: id=$id, status=$status');
      // 若成功创建，返回id，否则返回null，需判断
      return id;
    } catch (e) {
      Alert(message: e.toString()).show();
    }
    return null;
  }

  void showConfirmDialog(String title, String content, String buttonText) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              child: Text(buttonText),
              onPressed: () {
                Navigator.of(context).popUntil(ModalRoute.withName('/'));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(GlobalStrings.appBarRichText),
        actions: [
          TextButton(
            onPressed: () async {
              // 上传此页面和become_pro页面的信息
              widget.proUser.richText = getEditorText();
              String id = await doRequest(widget.proUser);
              if (id != null) {
                showConfirmDialog(
                  GlobalStrings.newProTitleSuccess,
                  GlobalStrings.newProContentSuccess,
                  GlobalStrings.buttonGoHome,
                );
              } else {
                showConfirmDialog(
                  GlobalStrings.newProTitleFailure,
                  GlobalStrings.newProContentFailure,
                  GlobalStrings.buttonGoHome
                );
              }
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
            child: QuillEditor(
              controller: _controller,
              readOnly: false,
              autoFocus: false,
              expands: false,
              focusNode: _focusNode,
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              scrollController: ScrollController(),
              scrollable: true,
              placeholder: GlobalStrings.richTextHint,
              enableInteractiveSelection: true,
              scrollPhysics: ClampingScrollPhysics(),
            ),
          ),
          QuillToolbar.basic(controller: _controller),
        ],
      ),
    );
  }
}