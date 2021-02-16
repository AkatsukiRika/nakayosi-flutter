import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nakayosi_flutter/common/global.dart';

class AddNew extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddNewState();
}

// 表单Widget
class FormInside extends StatelessWidget {
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
              onPressed: () {
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
            child: FormInside(),
          ),
        ),
      ),
    );
  }
}