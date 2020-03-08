import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/chat.dart';
import '../models/message.dart';

class ChatProvider extends ChangeNotifier{

  var _userName = "";

  var _currentTopic = "al";

  final List<Message> _chatMessages = [];
  List<String> _subscribedTopics = ["al"];

  String get username{
    return _userName;
  }

  String get currentTopic{
    return _currentTopic;
  }

  List<String> get subscribedTopics {
    return List.from(_subscribedTopics);
  }

  bool get isAuthenticated {
    return _userName.isNotEmpty;
  }

  set setUsername(String name){
    _userName = name;
    setUserName(name);
  }

  List<Message> get chatMessages {
    return List.from(_chatMessages);
  }



  ///////////////////

  void setCurrentTopic(topic) {
    _currentTopic = topic;
    notifyListeners();
  }

  void setUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("username", name);
  }

  Future<bool> NamedOrNot() async {
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey("username")){
      return false;
    }
    _userName = prefs.getString("username");
    notifyListeners();
    return true;
  }

  void addTopics(String topic) async {

    final prefs = await SharedPreferences.getInstance();
    if(prefs.getStringList("topicList") != null){
      _subscribedTopics = prefs.getStringList("topicList");
    }
    _subscribedTopics.add(topic);
    prefs.setStringList("topicList", _subscribedTopics);

    notifyListeners();
 }

 void deleteTopics(int index) async {
   final prefs = await SharedPreferences.getInstance();

   if(prefs.getStringList("topicList") != null){
     _subscribedTopics = prefs.getStringList("topicList");
   }

   _subscribedTopics.removeAt(index);
   prefs.setStringList("topicList", _subscribedTopics);

    notifyListeners();
 }

 void setTopics() async {
   final prefs = await SharedPreferences.getInstance();

   if(prefs.getStringList("topicList") != null){
     _subscribedTopics = prefs.getStringList("topicList");
   }
   prefs.setStringList("topicList", _subscribedTopics);

   notifyListeners();
 }

  void sendMessages(String name,String message){
    final Message textMessage = Message(username: name,message: message,dateTime: DateTime.now());
    _chatMessages.add(textMessage);
    notifyListeners();
  }

}