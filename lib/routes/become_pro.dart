import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nakayosi_flutter/common/global.dart';
import 'package:nakayosi_flutter/routes/pro_details.dart';
import 'package:nakayosi_flutter/models/pro_user.dart';

class BecomePro extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BecomeProState();
}

class BecomeProForm extends StatelessWidget {
  BecomeProForm({Key key, @required this.formKey, this.context}) : super(key: key);
  final GlobalKey<FormState> formKey;
  final BuildContext context;
  final ProUser proUser = ProUser();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Expanded(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: GlobalStrings.realNameLabel,
                labelStyle: TextStyle(height: 0.75),
              ),
              validator: (value) {
                if (!GlobalRegex.realName.hasMatch(value)) {
                  return GlobalStrings.realNameInvalid;
                }
                return null;
              },
              onChanged: (value) {
                proUser.realName = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: GlobalStrings.idNumberLabel,
                labelStyle: TextStyle(height: 0.75),
                helperText: GlobalStrings.idNumberHelper,
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (!GlobalRegex.idNumber.hasMatch(value)) {
                  return GlobalStrings.idNumberInvalid;
                }
                return null;
              },
              onChanged: (value) {
                proUser.idNumber = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: GlobalStrings.phoneNumberLabel,
                labelStyle: TextStyle(height: 0.75),
                helperText: GlobalStrings.phoneNumberHelper,
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (!GlobalRegex.phoneNumber.hasMatch(value)) {
                  return GlobalStrings.phoneNumberInvalid;
                }
                return null;
              },
              onChanged: (value) {
                proUser.phoneNumber = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: GlobalStrings.emailLabel,
                labelStyle: TextStyle(height: 0.75),
                helperText: GlobalStrings.emailHelper,
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (!GlobalRegex.emailAddress.hasMatch(value)) {
                  return GlobalStrings.emailAddressInvalid;
                }
                return null;
              },
              onChanged: (value) {
                proUser.email = value;
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: SizedBox(
                width: double.infinity,
                height: 42,
                child: ElevatedButton(
                  child: Text(GlobalStrings.goRichTextEdit),
                  onPressed: () async {
                    // 只跳转，不上传信息
                    if (formKey.currentState.validate()) {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => ProDetails(proUser: proUser),
                      ));
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BecomeProState extends State<BecomePro> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(GlobalStrings.titleBecomePro),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5, 2, 5, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                children: [
                  BecomeProForm(formKey: _formKey, context: context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}