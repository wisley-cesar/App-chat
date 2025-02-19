import 'dart:async';
import 'dart:math';
import 'package:chat/core/models/chat_message.dart';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/chat/chat_service.dart';

class ChatMockService implements ChatService {
  static final List<ChatMessage> _msgs = [
    // ChatMessage(
    //   id: '1',
    //   text: 'Bom dia!',
    //   createdAt: DateTime.now(),
    //   userID: '123',
    //   userName: 'Wisley',
    //   userImageUrl: 'assets/images/avatar.png',
    // ),
    // ChatMessage(
    //   id: '2',
    //   text: 'Bom dia! teremos reunião hoje?',
    //   createdAt: DateTime.now(),
    //   userID: '456',
    //   userName: 'Carlos Teste',
    //   userImageUrl: 'assets/images/avatar.png',
    // ),
    // ChatMessage(
    //   id: '1',
    //   text: 'Bom dia! teremos sim! Pode ser agora?',
    //   createdAt: DateTime.now(),
    //   userID: '123',
    //   userName: 'Wisley ',
    //   userImageUrl: 'assets/images/avatar.png',
    // ),
  ];
  static MultiStreamController<List<ChatMessage>>? _controller;
  static final _msgsStream = Stream<List<ChatMessage>>.multi((controller) {
    _controller = controller;
    _controller?.add(_msgs);
  });

  @override
  Stream<List<ChatMessage>> messagesStream() {
    return _msgsStream;
  }

  @override
  Future<ChatMessage> save(String text, ChatUser user) async {
    final _newMessage = await ChatMessage(
      id: Random().nextDouble().toString(),
      text: text,
      createdAt: DateTime.now(),
      userID: user.id,
      userName: user.name,
      userImageUrl: user.imageURL,
    );
    _msgs.add(_newMessage);

    _controller?.add(_msgs.reversed.toList());
    return _newMessage;
  }
}
