import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/chat_provider.dart';
import 'home_page.dart';

class AuthPage extends StatelessWidget {
  final Map<String, dynamic> _userData = {
    "name": null,
  };

  final TextEditingController _textController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void submitForm(BuildContext context) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    Provider.of<ChatProvider>(context, listen: false).setUsername =
        _userData["name"];

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _textController,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              onSaved: (String value) {
                _userData['name'] = value;
              },
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton(
              onPressed: () => submitForm(context),
              child: Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }
}
