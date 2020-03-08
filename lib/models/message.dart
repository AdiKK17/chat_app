import 'package:flutter/material.dart';

@immutable
class Message {
  final String username;
  final String message;
  final DateTime dateTime;
  const Message({
    @required this.username,
    @required this.message,
    @required this.dateTime,
  });
}
