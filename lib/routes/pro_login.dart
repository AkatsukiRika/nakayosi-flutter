import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nakayosi_flutter/common/global.dart';
import 'package:alert/alert.dart';
import 'package:nakayosi_flutter/common/http_request.dart';
import 'package:nakayosi_flutter/common/nk_utils.dart';

class ProLogin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProLoginState();
}

class _ProLoginState extends State<ProLogin> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(GlobalStrings.drawerProLogin),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5, 2, 5, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ProLoginForm(formKey: _formKey, context: context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ProLoginForm extends StatelessWidget {
  ProLoginForm({Key key, @required this.formKey, this.context}) : super(key: key);
  final GlobalKey<FormState> formKey;
  final BuildContext context;
  String emailAddress;
  String password;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: GlobalStrings.proLoginEmailLabel,
              labelStyle: TextStyle(height: 0.75),
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) {
              emailAddress = value;
            },
            validator: (value) {
              if (!GlobalRegex.emailAddress.hasMatch(value)) {
                return GlobalStrings.emailAddressInvalid;
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: GlobalStrings.proLoginPwdLabel,
              labelStyle: TextStyle(height: 0.75),
            ),
            obscureText: true,
            onChanged: (value) {
              password = value;
            },
            validator: (value) {
              if (password == null || password.isEmpty) {
                return GlobalStrings.loginEmptyAlert;
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
                child: Text(GlobalStrings.loginBtnText),
                onPressed: () async {
                  if (formKey.currentState.validate()) {
                    doRequest(context, emailAddress, password);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void doRequest(BuildContext context, String emailAddress, String password) async {
    if (emailAddress != null && password != null) {
      final url = HttpConfig.baseUrl + HttpConfig.apiProUserLogin;
      final params = {
        'email': emailAddress,
        'password': NKUtils.stringToMd5(password),
      };
      final result = await NkHttpRequest.request(context, url, data: params, method: 'post');
      try {
        final status = result['data']['status'];
        final errMsg = result['data']['errMsg'];
        if (status == 'success') {
          final realName = result['data']['realName'];
          GlobalStates.realNameLoggedIn = realName;
          // 跳转回到主页
          Navigator.of(context).popUntil(ModalRoute.withName('/'));
        } else {
          Alert(message: errMsg).show();
        }
      } catch (e) {
        Alert(message: e.toString()).show();
      }
    }
  }
}