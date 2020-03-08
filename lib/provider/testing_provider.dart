import 'package:flutter/material.dart';

import '../models/chat.dart';

class TestingProvider extends ChangeNotifier{

  var _userName = "";

  final List<Chat> _chatMessages = [
    Chat(message: "jashdajsdhasdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdfasdjhfdbvbvofvblfv jndflvjd fsv dfsvoid fvifvifvnnfidndskfnkfdsjfndjfnsdkfjnsdkfndskfjnsdkfjnsdkfnsdkfnskfnk",datetime: DateTime.now()),
    Chat(message: "kfndskfjnsdkfjnsdkfnsdkfnskfnk",sender: false,datetime: DateTime.now()),
    Chat(message: "jashdajsdhasdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdfasdjhfdbvbvofvblfv jndflvjd fsv dfsvoid fvifvifvnnfidndskfnkfdsjfndjfnsdkfjnsdkfndskfjnsdkfjnsdkfnsdkfnskfnk",datetime: DateTime.now()),
    Chat(message: "jashdajsdhasdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdfasdjhfdbvbvofvblfv jndflvjd fsv dfsvoid fvifvifvnnfidndskfnkfdsjfndjfnsdkfjnsdkfndskfjnsdkfjnsdkfnsdkfnskfnk",datetime: DateTime.now()),
    Chat(message: "jashdajsdhasdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdsdfasdjhfdbvbvofvblfv jndflvjd fsv dfsvoid fvifvifvnnfidndskfnkfdsjfndjfnsdkfjnsdkfndskfjnsdkfjnsdkfnsdkfnskfnk",sender: false,datetime: DateTime.now()),
  ];

  String get username{
    return _userName;
  }

   set setUsername(String name){
    _userName = name;
  }

  List<Chat> get chatMessages {
    return List.from(_chatMessages);
  }

  void sendMessages(String message){
    final Chat textMessage = Chat(message: message,datetime: DateTime.now());
    _chatMessages.add(textMessage);
    notifyListeners();
  }

}