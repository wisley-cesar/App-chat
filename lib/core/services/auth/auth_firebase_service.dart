import 'dart:async';

import 'dart:io';
import 'package:chat/core/models/chat_user.dart';
import 'package:chat/core/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthFirebaseService implements AuthService {
  static ChatUser? _currentUser;
  static MultiStreamController<ChatUser?>? _controller;

  static final _userStream = Stream<ChatUser?>.multi((controller) async {
    final authChanges = FirebaseAuth.instance.authStateChanges();
    await for (final user in authChanges) {
      _currentUser = user == null ? null : _toChatUser(user);

      controller.add(_currentUser);
    }
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
    File? image,
  ) async {
    final auth = FirebaseAuth.instance;
    UserCredential credential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);

    if (credential.user == null) return;

    // 1. Upload da foto do usúario
    final imageName = '${credential.user!.uid}.jpg';
    final imageUrl = await _uploadUserImage(image, imageName);

    // 2. atualizar os atributos do usuário.
    await credential.user?.updateDisplayName(name);
    await credential.user?.updatePhotoURL(imageUrl);

    // 3. salvar o usaúario no banco de dados (opcional)
    await _saveChatUser(_toChatUser(credential.user!, imageUrl));

    // credential.user?.updatePhotoURL();
  }

  Future<void> login(
    String email,
    String password,
  ) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    FirebaseAuth.instance.signOut();
  }

  // static void _updateUser(ChatUser? user) {}

  Future<String?> _uploadUserImage(File? image, String imageName) async {
    if (image == null) return null;

    final storage = FirebaseStorage.instance;

    final imageRef = storage.ref().child('user_images').child(imageName);

    await imageRef.putFile(image).whenComplete(() {});

    return await imageRef.getDownloadURL();
  }

  Future<void> _saveChatUser(ChatUser user) async {
    final store = FirebaseFirestore.instance;
    final docRef = store.collection('users').doc(user.id);

    return docRef.set({
      'name': user.name,
      'email': user.email,
      'imageUrl': user.imageUrl,
    });
  }

  static ChatUser _toChatUser(User user, [String? imageUrl]) {
    return ChatUser(
      id: user.uid,
      name: user.displayName ?? user.email!.split('@')[0],
      email: user.email!,
      imageUrl: imageUrl ?? user.photoURL ?? 'assets/images/avatar.png',
    );
  }
}
