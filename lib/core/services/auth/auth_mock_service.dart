import 'dart:io';

import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/auth/auth_services.dart';

class AuthMockService implements AuthServices {
  ChatUser? get currentUser {
    return null;
  }

  @override
  // TODO: implement userChanges
  Stream<ChatUser?> get userChanges => throw UnimplementedError();

  Future<void> signup(
    String name,
    String email,
    String password,
    File image,
  ) async {}
  Future<void> login(
    String email,
    String password,
  ) async {}
  Future<void> logout() async {}
}
