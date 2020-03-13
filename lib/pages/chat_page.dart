import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';

//import '../provider/testing_provider.dart';
import '../provider/chat_provider.dart';
import '../helper/messaging.dart';

class ChatPage extends StatefulWidget {

  final int chatIndex;

  ChatPage(this.chatIndex);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ChatPage();
  }
}

class _ChatPage extends State<ChatPage> {

  final Map<String, dynamic> _messageData = {
    "message": null,
  };


  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  final TextEditingController _textController = TextEditingController();

//  final ScrollController _scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildSendButton() {
    return FlatButton(
      onPressed: () async {
        if (_textController.text == null) {
          return;
        }
//        Provider.of<ChatProvider>(context, listen: false)
//            .sendMessages(_textController.text);
        sendNotification();
        _textController.text = "";
      },
      child: Text(
        "Send",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.lightBlueAccent,
            fontSize: 22),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _firebaseMessaging.onTokenRefresh.listen(sendTokenToServer);
    _firebaseMessaging.getToken();

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  void sendTokenToServer(String fcmToken) {
    print('Token: $fcmToken');
    // send key to your server to allow server to use
    // this token to send push notifications
  }

  Future sendNotification() async {
    final response = await Messaging.sendToTopic(
      title: Provider.of<ChatProvider>(context, listen: false).username,
      body: _textController.text,
      topic: Provider.of<ChatProvider>(context,listen: false).currentTopic,
    );

    print(response.body);

    if (response.statusCode != 200) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content:
            Text('[${response.statusCode}] Error message: ${response.body}'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat: ${Provider.of<ChatProvider>(context).chatMessages[widget.chatIndex].username}"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: Provider.of<ChatProvider>(context)
                                .chatMessages[widget.chatIndex]
                                .messages[index].username !=
                            Provider.of<ChatProvider>(context).username
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width / (1.2),
                        ),
                        margin: EdgeInsets.all(6.0),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          border: Border.all(
                              color: Colors.grey,
                              width: 1,
                              style: BorderStyle.solid),
                        ),
                        child: Wrap(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  Provider.of<ChatProvider>(context)
                                      .chatMessages[widget.chatIndex]
                                      .messages[index].username,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(
                                  height: 9,
                                ),
                                Text(Provider.of<ChatProvider>(context)
                                    .chatMessages[widget.chatIndex]
                                    .messages[index].message),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  DateFormat("H:mm").format(
                                    Provider.of<ChatProvider>(context)
                                        .chatMessages[widget.chatIndex]
                                        .messages[index].dateTime,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                itemCount:
                    Provider.of<ChatProvider>(context).chatMessages[widget.chatIndex].messages.length,
              ),
            ),
            Form(
                key: _formKey,
                child: Container(
                  margin:
                      EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 4),
                  padding: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      border: Border.all(
                          color: Colors.black,
                          width: 1,
                          style: BorderStyle.solid)),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          maxLines: 1,
                          controller: _textController,
                          decoration:
                              InputDecoration.collapsed(hintText: "Message..."),
                          onSaved: (String value) {
                            _messageData["message"] = _textController.text;
                          },
                        ),
                      ),
                      _textController.text == null
                          ? IconButton(
                              icon: Icon(Icons.camera_alt),
                              onPressed: () {},
                            )
                          : _buildSendButton(),
                    ],
                  ),
                ),),
          ],
        ),
      ),
    );
  }
}
