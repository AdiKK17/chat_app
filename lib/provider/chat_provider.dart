import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/chat.dart';
import '../models/message.dart';

class ChatProvider extends ChangeNotifier{

  var _userName = "";

  var _currentTopic;

  final List<Chat> _chatMessages = [];
  List<String> _subscribedTopics = [];

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

  List<Chat> get chatMessages {
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
    addTopic(name);
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

  void addTopic(String topic) async {
    final prefs = await SharedPreferences.getInstance();

    if(prefs.getStringList("topicList") != null){
      _subscribedTopics = prefs.getStringList("topicList");
    }

    _subscribedTopics.add(topic);
    prefs.setStringList("topicList", _subscribedTopics);
    notifyListeners();
    addChat(topic);
 }

 void deleteTopics(int index) async {
   final prefs = await SharedPreferences.getInstance();

   if(prefs.getStringList("topicList") != null){
     _subscribedTopics = prefs.getStringList("topicList");
   }

   _subscribedTopics.removeAt(index);
   prefs.setStringList("topicList", _subscribedTopics);
    notifyListeners();
    deleteChat(index);
 }

 void setTopics() async {
   final prefs = await SharedPreferences.getInstance();

   if(prefs.getStringList("topicList") != null){
     _subscribedTopics = prefs.getStringList("topicList");
   }

   prefs.setStringList("topicList", _subscribedTopics);
   notifyListeners();
   setChats();
 }

  void deleteChat(int index){
    _chatMessages.removeAt(index);
    notifyListeners();
  }

  void addChat(String name){
    _chatMessages.add(Chat(messages: [], username: name));
    notifyListeners();
  }

  void setChats(){
    _subscribedTopics.forEach((topic){
      _chatMessages.add(Chat(messages: [], username: topic));
    });
    notifyListeners();
  }

  void sendMessages(String name,String message,String topic){

    var requiredChat = _chatMessages.firstWhere((chat) => chat.username == topic,orElse: () => null);
    final Message textMessage = Message(username: name,message: message,dateTime: DateTime.now());

    requiredChat.messages.add(textMessage);
    notifyListeners();
  }

}