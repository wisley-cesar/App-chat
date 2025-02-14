import 'dart:async';
import 'dart:io';
import 'dart:nativewrappers/_internal/vm/lib/math_patch.dart';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/auth/auth_services.dart';

class AuthMockService implements AuthServices {
  static Map<String, ChatUser> _users = {};
  static ChatUser? _currentUser;
  static MultiStreamController<ChatUser?>? _controller;

  static final _userStream = Stream<ChatUser?>.multi((controller) {
    _controller = controller;
    _updateUser(null);
  });

  ChatUser? get currentUser {
    return _currentUser;
  }

  @override
  // TODO: implement userChanges
  Stream<ChatUser?> get userChanges {
    return _userStream;
  }

  Future<void> signup(
    String name,
    String email,
    String password,
    File image,
  ) async {
    final newUser = ChatUser(
      id: Random().toString(),
      name: name,
      email: email,
      imageURL: image.path,
    );
    _users.putIfAbsent(email, () => newUser);
    print(newUser.id);
    _updateUser(newUser);
  }

  Future<void> login(
    String email,
    String password,
  ) async {
    _updateUser(_users[email]);
  }

  Future<void> logout() async {
    _updateUser(null);
  }

  static void _updateUser(ChatUser? user) {
    _currentUser = user;
    _controller?.add(_currentUser);
  }
}
