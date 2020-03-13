import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../provider/chat_provider.dart';
import 'chat_page.dart';
import 'info_page.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePage();
  }
}

class _HomePage extends State<HomePage> {
  final TextEditingController _textController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  static int i = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero).then((_) {
      Provider.of<ChatProvider>(context, listen: false).setTopics();

      if (Provider.of<ChatProvider>(context, listen: false)
              .subscribedTopics
              .length !=
          0) {
        Provider.of<ChatProvider>(context, listen: false)
            .subscribedTopics
            .forEach((topic) {
          _firebaseMessaging.subscribeToTopic(topic);
        });
      }
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        if (i % 2 == 0) {
          print("onMessage: $message");
          final notification = message['data'];
          setState(() {
            Provider.of<ChatProvider>(context, listen: false).sendMessages(
                notification["title"],
                notification["body"],
                notification["topic"]);
          });
        }
        i++;
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        final notification = message['data'];
        setState(() {
          Provider.of<ChatProvider>(context, listen: false).sendMessages(
              notification["title"],
              notification["body"],
              notification["topic"]);
        });
      },
      onResume: (Map<String, dynamic> message) async {
        if (i % 2 == 0) {
          print("onResume: $message");
          final notification = message['data'];
          setState(() {
            Provider.of<ChatProvider>(context, listen: false).sendMessages(
                notification["title"],
                notification["body"],
                notification["topic"]);
          });
        }
        i++;
      },
    );
  }

  void addTopic(BuildContext context) {
    if (!_formKey.currentState.validate()) {
      return;
    }

    if (_textController.text != null) {
      Provider.of<ChatProvider>(context, listen: false)
          .addTopic(_textController.text);
      _firebaseMessaging.subscribeToTopic(_textController.text);
      _textController.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${Provider.of<ChatProvider>(context).username}"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => InfoPage(),
              ),
            ),
          )
        ],
      ),
      body: Container(
          child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _textController,
              decoration: InputDecoration(labelText: 'Username'),
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please enter a Username';
                }
                return null;
              },
            ),
            RaisedButton(
              onPressed: () => addTopic(context),
              child: Text("Add UserName"),
            ),
            SizedBox(
              height: 25,
            ),
            Text("Usernames"),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Column(
                      children: <Widget>[
                        Divider(),
                        ListTile(
                          onTap: () {
                            Provider.of<ChatProvider>(context, listen: false)
                                .setCurrentTopic(Provider.of<ChatProvider>(
                                        context,
                                        listen: false)
                                    .subscribedTopics[index]);

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChatPage(index),
                              ),
                            );
                          },
                          leading: Text(
                            Provider.of<ChatProvider>(context)
                                .subscribedTopics[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 24),
                          ),
                          trailing:
                              Provider.of<ChatProvider>(context, listen: false)
                                          .subscribedTopics[index] ==
                                      Provider.of<ChatProvider>(context,
                                              listen: false)
                                          .username
                                  ? Container(width: 1,)
                                  : IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        _firebaseMessaging.unsubscribeFromTopic(
                                            Provider.of<ChatProvider>(context,listen: false)
                                                .subscribedTopics[index]);
                                        Provider.of<ChatProvider>(context,
                                                listen: false)
                                            .deleteTopics(index);
                                      },
                                    ),
                        ),
                      ],
                    ),
                  );
                },
                itemCount:
                    Provider.of<ChatProvider>(context).subscribedTopics.length,
              ),
            )
          ],
        ),
      )),
    );
  }
}
