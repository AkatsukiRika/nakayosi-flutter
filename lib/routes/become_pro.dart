import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nakayosi_flutter/common/global.dart';

class BecomePro extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BecomeProState();
}

class BecomeProForm extends StatelessWidget {
  BecomeProForm({Key key, @required this.formKey, this.context}) : super(key: key);
  final GlobalKey<FormState> formKey;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Expanded(
        child: ListView(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: GlobalStrings.realNameLabel,
                labelStyle: TextStyle(height: 0.75),
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: GlobalStrings.idNumberLabel,
                labelStyle: TextStyle(height: 0.75),
                helperText: GlobalStrings.idNumberHelper,
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: GlobalStrings.phoneNumberLabel,
                labelStyle: TextStyle(height: 0.75),
                helperText: GlobalStrings.phoneNumberHelper,
              ),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: GlobalStrings.emailLabel,
                labelStyle: TextStyle(height: 0.75),
                helperText: GlobalStrings.emailHelper,
              ),
              keyboardType: TextInputType.emailAddress,
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