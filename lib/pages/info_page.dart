import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("About the App"),
      ),
      body: Center(child: Text("Yes, it does contain errors!!!"),),
    );
  }
}
