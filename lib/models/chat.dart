import 'package:flutter/material.dart';

class Chat{
  final String message;
  final DateTime datetime;
  bool sender;

  Chat({@required this.message,@required this.datetime,this.sender = true});
}