import 'package:flutter/material.dart';

class MessageController with ChangeNotifier {
  final List<Message> messages;

  MessageController() : messages = [];

  void notifyMessage({
    String? type,
    String? level,
    required String message,
  }) {
    messages.add(
      Message(
        type: type ?? 'toast',
        level: level ?? 'info',
        message: message,
      ),
    );
    notifyListeners();
  }
}

class Message {
  final String type;
  final String level;
  final String message;

  Message({
    required this.type,
    required this.level,
    required this.message,
  });
}
