import 'package:chat_app/pages/home_page.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import './provider/chat_provider.dart';

//import './pages/home_page.dart';
import './pages/auth_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ChatProvider(),
        ),
      ],
      child: Consumer<ChatProvider>(
        builder: (ctx, auth, _) =>
            MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(
                primarySwatch: Colors.purple,
              ),
              home: auth.isAuthenticated
                  ? HomePage()
                  : FutureBuilder(
                future: auth.NamedOrNot(),
                builder: (context, authResult) =>
                authResult.connectionState == ConnectionState.waiting
                    ? Scaffold(
                  body: Center(
                    child: Text("Welcome To Chattie"),
                  ),
                )
                    : AuthPage(),
              ),
            ),
      ),
    );
  }
}
