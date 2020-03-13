import 'package:flutter/material.dart';

import 'message.dart';

class Chat{

  final String username;
  final List<Message> messages;

  Chat({@required this.messages,@required this.username});
}