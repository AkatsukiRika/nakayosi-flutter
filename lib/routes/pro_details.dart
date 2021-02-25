import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/widgets/controller.dart';
import 'package:flutter_quill/widgets/editor.dart';
import 'package:flutter_quill/widgets/toolbar.dart';
import 'package:nakayosi_flutter/common/global.dart';

class ProDetails extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProDetailsState();
}

class _ProDetailsState extends State<ProDetails> {
  final QuillController _controller = QuillController.basic();
  final FocusNode _focusNode = FocusNode();

  String getEditorText() {
    final editorText = jsonEncode(_controller.document.toDelta().toJson());
    // TODO: Wait for backend development
    print(editorText);
    return editorText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(GlobalStrings.appBarRichText),
        actions: [
          TextButton(
            onPressed: () {
              // 上传此页面和become_pro页面的信息
              getEditorText();
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